#!/bin/bash
set -x
deploy_moddle()
{
  git clone https://github.com/mclpfr/moodle.git
  cd moodle 
  docker-compose up -d 1>&2
 }
 
sleep 1
echo "done" >> /root/katacoda-finished
deploy_moddle
sleep 240
echo "done" >> /root/katacoda-background-finished
