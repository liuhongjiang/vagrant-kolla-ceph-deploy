#! /bin/env bash

# variables
BRANCH='stable/newton'

# Add docker insecure

hosts=(ceph1 ceph2 ceph3 control1 control2 registry)

for host in ${hosts[@]}
do
    ssh $host 'echo "{ \"insecure-registries\":[\"192.168.60.31:5000\"] }" | sudo tee /etc/docker/daemon.json && sudo systemctl restart docker'
done

echo "{ \"insecure-registries\":[\"192.168.60.31:5000\"] }" | sudo tee /etc/docker/daemon.json && sudo systemctl restart docker


# set up kolla deploy node
sudo yum -y install git

if [ -d kolla ]
then
    cd kolla
    git pull origin ${BRANCH}
    cd ../
else
    git clone --branch ${BRANCH}  https://git.openstack.org/openstack/kolla
fi

sudo pip install -r kolla/requirements.txt -r kolla/test-requirements.txt

sudo pip install -U python-openstackclient python-neutronclient

cd kolla

sudo pip install .

sudo mkdir /etc/kolla/
sudo cp /home/vagrant/kolla-config/* /etc/kolla/

kolla-build --config-dir /home/vagrant/kolla-config --push


kolla-ansible deploy --configdir /home/vagrant/kolla-config -i /home/vagrant/kolla-config/multinode -vvv

if [ $? -eq 0 ]
then
    mkdir -p /home/vagrant/kolla-deploy
    kolla-ansible post-deploy --configdir /home/vagrant/kolla-config -i /home/vagrant/kolla-config/multinode -vvv
fi
