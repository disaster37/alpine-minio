#!/bin/sh -e
DAEMON="${SERVICE_HOME}/bin/minio"
DAEMON_NAME=minio
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

test -x ${DAEMON} || exit 0



d_start () {
        echo "Starting ${DAEMON_NAME}"
        source ${SERVICE_HOME}/conf/minio-server.cfg
	      start-stop-daemon --background --name ${DAEMON_NAME} --start --quiet --stdout ${SERVICE_HOME}/logs/minio.log --stderr ${SERVICE_HOME}/logs/minio.log --exec ${DAEMON} server ${MINIO_VOLUMES}
        echo $?
}

d_stop () {
        echo "Stopping ${DAEMON_NAME}"
        start-stop-daemon --name ${DAEMON_NAME} --stop --retry 5 --quiet
	      echo $?
}

case "$1" in

        start|stop)
                d_${1}
                ;;

        restart|reload|force-reload)
                        d_stop
                        d_start
                ;;

        force-stop)
               d_stop
                killall -q ${DAEMON_NAME} || true
                sleep 2
                killall -q -9 ${DAEMON_NAME} || true
                ;;

        *)
                echo "Usage: minio.sh {start|stop|force-stop|restart|reload|force-reload}"
                exit 1
                ;;
esac
exit 0
