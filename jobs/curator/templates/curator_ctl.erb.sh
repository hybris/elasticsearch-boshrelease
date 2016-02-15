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
      <% if spec.index.to_i == 0 %>
      echo "/var/vcap/jobs/curator/bin/index_cleanup.sh" >> /etc/cron.hourly/curator
      <% else %>
      echo "#/var/vcap/jobs/curator/bin/index_cleanup.sh" >> /etc/cron.hourly/curator
      <% end %>
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
