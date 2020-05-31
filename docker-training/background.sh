#!/bin/bash

set_moddle()
{
  docker exec -it moodle_moodle_1 mkdir -p /bitnami/moodle/moodledata/repository/docker
  BACKUP_MODDLE_FILE=$(ls -ail | grep backup | awk '{print $10}')
  docker cp $BACKUP_MODDLE_FILE moodle_moodle_1:/bitnami/moodle/moodledata/repository/docker
  docker exec -it moodle_moodle_1 chown bitnami:daemon /bitnami/moodle/moodledata/repository/docker
 }

sleep 1
echo "done" >> /root/katacoda-finished
set_moddle
sleep 10
echo "done" >> /root/katacoda-background-finished
