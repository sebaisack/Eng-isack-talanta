#!/usr/bin/env bash
# Talanta production release script. Installed on the server as
# /var/www/talanta-docker/bin/deploy.sh (copy it there by hand when this file changes).
#
#   deploy.sh deploy <git-sha>   pull the backend/frontend images of <git-sha>, back up and migrate
#                                the database if needed, start them, roll back if unhealthy
#   deploy.sh rollback           restart the previously running release (no DB rollback)
#   deploy.sh status             print current/previous release and container health
#   deploy.sh compose <args...>  docker compose for the current release (operators only)
#
# It is also the SSH forced command of the CI deploy key: then it starts without arguments and
# only the commands above (except compose) are accepted.
# A registry token may be supplied on stdin (first line) for private GHCR pulls.
set -euo pipefail

ROOT=/var/www/talanta-docker
COMPOSE_FILE="$ROOT/docker-compose.yml"
STATE="$ROOT/state"
BACKUPS="$ROOT/backups"
LOCK="$STATE/deploy.lock"
HEALTH_URL="http://127.0.0.1:8095/admin/login/"
IMAGE_REPO="ghcr.io/sebaisack/eng-isack-talanta"
RELEASE_PATTERN='^[0-9a-f]{40}$'
REGISTRY_USER="${REGISTRY_USER:-sebaisack}"
DB_NAME="${DB_NAME:-talents}"
KEEP_IMAGES=3

log() { printf '[%s] %s\n' "$(date -u +%FT%TZ)" "$*"; }
die() { log "ERROR: $*"; exit 1; }

if [[ $# -eq 0 && -n "${SSH_ORIGINAL_COMMAND:-}" ]]; then
    read -r -a requested <<<"$SSH_ORIGINAL_COMMAND"
    case "${requested[0]:-}" in
        deploy)
            [[ ${#requested[@]} -eq 2 && "${requested[1]}" =~ $RELEASE_PATTERN ]] || die "rejected: invalid deploy arguments"
            set -- deploy "${requested[1]}" ;;
        rollback|status)
            [[ ${#requested[@]} -eq 1 ]] || die "rejected"
            set -- "${requested[0]}" ;;
        *)
            die "rejected: command not allowed" ;;
    esac
fi

mkdir -p "$STATE" "$BACKUPS"

# Compose would otherwise read $ROOT/.env (the Django secrets file) for variable interpolation.
COMPOSE_ENV="$STATE/compose.env"
[[ -f "$COMPOSE_ENV" ]] || : > "$COMPOSE_ENV"

backend_image() { echo "$IMAGE_REPO-backend:$1"; }
frontend_image() { echo "$IMAGE_REPO-frontend:$1"; }

compose() {
    BACKEND_IMAGE="$(backend_image "$1")" FRONTEND_IMAGE="$(frontend_image "$1")" \
        docker compose --env-file "$COMPOSE_ENV" -f "$COMPOSE_FILE" "${@:2}"
}

current_release() { cat "$STATE/current_release" 2>/dev/null || true; }
previous_release() { cat "$STATE/previous_release" 2>/dev/null || true; }

wait_healthy() {
    local deadline=$((SECONDS + 180))
    while (( SECONDS < deadline )); do
        if curl -fsS --max-time 5 -o /dev/null "$HEALTH_URL"; then
            return 0
        fi
        sleep 5
    done
    return 1
}

registry_login() {
    local token=""
    if [[ ! -t 0 ]]; then
        IFS= read -r token || true
    fi
    if [[ -n "$token" ]]; then
        printf '%s' "$token" | docker login ghcr.io -u "$REGISTRY_USER" --password-stdin >/dev/null
        trap 'docker logout ghcr.io >/dev/null 2>&1 || true' EXIT
    fi
}

pull_release() {
    docker pull --quiet "$(backend_image "$1")" >/dev/null
    docker pull --quiet "$(frontend_image "$1")" >/dev/null
}

backup_database() {
    local tag="$1" file
    [[ -f "$ROOT/.backup.cnf" ]] || die "missing $ROOT/.backup.cnf for the pre-migration backup"
    file="$BACKUPS/pre-migrate-$(date -u +%Y%m%d-%H%M%S)-${tag}.sql.gz"
    log "backing up database to $file"
    mysqldump --defaults-extra-file="$ROOT/.backup.cnf" --single-transaction --routines --triggers \
        --no-tablespaces --set-gtid-purged=OFF "$DB_NAME" | gzip > "$file"
    gzip -t "$file"
    chmod 600 "$file"
    ls -1t "$BACKUPS"/pre-migrate-*.sql.gz 2>/dev/null | tail -n +15 | xargs -r rm -f
}

start_release() {
    compose "$1" up -d --no-build --remove-orphans --wait --wait-timeout 180
}

prune_images() {
    local keep="$(current_release) $(previous_release)" repo ref
    for repo in "$IMAGE_REPO-backend" "$IMAGE_REPO-frontend"; do
        docker images --format '{{.Tag}}' "$repo" | tail -n +$((KEEP_IMAGES + 1)) | while read -r ref; do
            [[ " $keep " == *" $ref "* ]] || docker rmi "$repo:$ref" >/dev/null 2>&1 || true
        done
    done
}

deploy() {
    local release="$1" previous plan
    [[ "$release" =~ $RELEASE_PATTERN ]] || die "refusing unexpected release: $release"
    previous=$(current_release)

    log "pulling release $release"
    registry_login
    pull_release "$release"

    log "installing docker-compose.yml from the release"
    docker run --rm --entrypoint cat "$(backend_image "$release")" /deploy/compose.prod.yaml > "$COMPOSE_FILE.new"
    mv "$COMPOSE_FILE.new" "$COMPOSE_FILE"

    plan=$(compose "$release" run --rm --no-deps -T backend python manage.py showmigrations --plan 2>&1) \
        || { printf '%s\n' "$plan"; die "could not check migration status (is the database reachable?)"; }
    if grep -q '^\[ \]' <<<"$plan"; then
        log "pending migrations:"; grep '^\[ \]' <<<"$plan" || true
        backup_database "${release:0:12}"
        log "running migrations"
        compose "$release" run --rm --no-deps -T backend python manage.py migrate --noinput \
            || die "migrations failed; previous release kept running (restore from $BACKUPS if needed)"
    else
        log "no pending migrations"
    fi

    log "starting release $release"
    if start_release "$release" && wait_healthy; then
        [[ -n "$previous" && "$previous" != "$release" ]] && echo "$previous" > "$STATE/previous_release"
        echo "$release" > "$STATE/current_release"
        echo "$(date -u +%FT%TZ) deployed $release" >> "$STATE/releases.log"
        prune_images
        log "deployment healthy: $release"
        return 0
    fi

    log "new release failed health checks"
    compose "$release" logs --tail=80 || true
    if [[ -n "$previous" && "$previous" != "$release" ]]; then
        log "rolling back to $previous"
        { start_release "$previous" && wait_healthy; } || log "rollback also unhealthy - manual action required"
        echo "$(date -u +%FT%TZ) failed $release, rolled back to $previous" >> "$STATE/releases.log"
    fi
    die "deployment of $release failed"
}

rollback() {
    local target current
    target=$(previous_release); current=$(current_release)
    [[ -n "$target" ]] || die "no previous release recorded"
    log "rolling back from $current to $target (database schema is NOT reverted)"
    if ! docker image inspect "$(backend_image "$target")" "$(frontend_image "$target")" >/dev/null 2>&1; then
        registry_login
        pull_release "$target"
    fi
    start_release "$target"
    wait_healthy || die "rollback target is unhealthy"
    echo "$target" > "$STATE/current_release"
    echo "$current" > "$STATE/previous_release"
    echo "$(date -u +%FT%TZ) rolled back to $target" >> "$STATE/releases.log"
    log "rollback healthy: $target"
}

status() {
    local release
    release=$(current_release)
    echo "current:  ${release:-none}"
    echo "previous: $(previous_release)"
    [[ -n "$release" ]] && compose "$release" ps --format 'table {{.Service}}\t{{.Status}}' 2>/dev/null || true
    curl -fsS --max-time 5 -o /dev/null -w 'health: HTTP %{http_code}\n' "$HEALTH_URL" || echo "health check failed"
}

exec 9>"$LOCK"
case "${1:-}" in
    deploy)   [[ $# -eq 2 ]] || die "usage: deploy.sh deploy <git-sha>"; flock -n 9 || die "another deployment is in progress"; deploy "$2" ;;
    rollback) flock -n 9 || die "another deployment is in progress"; rollback ;;
    status)   status ;;
    compose)  [[ -z "${SSH_ORIGINAL_COMMAND:-}" ]] || die "rejected"; shift; compose "$(current_release)" "$@" ;;
    *)        die "usage: deploy.sh {deploy <git-sha>|rollback|status|compose <args>}" ;;
esac
