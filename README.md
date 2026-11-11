# Talantaz

Talantaz is a talent and sports management system built with Django REST Framework, React, Vite, and MySQL. Docker Compose is used to run the application services together.

## Technology Stack

- Frontend: React, Vite, Nginx
- Backend: Python, Django, Django REST Framework
- Database: MySQL 8.4
- Containerization: Docker and Docker Compose

## Prerequisites

Install the following software before starting:

- Git
- Docker Desktop
- Docker Compose (included with current Docker Desktop versions)

Make sure Docker Desktop is running.

## 1. Clone the Repository

```bash
git clone https://github.com/sebaisack/Eng-isack-talanta.git
cd Eng-isack-talanta
```

If the repository is private, you must have permission to access it.

## 2. Configure Environment Variables

Create your local environment file from the example:

```bash
cp .env.example .env
```

Open `.env` and replace the example values with strong, unique secrets.

Required settings include:

- `DJANGO_SECRET_KEY`: a long, random Django secret key.
- `MYSQL_ROOT_PASSWORD`: a strong MySQL root password.
- `DJANGO_DEBUG`: keep `False` for production.
- `ALLOWED_HOSTS`: the hostnames used to access the application.
- `CORS_ALLOWED_ORIGINS`: the permitted frontend origins.

The same MySQL password must be used by the database and backend configuration. Follow the environment variable structure in `.env.example`.

Never commit `.env` or share its secrets publicly.

## 3. Start the Application

Build the images and start all services:

```bash
docker compose up -d --build
```

The first build can take several minutes, depending on your internet connection and computer.

Check service status:

```bash
docker compose ps
```

Wait until the database is healthy and the backend and frontend are running.

The backend runs database migrations automatically when its container starts.

## 4. Open Talantaz

Open the frontend in your browser:

http://localhost:5173

The backend API is routed through the frontend's Nginx service under `/api/`.

## 5. Create an Administrator Account

A new installation does not automatically include an administrator account.

Create a Django superuser:

```bash
docker compose exec backend python manage.py createsuperuser
```

Follow the prompts to set the username, email address if requested, and password.

The Django administration page is available at:

http://localhost:5173/admin/

Use the application's appropriate login page for normal Talantaz access.

## Useful Docker Commands

View running services:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs --tail=100
```

View backend logs:

```bash
docker compose logs --tail=100 backend
```

Restart services:

```bash
docker compose restart
```

Stop services without deleting the database volume:

```bash
docker compose down
```

Start them again:

```bash
docker compose up -d
```

**Important:** Do not use `docker compose down -v` unless you intentionally want to remove the database volume. Removing the volume can permanently delete the database stored in it.

## Database and Backups

The MySQL database is stored in a Docker-managed volume. A fresh installation starts with an empty database and applies migrations automatically.

Back up the database regularly and store backups securely outside Git.

A backup from another installation is not included in this repository. Restore one only when you are authorized to use it and have confirmed that it is compatible with your application version.

## Production Deployment (CI/CD)

Production runs at https://talanta.conturetz.com on the server `82.112.231.18`.

Every push and pull request runs the GitHub Actions workflow in `.github/workflows/ci-cd.yml`: backend tests against MySQL, plus frontend lint and build. A push to `main` that passes these checks also builds the backend and frontend images, pushes them to GitHub Container Registry (`ghcr.io/sebaisack/eng-isack-talanta-backend` and `-frontend`, tagged with the commit SHA), and deploys them.

How production is set up on the server:

- The app lives in `/var/www/talanta-docker`. Docker Compose runs only the backend and frontend containers; the compose file comes from `deploy/compose.prod.yaml` in each release.
- The database is the MySQL server installed on the host (database `talents`, user `kabandwa`), not a container.
- The host Nginx terminates HTTPS and proxies to the frontend container on `127.0.0.1:8095`. The site config is in `deploy/nginx/talanta.conturetz.com.conf`.
- Secrets are stored only in `/var/www/talanta-docker/.env` on the server. Use `deploy/production.env.example` as the template.
- GitHub Actions connects as the `tldeploy` user, whose SSH key may only run `deploy/deploy.sh` (installed as `/var/www/talanta-docker/bin/deploy.sh`). Before any migrations run, the script backs up the database to `/var/www/talanta-docker/backups`. It then health-checks the new release and rolls back automatically if the release fails.

Required repository secrets: `DEPLOY_SSH_KEY`, `DEPLOY_KNOWN_HOSTS`, `DEPLOY_HOST`, `DEPLOY_USER`.

Operator commands on the server (as root):

```bash
/var/www/talanta-docker/bin/deploy.sh status
/var/www/talanta-docker/bin/deploy.sh rollback
/var/www/talanta-docker/bin/deploy.sh compose logs --tail=100 backend
/var/www/talanta-docker/bin/deploy.sh compose exec backend python manage.py createsuperuser
```

After changing `deploy/deploy.sh`, copy it to `/var/www/talanta-docker/bin/deploy.sh` on the server, because the deploy key runs that installed copy.

## Security Notes

- Never commit `.env`, passwords, API tokens, or production secrets.
- Do not use example passwords in a real deployment.
- Keep `DJANGO_DEBUG=False` in production.
- Configure `ALLOWED_HOSTS` and `CORS_ALLOWED_ORIGINS` for the actual deployment domain.
- Use HTTPS and secure production infrastructure when exposing the application publicly.

## License

Add the appropriate license before redistributing this project.
