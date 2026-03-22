#!/bin/bash

set -e # Stop if we have any errors

# Effective user id: від імені адміністратора
# if EUID != 0 => then
if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo (sudo ./setup.sh)"
  exit 1
fi

echo "Start deploying"

# Add execute permission for all users & group to all scripts
chmod +x scripts/*.sh

# Run scripts sequentially
./scripts/01_packages_and_users.sh
./scripts/02_database.sh
./scripts/03_build_and_systemd.sh
./scripts/04_nginx_and_finalize.sh

echo "Success"