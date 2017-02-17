#!/usr/bin/with-contenv sh

exec cat << EOF > ${CONFD_HOME}/etc/conf.d/minio-run.toml
[template]
prefix = "${CONFD_PREFIX_KEY}"
src = "minio-run.tmpl"
dest = "/etc/services.d/minio/run"
mode = "0744"
keys = [
  "/servers",
  "/disks"
]
reload_cmd = "s6-svscanctl -t /var/run/s6/services"
EOF
