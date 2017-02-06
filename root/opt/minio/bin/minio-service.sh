#!/usr/bin/env bash

SERVICE_LOG_DIR=${MINIO_LOG_DIRS:-${SERVICE_HOME}"/logs"}
SERVICE_LOG_FILE=${SERVICE_LOG_FILE:-${SERVICE_LOG_DIR}"/server.log"}

function log {
        echo `date` $ME - $@
}

function serviceDefault {
    log "[ Applying default ${SERVICE_NAME} configuration... ]"
    ${SERVICE_HOME}/bin/minio-server.cfg.sh
}

function serviceConf {
    log "[ Applying dinamic ${SERVICE_NAME} configuration... ]"
    while [ ! -f ${SERVICE_CONF} ]; do
        log " Waiting for ${SERVICE_NAME} configuration..."
        sleep 3
    done
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} log to stdout... ]"
    if [ ! -L ${SERVICE_LOG_FILE} ]; then
        rm ${SERVICE_LOG_FILE}
        ln -sf /proc/1/fd/1 ${SERVICE_LOG_FILE}
    fi
}

function serviceCheck {
    log "[ Checking ${SERVICE_NAME} configuration... ]"

    if [ -d "${SERVICE_VOLUME}" ]; then
        serviceConf
    else
        serviceDefault
    fi
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    serviceCheck
    serviceLog
    ${SERVICE_HOME}/bin/minio.sh start
}

function serviceStop {
    log "[ Stoping ${SERVICE_NAME}... ]"
    ${SERVICE_HOME}/bin/minio.sh stop
}

function serviceRestart {
    log "[ Restarting ${SERVICE_NAME}... ]"
    serviceStop
    serviceStart
    /opt/monit/bin/monit reload
}

case "$1" in
        "start")
            serviceStart
        ;;
        "stop")
            serviceStop
        ;;
        "restart")
            serviceRestart
        ;;
        *)
            echo "Usage: $0 restart|start|stop"
            exit 1
        ;;

esac

exit 0
