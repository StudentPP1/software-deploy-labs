#!/bin/bash
set -e

echo "1. Install packages"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-25-jdk mariadb-server nginx sudo

echo "2. Create users"
# -m: create user folder
# -s /bin/bash: set default shell for user
# -G sudo: set sudo group for user
# `!` = not, id = check is user exist, &>/dev/null = ignore stdout
if ! id "student" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo student
fi
# chpasswd -> set password to user
#  student:studentpass = login:password
echo "student:studentpass" | chpasswd

if ! id "teacher" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo teacher
fi
echo "teacher:12345678" | chpasswd
# set policy for password to 0, we need to create new password
chage -d 0 teacher

if ! id "operator" &>/dev/null; then
    # check if group called operator exist
    if getent group operator &>/dev/null; then
        useradd -m -s /bin/bash -g operator operator
    else
        useradd -m -s /bin/bash operator
    fi
fi
echo "operator:12345678" | chpasswd
chage -d 0 operator

# Create system user if not exists
if ! id "app" &>/dev/null; then
    # -r: create system user (only for services)
    # -s /usr/sbin/nologin: disable forward login
    useradd -r -s /usr/sbin/nologin app
fi

echo "3. Config rights for operator"
# write to sudo config for operators rules
# use for operator
# ALL=(ALL): for all hosts
# NOPASSWD: we don't need enter password for sudo
# write command that can be used from operator: start/stop/restart service, check status & reload nginx
cat <<EOF > /etc/sudoers.d/operator-rules
operator ALL=(ALL) NOPASSWD: /bin/systemctl start mywebapp.service, /bin/systemctl stop mywebapp.service, /bin/systemctl restart mywebapp.service, /bin/systemctl status mywebapp.service, /bin/systemctl reload nginx
EOF
# 0440: only for read for user operator & group operator, others no right for file
chmod 0440 /etc/sudoers.d/operator-rules