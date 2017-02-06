#!/usr/bin/env bash

MINIO_DATA=${MINIO_DATA:-"${SERVIVE_HOME}/data"}


cat << EOF > ${SERVICE_VOLUME}/confd/etc/templates/minio-server.cfg.tmpl
MINIO_DATA = ${MINIO_DATA}
MINIO_VOLUMES=${MINIO_DATA}
EOF
