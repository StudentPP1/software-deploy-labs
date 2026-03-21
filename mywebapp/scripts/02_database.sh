#!/bin/bash
set -e

echo "4. Config MariaDB"
systemctl start mariadb
systemctl enable mariadb

# Create database and grant privileges to the app user
mysql -u root -e "CREATE DATABASE IF NOT EXISTS simple_inventory;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'mywebapp'@'localhost' IDENTIFIED BY 'root';"
mysql -u root -e "GRANT ALL PRIVILEGES ON simple_inventory.* TO 'mywebapp'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"