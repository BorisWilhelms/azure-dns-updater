ARG IMAGE=ghcr.io/boriswilhelms/azure-cli-armv7:latest
FROM $IMAGE

RUN apk add --no-cache bind-tools && \
    mkdir /app

WORKDIR /app
COPY script/ .

ENTRYPOINT [ "/app/updater.sh" ]`