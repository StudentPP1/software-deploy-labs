#!/bin/bash
set -e

echo "4. Config MariaDB"
systemctl start mariadb
systemctl enable mariadb

# Create database and grant privileges to the app user
mysql -u root -e "CREATE DATABASE IF NOT EXISTS simple_inventory;"
# login as mywebapp (system user) & available connection only through local machine & set for system user password root
mysql -u root -e "CREATE USER IF NOT EXISTS 'mywebapp'@'localhost' IDENTIFIED BY 'root';"
# all PRIVILEGES to system user for only simple_inventory db
mysql -u root -e "GRANT ALL PRIVILEGES ON simple_inventory.* TO 'mywebapp'@'localhost';"
# update PRIVILEGES in db (disable cache)
mysql -u root -e "FLUSH PRIVILEGES;"