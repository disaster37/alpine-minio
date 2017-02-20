#!/bin/sh

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

exec ${CONFD_HOME}/bin/confd -confdir ${CONFD_HOME}/etc -sync-only -onetime -backend ${CONFD_BACKEND} ${PREFIX} ${NODE}
