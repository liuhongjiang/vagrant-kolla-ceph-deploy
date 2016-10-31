#! /bin/env bash

disk_name=`lsblk -o KNAME,TYPE,SIZE,MODEL | grep disk | grep '37G' | awk '{print $1}'`
disk_name="/dev/${disk_name}"

journal_name=`lsblk -o KNAME,TYPE,SIZE,MODEL | grep disk | grep '17G' | awk '{print $1}'`
journal_name="/dev/${journal_name}"

hostname=`hostname`

sudo parted ${disk_name} -s -- mklabel gpt mkpart "KOLLA_CEPH_OSD_BOOTSTRAP_${hostname}" 1 -1
sudo parted ${journal_name} -s -- mklabel gpt mkpart "KOLLA_CEPH_OSD_BOOTSTRAP_${hostname}_J" 1 -1

# allow ssh as root
sudo cp -r /home/vagrant/.ssh /root/

