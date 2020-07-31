#!/bin/bash

### Ensure apt is up-to-date
sudo apt-get update

### Install MySQL and create application user with password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${root_password}'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${root_password}'
sudo apt-get -y install mysql-server

mysql -u root '-p${root_password}' -e "CREATE USER '${db_username}'@'%' IDENTIFIED BY '${db_password}'"
mysql -u root '-p${root_password}' -e "GRANT ALL PRIVILEGES ON *.* TO '${db_username}'@'%' WITH GRANT OPTION"

sudo sed -i 's/.*bind-address.*/bind-address=0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

### Install Supervisor
sudo apt-get -y install supervisor

### Account to own applications
useradd -m -d /home/appuser appuser

### Create directory where apps will run from
mkdir /opt/apps
chown -R appuser:appuser /opt/apps

### Install Virtual Environment for Python
sudo apt-get -y install python3-venv

### Install Java Runtime 11
sudo apt-get -y install openjdk-11-jre-headless

### Install certbot
sudo apt-get -y install software-properties-common certbot python3-certbot-nginx

### Install and configura nginx, needs to be the last step
sudo apt-get -y install nginx

sudo chmod 777 /opt
