# Small self-contained runtime example for lifecycle and hardening exercises.
FROM python:3.12-slim

RUN useradd --system --uid 10001 appuser \
    && mkdir -p /app \
    && printf '%s\n' '<!doctype html><title>platform-demo</title><h1>platform-demo</h1>' > /app/index.html \
    && chown -R 10001:10001 /app

WORKDIR /app
USER 10001

EXPOSE 8080

# Exec form keeps the server as PID 1 so signals are delivered directly.
ENTRYPOINT ["python", "-m", "http.server", "8080"]
