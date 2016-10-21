#! /bin/env bash

flag=`grep "kolla" /etc/hosts | grep -v "127.0.0.1" | wc -l`

if [ $flag -eq 0 ]
then
sudo cat <<hostsdoc >> /etc/hosts
192.168.60.11    kolla
192.168.60.21    ceph1
192.168.60.22    ceph2
192.168.60.23    ceph3
hostsdoc
fi

# add ssh password 
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

# add ssh known_hosts automatically
sudo sed -i "s/^\tGSSAPIAuthentication yes/\tGSSAPIAuthentication yes\n\tStrictHostKeyChecking no/g" /etc/ssh/ssh_config

sudo service sshd restart

sudo setenforce 0
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install -U pip
pip -V
sudo yum -y install python-devel libffi-devel gcc openssl-devel

# install docker
curl -sSL https://get.docker.io | sudo bash
sudo usermod -aG docker vagrant

# Create the drop-in unit directory for docker.service
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create the drop-in unit file
sudo tee /etc/systemd/system/docker.service.d/kolla.conf <<-'EOF'
[Service]
MountFlags=shared
EOF

# Run these commands to reload the daemon
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo pip install -U docker-py

sudo yum -y install ntp
sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service

sudo systemctl stop libvirtd.service
sudo systemctl disable libvirtd.service

sudo pip install -U ansible

