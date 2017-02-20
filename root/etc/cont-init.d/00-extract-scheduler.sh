#!/usr/bin/with-contenv sh

if [ -d "${SCHEDULER_VOLUME}/script.d" ]; then
  exec sh ${SCHEDULER_VOLUME}/script.d/*
fi
