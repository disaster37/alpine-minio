#!/usr/bin/env bash

cat << EOF > /opt/confd/etc/conf.d/minio-server.cfg.toml
[template]
prefix = "${PREFIX_KEY}"
src = "minio-server.cfg.tmpl"
dest = "${SERVICE_HOME}/conf/minio-server.cfg"
owner = "${SERVICE_USER}"
mode = "0644"
keys = [
  "/disks",
  "/servers",
]

reload_cmd = "${SERVICE_HOME}/bin/minio-service.sh restart"
EOF

cat << EOF > /opt/confd/etc/templates/minio-server.cfg.tmpl

{{ if (getenv "SCHEDULER_INSTANCES") }}
  {{ \$servers := split (getenv "SCHEDULER_INSTANCES") "," }}
  {{ \$length := len \$servers}} {{if eq \$length 1}}
MINIO_VOLUMES="{{range \$i, \$diskName := ls "/disks"}}${SERVICE_HOME}/data/{{getv (printf "/disks/%s" \$diskName)}} {{end}}"
    {{ else }}
MINIO_VOLUMES="{{range \$i, \$ip := \$servers}}{{range \$j, \$diskName := ls "/disks"}}http://{{\$ip}}${SERVICE_HOME}/data/{{getv (printf "/disks/%s" \$diskName)}} {{end}}{{end}}"
    {{ end }}

{{ else }}
  {{ \$length := len (ls "/servers")}} {{if lt \$length 2}}
MINIO_VOLUMES="{{range \$i, \$diskName := ls "/disks"}}${SERVICE_HOME}/data/{{getv (printf "/disks/%s" \$diskName)}} {{end}}"
  {{ else }}
MINIO_VOLUMES="{{range \$i, \$containerName := ls "/servers"}}{{range \$j, \$diskName := ls "/disks"}}http://{{getv (printf "/servers/%s" \$containerName)}}${SERVICE_HOME}/data/{{getv (printf "/disks/%s" \$diskName)}} {{end}}{{end}}"
  {{ end }}
{{ end }}
EOF
