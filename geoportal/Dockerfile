FROM camptocamp/geomapfish-tools:latest as builder
LABEL maintainer Camptocamp "info@camptocamp.com"

WORKDIR /app
COPY webpack.*.js Makefile CONST_Makefile /app/
COPY geomapfish_geoportal/static-ngeo /app/geomapfish_geoportal/static-ngeo
RUN make apps

COPY . /app

RUN make checks
RUN make build
RUN mv webpack.apps.js webpack.apps.js.tmpl && \
    ln --symbolic /usr/lib/node_modules/ .

ENTRYPOINT [ "/usr/bin/eval-templates" ]
CMD [ "webpack-dev-server", "--mode=development", "--debug", "--watch", "--no-inline" ]

###############################################################################

FROM camptocamp/geomapfish:2.6 as runner

#RUN apt update
#RUN apt install --yes gcc python3.7-dev
COPY requirements.txt /tmp/requirements.txt
RUN \
  python3 -m pip install --disable-pip-version-check --no-cache-dir --requirement=/tmp/requirements.txt && \
  rm --recursive --force /tmp/* /var/tmp/* /root/.cache/*

WORKDIR /app
COPY . /app
# Workaround, see:https://github.com/moby/moby/issues/37965
RUN true
COPY --from=builder /usr/lib/node_modules/ngeo/dist/* /etc/static-ngeo/
COPY --from=builder /etc/static-ngeo/* /etc/static-ngeo/
COPY --from=builder /app/alembic.ini /app/alembic.yaml ./
RUN chmod go+w /etc/static-ngeo/

RUN python3 -m pip install --disable-pip-version-check --no-cache-dir --editable=/app/ && \
    python3 -m compileall -q /usr/local/lib/python3.8 \
        -x '/usr/local/lib/python3.8/dist-packages/(ptvsd|pipenv|.*pydev.*)/' && \
    python3 -m compileall -q /app/geomapfish_geoportal -x /app/geomapfish_geoportal/static.*

ARG GIT_HASH
RUN c2cwsgiutils-genversion ${GIT_HASH}

ARG PGSCHEMA
ENV PGSCHEMA=${PGSCHEMA}

ENTRYPOINT [ "/usr/bin/eval-templates" ]
CMD ["c2cwsgiutils-run"]

ENV VISIBLE_ENTRY_POINT=/ \
    AUTHTKT_TIMEOUT=86400 \
    AUTHTKT_REISSUE_TIME=9000 \
    AUTHTKT_MAXAGE=86400 \
    AUTHTKT_COOKIENAME=auth_tkt \
    AUTHTKT_HTTP_ONLY=True \
    AUTHTKT_SECURE=True \
    AUTHTKT_SAMESITE=Lax \
    BASICAUTH=False \
    LOG_LEVEL=INFO \
    C2CGEOPORTAL_LOG_LEVEL=INFO \
    C2CWSGIUTILS_LOG_LEVEL=INFO \
    GUNICORN_LOG_LEVEL=INFO \
    SQL_LOG_LEVEL=WARN \
    DOGPILECACHE_LOG_LEVEL=INFO \
    OTHER_LOG_LEVEL=WARN \
    DEVELOPMENT=False
