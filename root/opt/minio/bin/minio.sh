#!/sbin/openrc-run


DAEMON="${SERVICE_HOME}/bin/minio"

start() {
  if [ "${RC_CMD}" = "restart" ];
  then
    stop
  fi

  ebegin "Starting minio"
  source ${SERVICE_HOME}/conf/minio-server.cfg
  start-stop-daemon --background --name minio --start --exec ${SERVICE_HOME}/bin/minio server ${MINIO_VOLUMES}
  eend $?
}

stop() {
  ebegin "Stopping minio"
  start-stop-daemon --name minio --stop
  eend $?
}
