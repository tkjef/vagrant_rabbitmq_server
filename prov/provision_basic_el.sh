#!/bin/bash

# using this instead of "rpm -Uvh" to resolve dependencies
function rpm_install() {
    package=$(echo $1 | awk -F "/" '{print $NF}')
    wget --quiet $1
    yum install -y ./$package
    rm -f $package
}

release=$(awk -F \: '{print $5}' /etc/system-release-cpe)

rpm --import http://download-ib01.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${release}
rpm --import http://vault.centos.org/RPM-GPG-KEY-CentOS-${release}

yum install -y wget

# install EPEL repos for required dependencies
rpm_install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${release}.noarch.rpm
