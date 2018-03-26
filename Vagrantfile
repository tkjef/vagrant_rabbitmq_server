# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Environment variables may be used to control the behavior of the Vagrant VM's
# defined in this file.  This is intended as a special-purpose affordance and
# should not be necessary in normal situations.  In particular, sensu-server,
# sensu-server-enterprise, and sensu-server-puppet5 use the same IP address by
# default, creating a potential IP conflict.  If there is a need to run multiple
# server instances simultaneously, avoid the IP conflict by setting the
# ALTERNATE_IP environment variable:
#
#     ALTERNATE_IP=192.168.56.9 vagrant up sensu-server-enterprise
#
# NOTE: The client VM instances assume the server VM is accessible on the
# default IP address, therefore using an ALTERNATE_IP is not expected to behave
# well with client instances.
#
# When bringing up sensu-server-enterprise, the FACTER_SE_USER and
# FACTER_SE_PASS environment variables are required.  See the README for more
# information on how to configure sensu enterprise credentials.
if not Vagrant.has_plugin?('vagrant-vbguest')
  abort <<-EOM

vagrant plugin vagrant-vbguest is required.
https://github.com/dotless-de/vagrant-vbguest
To install the plugin, please run, 'vagrant plugin install vagrant-vbguest'.

  EOM
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1536"]
  end

  config.vm.define "rabbitmq-server", primary: true, autostart: true do |server|
    server.vm.box = "ubuntu/xenial64"
    config.vm.box_version = "20180316.0.0"
    server.vm.hostname = 'rabbitmq-server.lotus'
    server.vm.network "public_network"
    # server.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.56.20'
    # server.vm.network :forwarded_port, guest: 15672, host: 15672, auto_correct: true
    server.vm.provision :shell, :path => "prov/provision_server_u1604.sh"
    server.vm.provision :shell, :path => "prov/rabbitmq.sh"
    server.vm.provision :shell, :inline => "puppet apply /vagrant/prov/rabbitmq.pp"
  end
  
  # config.vm.define "centos7_server", primary: true, autostart: true do |server|
  #   server.vm.box = "centos/7"
  #   server.vm.hostname = 'centos7.server'
  #   # config.vm.box_version = "1802.01"
  #   server.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.56.21'
  #   server.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  #   server.vm.provision :shell, :path => "prov/provision_basic_el.sh"
  #   server.vm.provision :shell, :path => "prov/provision_server.sh"
  # end

  # config.vm.define "centos7_test", primary: true, autostart: true do |server|
  #   config.vm.box = "centos/7"
  # end

end
