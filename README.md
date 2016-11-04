This repository is used to deploy an developing environment of openstack.

* It will deploy ceph_osd as cinder driver, on the virtulbox vms ceph1/ceph2/ceph3

* It will deploy ceph_mon, cinder, keystone, horizon on the controller node

## prerequisition

* centos 7.2
* more than 8GB memory
* vagrant 1.7.4 installed. (only test on vagrant 1.7.4)


## how to use

After get the code, change into the code directory and execute the following command.
```
vagrant up
```

After the vms are started, checking the running vms:
```
vboxmanage list runningvms
```

login to kolla node by SSH:
```
vagrant ssh kolla
```

After login, then execute the deploy.sh script:

``` 
sh -x deploy.sh
```

the deploy.sh will check out the kolla code and install it, then build openstack docker images, and deploy to ceph and control nodes.


