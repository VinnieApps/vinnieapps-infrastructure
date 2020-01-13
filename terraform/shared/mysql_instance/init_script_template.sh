#!/bin/bash
sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${db_password}'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${db_password}'
sudo apt-get -y install mysql-server

mysql -u root '-p${db_password}' -e "CREATE USER 'appuser'@'%' IDENTIFIED BY '${db_password}'"
mysql -u root '-p${db_password}' -e "GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%' IDENTIFIED BY '${db_password}' WITH GRANT OPTION"

mysql -u root '-p${db_password}' -e "CREATE DATABASE ${db_name} CHARACTER SET utf8"

sudo sed -i 's/.*bind-address.*/bind-address=0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
