#! /bin/env bash

sudo yum -y install git

if [ -d kolla ]
then
    cd kolla
    git pull origin master
    cd ../
else
    git clone https://git.openstack.org/openstack/kolla
fi

sudo pip install -r kolla/requirements.txt -r kolla/test-requirements.txt

sudo pip install -U python-openstackclient python-neutronclient

cd kolla

sudo pip install .

sudo mkdir /etc/kolla/
sudo cp /home/vagrant/kolla-config/* /etc/kolla/

kolla-build --config-dir /home/vagrant/kolla-config --push

kolla-ansible deploy --configdir /home/vagrant/kolla-config -i /home/vagrant/kolla-config/multinode -vvv

