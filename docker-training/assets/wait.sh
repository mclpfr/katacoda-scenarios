#!/bin/bash

deploy_moddle()
{
  git clone https://github.com/mclpfr/moodle.git
  cd moodle 
  echo "Avant docker-compose"
  docker-compose up -d 1>&2
  echo "Apres docker-compose"
  sleep 240
  echo "Avant docker mkdir"
  docker exec -it moodle_moodle_1 mkdir -p /bitnami/moodle/moodledata/repository/docker
  echo "Après docker mkdir"
  BACKUP_MODDLE_FILE=$(ls -ail | grep backup | awk '{print $10}')
  docker cp $BACKUP_MODDLE_FILE moodle_moodle_1:/bitnami/moodle/moodledata/repository/docker
  docker exec -it moodle_moodle_1 chown bitnami:daemon /bitnami/moodle/moodledata/repository/docker
 }
  
show_progress()
{
  #echo -n "Starting"
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
  #echo ""
  #echo "Started"
  echo -n "Déploiement de la plateforme Moodle en cours"
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
  deploy_moddle 1>&2
  echo "Déploiement terminé"
}

show_progress
