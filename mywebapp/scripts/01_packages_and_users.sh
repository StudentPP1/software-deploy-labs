#!/bin/bash
set -e

echo "1. Install packages"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-25-jdk mariadb-server nginx sudo

echo "2. Create users"
# Student user (admin)
useradd -m -s /bin/bash -G sudo student || true
echo "student:studentpass" | chpasswd

# Teacher user (admin, forced password change on first login)
useradd -m -s /bin/bash -G sudo teacher || true
echo "teacher:12345678" | chpasswd
chage -d 0 teacher

# Operator user (limited access)
useradd -m -s /bin/bash operator || true
echo "operator:12345678" | chpasswd
chage -d 0 operator

# System user for running the application (no login allowed)
useradd -r -s /usr/sbin/nologin mywebapp || true

echo "3. Config rights for operator"
cat <<EOF > /etc/sudoers.d/operator-rules
operator ALL=(ALL) NOPASSWD: /bin/systemctl start mywebapp.service, /bin/systemctl stop mywebapp.service, /bin/systemctl restart mywebapp.service, /bin/systemctl status mywebapp.service, /bin/systemctl reload nginx
EOF
chmod 0440 /etc/sudoers.d/operator-rules