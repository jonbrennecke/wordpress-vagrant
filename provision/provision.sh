#!/bin/bash

#
# Provision the vagrant box with Wordpress, MariaDb and Nginx
# 
# @author Jon Brennecke
# @package wordpress-vagrant 
# @version 1.0
# @link http://github.com/jonbrennecke/wordpress-vagrant
# 

# See commands as they are run
set -x

# Setup
mkdir -p /vagrant/www

# @todo determine if user 'vagrant' exists, if not run adduser vagrant

# Install aptitude repositories and update
sudo apt-get -y update
sudo apt-get -y install software-properties-common python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository -y 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu trusty main'
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git mariadb-server php5 php5-mysql php5-fpm nginx
sudo apt-get -f install

# Get the wordpress tarball and unpack it
wget http://wordpress.org/latest.tar.gz -P /vagrant/www
tar xzvf /vagrant/www/latest.tar.gz

# Symlink our nginx conf file to /etc/nginx/, but save the old one in case we need it later
if [ -f /etc/nginx/nginx.conf ]; then
	sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
fi; 
sudo ln -s $(pwd)/../nginx.conf /etc/nginx/nginx.conf

# Create directory structure for nginx
mkdir -p /usr/share/nginx/logs
mkdir -p /usr/share/nginx/tmp


# Reload nginx now that we've updated the conf file
sudo service nginx reload
sudo service php5-fpm reload

# mysql -u root -p < 'create database wordpress;'

# return shell to defaults
set +x

