#!/bin/bash
 
set_moddle()
{
  cd moodle
  docker exec -it moodle_moodle_1 mkdir -p /bitnami/moodle/moodledata/repository/docker
  BACKUP_MODDLE_FILE=$(ls -ail | grep backup | awk '{print $10}')
  docker cp $BACKUP_MODDLE_FILE moodle_moodle_1:/bitnami/moodle/moodledata/repository/docker
  docker exec -it moodle_moodle_1 chown bitnami:daemon /bitnami/moodle/moodledata/repository/docker
 }
 
restore_course()
{
  apt update -y
  apt install wget unzip -y
  wget https://moodle.org/plugins/download.php/21420/moosh_moodle38_2020042300.zip
  unzip moosh_moodle38_2020042300.zip
  ln -s $PWD/moosh.php /usr/local/bin/moosh
  cd /bitnami/moodle/moodledata/repository/docker
  moosh -n course-restore backup-moodle2-course-59-d_-_module_12_-_docker-20200513-0726.mbz 1
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
  deploy_moddle >/dev/null 2>&1
  printf "    \b\b\b\b"
  echo ""
  echo "Déploiement terminé"
}

show_progress
set_moddle
#restore_course
