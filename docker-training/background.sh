#!/bin/bash
set -x
sleep 1
echo "done" >> /root/katacoda-finished

deploy_moddle()
{
  git clone https://github.com/mclpfr/moodle.git
  cd moodle 
  echo "Avant docker-compose"
  docker-compose up -d 1>&2
  echo "Apres docker-compose"
  sleep 1
  echo "Avant docker mkdir"
  docker exec -it moodle_moodle_1 mkdir -p /bitnami/moodle/moodledata/repository/docker
  echo "Après docker mkdir"
  BACKUP_MODDLE_FILE=$(ls -ail | grep backup | awk '{print $10}')
  docker cp $BACKUP_MODDLE_FILE moodle_moodle_1:/bitnami/moodle/moodledata/repository/docker
  docker exec -it moodle_moodle_1 chown bitnami:daemon /bitnami/moodle/moodledata/repository/docker
 }
 
 deploy_moddle
 
sleep 1
echo "done" >> /root/katacoda-background-finished
