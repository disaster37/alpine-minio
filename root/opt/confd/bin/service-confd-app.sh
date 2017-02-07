#!/usr/bin/env bash

set -e

function log {
        echo `date` $ME - $@ >> ${CONF_LOG}
}

function checkNetwork {
    log "[ Checking container ip... ]"
    a="`ip a s dev eth0 &> /dev/null; echo $?`"
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`"
        sleep 1
    done

    log "[ Checking container connectivity... ]"
    b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
    while [ $b -eq 1 ];
    do
        b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
        sleep 1
    done
}

function serviceTemplate {
    log "[ Checking ${CONF_NAME} template... ]"
    bash ${CONF_HOME}/bin/gen.conf-app.tmpl.sh
}

function serviceStart {
    checkNetwork
    serviceTemplate
    log "[ Starting ${CONF_NAME}... ]"
    start-stop-daemon --background --name ${CONF_NAME} --start --quiet --stdout ${SERVICE_HOME}/logs/${CONF_NAME}.log --stderr ${SERVICE_HOME}/logs/${CONF_NAME}.log --pidfile ${SERVICE_HOME}/${CONF_NAME}.pid --exec ${CONF_BIN} -- ${CONF_OPTS}
}

function serviceStop {
    log "[ Stoping ${CONF_NAME}... ]"
    start-stop-daemon --name ${CONF_NAME} --retry 5 --oknodo --stop --quiet --pidfile ${SERVICE_HOME}/${CONF_NAME}.pid --exec ${CONF_BIN}  > /dev/null 2>&1
}

function serviceRestart {
    log "[ Restarting ${CONF_NAME}... ]"
    serviceStop
    serviceStart
    /opt/monit/bin/monit reload
}

CONF_NAME=confd-app
CONF_HOME=${CONF_HOME:-"/opt/tools/confd"}
CONF_LOG=${CONF_LOG:-"${CONF_HOME}/log/confd.log"}
CONF_BIN=${CONF_BIN:-"${CONF_HOME}/bin/confd"}
CONF_BACKEND=${CONF_BACKEND:-"rancher"}
CONF_PREFIX=${CONF_PREFIX:-"/2015-12-19"}
CONF_INTERVAL=${CONF_INTERVAL:-60}
CONF_PARAMS=${CONF_PARAMS:-"-confdir /opt/tools/confd/etc -backend ${CONF_BACKEND} -prefix ${CONF_PREFIX}"}
CONF_ONETIME="${CONF_BIN} -onetime ${CONF_PARAMS}"
CONF_OPTS="-interval ${CONF_INTERVAL} ${CONF_PARAMS}"

case "$1" in
        "start")
            serviceStart >> ${CONF_LOG} 2>&1
        ;;
        "stop")
            serviceStop >> ${CONF_LOG} 2>&1
        ;;
        "restart")
            serviceRestart >> ${CONF_LOG} 2>&1
        ;;
        *) echo "Usage: $0 restart|start|stop"
        ;;

esac
