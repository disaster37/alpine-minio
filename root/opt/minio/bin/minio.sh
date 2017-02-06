#!/sbin/openrc-run


start() {
  if [ "${RC_CMD}" = "restart" ];
  then
    stop
  fi

  ebegin "Starting minio"
  source ${SERVICE_HOME}/conf/minio-server.cfg
  start-stop-daemon --start --exec ${SERVICE_HOME}/bin/minio server ${MINIO_VOLUMES} \
    --pidfile ${SERVICE_HOME}/minio.pid
  eend $?
}

stop() {
  ebegin "Stopping minio"
  start-stop-daemon --stop --exec ${SERVICE_HOME}/bin/minio \
    --pidfile ${SERVICE_HOME}/minio.pid
  eend $?
}
