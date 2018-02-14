# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.ssh.insert_key = false
config.ssh.username = 'vagrant'
config.ssh.password = 'vagrant'
  config.vm.box       = "ubuntu/xenial64"
# give vm a host name
  config.vm.hostname  = "travelWatamu"
# link working folders to home dir on the vm
  config.vm.synced_folder ".", "/home/vagrant/travelWatamu"
# disable the default mounting point
  # config.vm.synced_folder ".", "/vagrant", disabled: true 

  config.vm.network :forwarded_port, guest: 3000, host: 3000    # rails
  config.vm.network :forwarded_port, guest: 9292, host: 9292    # rack
  config.vm.network :forwarded_port, guest: 4567, host: 4567    # sinatra
  config.vm.network :forwarded_port, guest: 1080, host: 1080    # mailcatcher
  config.vm.network :forwarded_port, guest: 8888, host: 8888    # jasmine
  # config.vm.network :forwarded_port, guest: 3306, host: 3306    # mysql
  config.vm.network :forwarded_port, guest: 1234, host: 1234    # node
  config.vm.network :forwarded_port, guest: 5432, host: 5432    # postgresql
  config.vm.network :forwarded_port, guest: 6379, host: 6378    # redis
  config.vm.network :forwarded_port, guest: 9200, host: 9200    # elasticsearch
  config.vm.network :forwarded_port, guest: 27017, host: 27017  # mongodb
  config.vm.network :forwarded_port, guest: 80, host: 8080      # apache/nginx

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true, privileged: false

  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
    v.cpus = 1
  end
end
