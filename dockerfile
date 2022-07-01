ARG IMAGE=ghcr.io/boriswilhelms/azure-cli-armv7:latest
FROM $IMAGE

RUN apk add --no-cache bind-tools && \
    addgroup --system app && \
    adduser --system --disabled-password --home /app app && \
    chown -R app:app /app

USER app

WORKDIR /app
COPY script/ .

CMD [ "/app/updater.sh" ]`