<<<<<<< HEAD
FROM rawmind/rancher-tools:0.3.4-7
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Set environment
ENV SERVICE_NAME=minio \
=======
FROM rawmind/alpine-monit:0.5.20-4
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

ENV SERVICE_NAME=minio \
    SERVICE_HOME=/opt/minio \
    SERVICE_VERSION=RELEASE.2017-01-25T03-14-52Z \
    SERVICE_CONF=/opt/minio/conf/minio-server.cfg \
>>>>>>> 5faa096b048a8b3cf66a50c9e34cbdcb573eab3a
    SERVICE_USER=minio \
    SERVICE_UID=10003 \
    SERVICE_GROUP=minio \
    SERVICE_GID=10003 \
<<<<<<< HEAD
    SERVIVE_HOME=/opt/mino \
    SERVICE_ARCHIVE=/opt/minio-rancher-tools.tgz

# Add files
ADD root /
RUN cd ${SERVICE_VOLUME} && \
    chmod 755 ${SERVICE_VOLUME}/confd/bin/*.sh && \
    tar czvf ${SERVICE_ARCHIVE} * && \
    rm -rf ${SERVICE_VOLUME}/*
=======
    SERVICE_VOLUME=/opt/tools \
    PATH=/opt/minio/bin:${PATH}

# Install Glibc
ENV GLIBC_VERSION="2.23-r1"
RUN \
    apk add --update -t deps wget ca-certificates &&\
    cd /tmp &&\
    wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk &&\
    wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk &&\
    apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk &&\
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib/ &&\
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
    apk del --purge deps &&\
    rm /tmp/* /var/cache/apk/*

# Install service software
RUN apk update && apk add openrc &&\
    mkdir -p ${SERVICE_HOME}/logs ${SERVICE_HOME}/data ${SERVICE_HOME}/bin ${SERVICE_HOME}/conf && \
    addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
    adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_HOME} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER}

ADD https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.${SERVICE_VERSION} ${SERVICE_HOME}/bin/minio

ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/* \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} /opt/monit

USER $SERVICE_USER
WORKDIR $SERVICE_HOME
VOLUME ${SERVICE_HOME}/data

EXPOSE 9000
>>>>>>> 5faa096b048a8b3cf66a50c9e34cbdcb573eab3a
