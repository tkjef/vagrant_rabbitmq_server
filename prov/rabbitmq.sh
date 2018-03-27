#!/bin/bash

# Rabbitmq needs to have a user that sensu can connect to.
# The default user of 'guest' can only connect over localhost http://bit.ly/1thfSKL

/usr/sbin/rabbitmqctl add_vhost /matchmaker
/usr/sbin/rabbitmqctl add_user matchmaker correct-horse-battery-staple
/usr/sbin/rabbitmqctl set_user_tags matchmaker administrator management monitoring
/usr/sbin/rabbitmqctl set_permissions -p /matchmaker matchmaker ".*" ".*" ".*"
/usr/sbin/rabbitmqctl set_permissions -p / matchmaker ".*" ".*" ".*"

# Updating ip on test script
cd /home/vagrant/rabbitmq/test/
./update_host

# If you can't log into the web portal, you may need to reset the password
# /usr/sbin/rabbitmqctl change_password matchmaker correct-horse-battery-staple
