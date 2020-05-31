#!/bin/bash

deploy_moddle()
{
  git clone https://github.com/mclpfr/moodle.git
  cd moodle 
  docker-compose up -d 1>&2
 }
 
set_moddle()
{
  docker exec -it moodle_moodle_1 mkdir -p /bitnami/moodle/moodledata/repository/docker
  BACKUP_MODDLE_FILE=$(ls -ail | grep backup | awk '{print $10}')
  docker cp $BACKUP_MODDLE_FILE moodle_moodle_1:/bitnami/moodle/moodledata/repository/docker
  docker exec -it moodle_moodle_1 chown bitnami:daemon /bitnami/moodle/moodledata/repository/docker
 }
 
show_progress()
{
  echo -n "Starting"
  local -r pid="${1}"
  local -r delay='0.75'
  local spinstr='\|/-'
  local temp
  while true; do 
    sudo grep -i "done" /root/katacoda-finished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Started"
  echo -n "Configuring"
  while true; do 
    sudo grep -i "done" /root/katacoda-background-finished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Configured"
}

deploy_moddle
show_progress
set_moddle
