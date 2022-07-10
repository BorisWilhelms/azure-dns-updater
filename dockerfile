FROM python:3.10-alpine

RUN apk add --no-cache bash openssh ca-certificates jq curl openssl perl git zip bind-tools  \
 && apk add --no-cache --virtual .build-deps gcc make openssl-dev libffi-dev musl-dev linux-headers rust cargo \ 
 && apk add --no-cache libintl icu-libs libc6-compat \
 && update-ca-certificates \ 
 && pip install -U azure-cli --no-cache-dir \
 && apk del .build-deps \
 && addgroup --system app \
 && adduser --system --disabled-password --home /app app \
 && chown -R app:app /app

USER app

WORKDIR /app
COPY script/ .

CMD [ "/app/updater.sh" ]`

