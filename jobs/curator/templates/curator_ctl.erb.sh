#!/bin/bash

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

RUN_DIR=/var/vcap/sys/run/curator
LOG_DIR=/var/vcap/sys/log/curator

case $1 in

  start)
    mkdir -p $LOG_DIR
    chown -R vcap:vcap $LOG_DIR

    echo "Starting curator process at "`date` >> ${LOG_DIR}/curator.log
    if [ ! -f /etc/cron.hourly/curator ]
    then
      echo "#!/bin/sh" > /etc/cron.hourly/curator
      echo " " >> /etc/cron.hourly/curator
      echo "/var/vcap/packages/curator/python/bin/curator --timeout 900 delete indices --older-than <%= p("curator.retention_days") %> --time-unit days --timestring %Y.%m.%d" >> /etc/cron.hourly/curator
      chmod +x /etc/cron.hourly/curator
    fi
    ;;

  stop)

    echo "Stopping curator process at "`date` >> ${LOG_DIR}/curator.log
    if [ -f /etc/cron.hourly/curator ]
    then
      rm -f /etc/cron.hourly/curator
    fi
    ;;

  *)
    echo "Usage: curator_ctl {start|stop}" ;;

esac
