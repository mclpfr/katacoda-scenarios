#!/bin/bash

deploy_moddle()
{
  git clone https://github.com/mclpfr/moodle.git
  cd moodle 
  docker-compose up -d 1>&2
 }
 
sleep 1
echo "done" >> /root/katacoda-finished
sleep 20
deploy_moddle & >/dev/null 2>&1
echo "done" >> /root/katacoda-background-finished
