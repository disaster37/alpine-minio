FROM rawmind/rancher-tools:0.3.4-7
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Set environment
ENV SERVICE_NAME=minio \
    SERVICE_USER=minio \
    SERVICE_UID=10003 \
    SERVICE_GROUP=minio \
    SERVICE_GID=10003 \
    SERVIVE_HOME=/opt/mino \
    SERVICE_ARCHIVE=/opt/minio-rancher-tools.tgz

# Add files
ADD root /
RUN cd ${SERVICE_VOLUME} && \
    chmod 755 ${SERVICE_VOLUME}/confd/bin/*.sh && \
    tar czvf ${SERVICE_ARCHIVE} * && \
    rm -rf ${SERVICE_VOLUME}/*
