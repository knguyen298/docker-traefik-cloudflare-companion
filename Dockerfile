FROM docker.io/library/python:3.12-alpine

LABEL org.opencontainers.image.source="https://github.com/knguyen298/docker-traefik-cloudflare-companion"

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    LOG_PATH=/logs \
    LOG_FILE=tcc.log \
    LOG_TYPE=BOTH

# Unprivileged user that can be selected with `user: 8080:<docker socket gid>`.
# The default user stays root so that the Docker socket is readable out of the box.
RUN addgroup -S -g 8080 tcc && \
    adduser -D -S -s /sbin/nologin -h /dev/null -G tcc -g tcc -u 8080 tcc && \
    mkdir -p /logs && \
    chown tcc:tcc /logs && \
    chmod 775 /logs

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -f /tmp/requirements.txt

COPY install/usr/sbin/cloudflare-companion /usr/sbin/cloudflare-companion
RUN chmod 0755 /usr/sbin/cloudflare-companion

VOLUME ["/logs"]

CMD ["python3", "-u", "/usr/sbin/cloudflare-companion"]
