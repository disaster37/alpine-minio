FROM alpine:3.5
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Application settings
ENV CONFD_PREFIX_KEY="/minio" \
    CONFD_PREFIX_URL="" \
    CONFD_BACKEND="env" \
    CONFD_INTERVAL="60" \
    CONFD_NODES="" \
    APP_HOME="/opt/minio" \
    APP_VERSION="RELEASE.2017-01-25T03-14-52Z" \
    SERVICE_SCHEDULER="/opt/scheduler" \
    USER=minio \
    GROUP=minio \
    UID=10003 \
    GID=10003 \
    MINIO_DISKS_1="disk1"

# Install confd
ENV CONFD_VERSION="v0.13.6" \
    CONFD_HOME="/opt/confd"
ADD https://github.com/yunify/confd/releases/download/${CONFD_VERSION}/confd-alpine-amd64.tar.gz ${CONFD_HOME}/bin/
RUN mkdir -p "${CONFD_HOME}/etc/conf.d" "${CONFD_HOME}/etc/templates" "${CONFD_HOME}/log" &&\
    tar -xvzf "${CONFD_HOME}/bin/confd-alpine-amd64.tar.gz" -C "${CONFD_HOME}/bin/" &&\
    rm "${CONFD_HOME}/bin/confd-alpine-amd64.tar.gz"

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /


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

# Install minio software
ADD https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.${APP_VERSION} ${APP_HOME}/bin/minio
RUN mkdir -p ${APP_HOME}/log /data ${APP_HOME}/bin ${APP_HOME}/conf && \
    addgroup -g ${GID} ${GROUP} && \
    adduser -g "${USER} user" -D -h ${APP_HOME} -G ${GROUP} -s /bin/sh -u ${UID} ${USER}


ADD root /
RUN chmod +x ${APP_HOME}/bin/* &&\
    chown -R ${USER}:${GROUP} ${APP_HOME}


VOLUME ["/data"]
EXPOSE 9000
CMD ["/init"]
