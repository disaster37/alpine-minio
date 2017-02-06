FROM rawmind/alpine-monit:0.5.20-4
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

ENV SERVICE_NAME=minio \
    SERVICE_HOME=/opt/minio \
    SERVICE_CONF=/opt/minio/conf/minio-server.cfg \
    SERVICE_USER=minio \
    SERVICE_UID=10003 \
    SERVICE_GROUP=minio \
    SERVICE_GID=10003 \
    SERVICE_VOLUME=/opt/tools \
    PATH=/opt/minio/bin:${PATH}

# Install service software
RUN SERVICE_RELEASE=minio && \
    mkdir -p ${SERVICE_HOME}/logs ${SERVICE_HOME}/data ${SERVICE_HOME}/bin && \
    cd ${SERVICE_HOME}/bin && \
    curl -sSLO "https://dl.minio.io/server/minio/release/linux-amd64/minio" && \
    addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
    adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_HOME} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER}

ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/* \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} /opt/monit

USER $SERVICE_USER
WORKDIR $SERVICE_HOME
VOLUME ${SERVICE_HOME}/data

EXPOSE 9000
