#!/bin/bash
set -e

echo "1. Install packages"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-25-jdk mariadb-server nginx sudo

echo "2. Create users"
# Create student if not exists
if ! id "student" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo student
fi
echo "student:studentpass" | chpasswd

# Create teacher if not exists
if ! id "teacher" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo teacher
fi
echo "teacher:12345678" | chpasswd
chage -d 0 teacher

# Create operator if not exists
if ! id "operator" &>/dev/null; then
    if getent group operator &>/dev/null; then
        useradd -m -s /bin/bash -g operator operator
    else
        useradd -m -s /bin/bash operator
    fi
fi
echo "operator:12345678" | chpasswd
chage -d 0 operator

# Create system user if not exists
if ! id "mywebapp" &>/dev/null; then
    useradd -r -s /usr/sbin/nologin mywebapp
fi

echo "3. Config rights for operator"
cat <<EOF > /etc/sudoers.d/operator-rules
operator ALL=(ALL) NOPASSWD: /bin/systemctl start mywebapp.service, /bin/systemctl stop mywebapp.service, /bin/systemctl restart mywebapp.service, /bin/systemctl status mywebapp.service, /bin/systemctl reload nginx
EOF
chmod 0440 /etc/sudoers.d/operator-rules