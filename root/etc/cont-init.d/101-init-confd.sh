#!/usr/bin/with-contenv sh

if [ "${CONFD_PREFIX_URL}X" == "X" ]; then
  PREFIX=""
else
  PREFIX="-prefix ${CONFD_PREFIX_URL}"
fi

if [ "${CONFD_NODES}X" == "X" ]; then
  NODE=""
else
  NODE="-node ${CONFD_NODES}"
fi

# Get setting from scheduler
if [ -f "${SCHEDULER_VOLUME}/conf/scheduler.cfg" ]; then
  source "${SCHEDULER_VOLUME}/conf/scheduler.cfg"
fi

exec ${CONFD_HOME}/bin/confd -confdir ${CONFD_HOME}/etc -sync-only -onetime -backend ${CONFD_BACKEND} ${PREFIX} ${NODE}
