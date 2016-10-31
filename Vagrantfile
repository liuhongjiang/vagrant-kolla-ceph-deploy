# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  config.vm.box = "centos/7"

  config.vm.define "kolla" do |kolla|
    kolla.vm.network "private_network", ip: "192.168.60.11"
    kolla.vm.hostname = "kolla"
    kolla.vm.provision "shell", path: "kolla-provision.sh"
    kolla.vm.provision "file", source: "ssh-keys/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
    kolla.vm.provision "file", source: "ssh-keys/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
    kolla.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"

    kolla.vm.provision "shell", inline: "mkdir -p /home/vagrant/kolla-config/ && chown vagrant:vagrant /home/vagrant/kolla-config/"
    kolla.vm.provision "file", source: "kolla-config/globals.yml", destination: "/home/vagrant/kolla-config/globals.yml"
    kolla.vm.provision "file", source: "kolla-config/kolla-build.conf", destination: "/home/vagrant/kolla-config/kolla-build.conf"
    kolla.vm.provision "file", source: "kolla-config/multinode", destination: "/home/vagrant/kolla-config/multinode"
    kolla.vm.provision "file", source: "kolla-config/passwords.yml", destination: "/home/vagrant/kolla-config/passwords.yml"

    kolla.vm.provision "file", source: "deploy.sh", destination: "/home/vagrant/deploy.sh"
  end

  (1..3).each do |i|
  #(1..1).each do |i|
    config.vm.define "ceph#{i}" do |node|
      file_to_disk = "./tmp/large_disk#{i}.vdi"
      file_to_journal = "./tmp/large_disk#{i}_j.vdi"
      node.vm.network "private_network", ip: "192.168.60.2#{i}"
      node.vm.hostname = "ceph#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata']
        if ARGV[0] == "up" && ! File.exist?(file_to_disk)
          vb.customize ['createhd', '--filename', file_to_disk, '--size', 37 * 1024]
        end
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        if ARGV[0] == "up" && ! File.exist?(file_to_journal)
          vb.customize ['createhd', '--filename', file_to_journal, '--size', 17 * 1024]
        end
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_journal]
      end
      node.vm.provision "shell", path: "kolla-provision.sh"
      node.vm.provision "file", source: "ssh-keys/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
      node.vm.provision "file", source: "ssh-keys/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
      node.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
      node.vm.provision "shell", path: "ceph-partition-provision.sh"
    end
  end 
  
  config.vm.define "registry" do |registry|
    registry.vm.network "private_network", ip: "192.168.60.31"
    registry.vm.hostname = "registry"

    registry.vm.provision "shell", path: "registry-provision.sh"
  end

end
