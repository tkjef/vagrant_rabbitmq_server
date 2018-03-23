#!/bin/bash
DEBIAN_FRONTEND=noninteractive

sudo apt-get -qq update
sudo apt-get install -y apt-utils libterm-readline-perl-perl libgtk2-perl
sudo apt-get -qqy install dialog
sudo apt-get -qqy install git
# using this instead of "rpm -Uvh" to resolve dependencies
function deb_install() {
    package=$(echo $1 | awk -F "/" '{print $NF}')
    wget --quiet $1
    dpkg -i ./$package
    rm -f $package
}

export DEBIAN_FRONTEND=noninteractive

if [ -f /etc/lsb-release ]; then
  # ubuntu
  . /etc/lsb-release
  CODENAME=$DISTRIB_CODENAME
else
  # debian
  CODENAME=$(grep ^VERSION= /etc/os-release | awk -F \( '{print $2}' | awk -F \) '{print $1}')
  apt-get -y install apt-transport-https
  apt-get update
fi

# Debian 9 (stretch) complains about the dirmngr package missing.
if [ "${CODENAME}" == 'stretch' ]; then
  apt-get -y install dirmngr
fi

apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet

apt-get -y install wget

# install and configure puppet
deb_install https://apt.puppetlabs.com/puppet5-release-wheezy.deb
apt-get update
apt-get -y install puppet-agent
ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet

# suppress default warnings for deprecation
cat > /etc/puppetlabs/puppet/hiera.yaml <<EOF
---
version: 5
hierarchy:
  - name: Common
    path: common.yaml
defaults:
  data_hash: yaml_data
  datadir: hieradata
EOF

# use local rabbitmq module
puppet resource file /home/vagrant/rabbitmq ensure=link target=/vagrant

# setup module dependencies
puppet module install puppetlabs/stdlib
puppet module install puppetlabs/apt
puppet module install lwf-remote_file
puppet module install puppet/rabbitmq

# install dependencies
apt-get -y install ruby-json build-essential ntpdate

# install redis
apt-get -y install redis-server jq
systemctl start redis
systemctl enable redis

# run puppet
puppet apply /vagrant/prov/rabbitmq.pp
# puppet apply /vagrant/tests/sensu-server.pp
# puppet apply /vagrant/tests/uchiwa.pp
