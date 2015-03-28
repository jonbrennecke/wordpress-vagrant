#!/bin/bash

#
# Provision the vagrant box with Wordpress, MariaDb and Nginx
# 
# @author Jon Brennecke
# @package wordpress-vagrant 
# @version 1.0
# @link http://github.com/jonbrennecke/wordpress-vagrant
# 

# Setup
su root
mkdir -p /vagrant/www
cd /vagrant/www

# Give the current user permissions to the /vagrant/www directory
chown -r $USER .

# Install aptitude repositories and update
sudo apt-get -y update
sudo apt-get -y install software-properties-common python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu trusty main'
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git mariadb-server php5 php5-mysql php5-fpm nginx
sudo apt-get -f install

# Get the wordpress tarball and unpack it
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

# Symlink our nginx conf file to /etc/nginx/, but save the old one in case we need it later
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
ln -s $(pwd)/nginx.conf /etc/nginx/nginx.conf

# Create directory structure for nginx
mkdir -p /usr/share/nginx/logs
mkdir -p /usr/share/nginx/tmp

# Reload nginx now that we've updated the conf file
service nginx reload
service php5-fpm reload

