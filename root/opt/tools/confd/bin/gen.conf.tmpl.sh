#!/usr/bin/env bash

MINIO_DATA=${MINIO_DATA:-"${SERVIVE_HOME}/data"}


cat << EOF > ${SERVICE_VOLUME}/confd/etc/conf.d/minio-server.cfg.toml
[template]
src = "minio-server.cfg.tmpl"
dest = "${SERVICE_HOME}/conf/mino-server.cfg"
owner = "${SERVICE_USER}"
mode = "0644"
keys = [
  "/containers",
]

reload_cmd = "${SERVICE_HOME}/bin/minio.sh restart"
EOF

cat << EOF > ${SERVICE_VOLUME}/confd/etc/templates/minio-server.cfg.tmpl
MINIO_DATA=${MINIO_DATA}
MINIO_VOLUMES={{ range \$i, \containerName := ls "/containers"}}http://{{getv (printf "/containers/%s/primary_ip" \$containerName)}}${MINIO_DATA} {{end}}
EOF
