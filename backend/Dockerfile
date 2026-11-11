FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential pkg-config default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN DJANGO_SECRET_KEY=collectstatic-only python manage.py collectstatic --noinput

# The server's deploy script extracts this file from the release image.
COPY --from=deploy compose.prod.yaml /deploy/compose.prod.yaml

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers ${GUNICORN_WORKERS:-1} --timeout 120 --access-logfile -"]
