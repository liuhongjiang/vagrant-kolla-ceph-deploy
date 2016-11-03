#! /bin/env bash

sudo yum update -y

curl -fsSL https://get.docker.com/ | sudo sh

sudo usermod -aG docker vagrant

#exec bash

sudo systemctl enable docker.service
sudo systemctl start docker

lines=`docker ps | grep "registry$" | wc -l`

if [ $lines -eq 0 ]
then
  docker run -d -p 5000:5000 --restart=always --name registry registry:2
fi
