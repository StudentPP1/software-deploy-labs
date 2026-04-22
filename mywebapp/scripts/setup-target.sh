#!/bin/bash
set -e

echo "[1/4] Updating system..."
apt-get update -qq
apt-get upgrade -y -qq

echo "[2/4] Installing Docker..."
apt-get install -y -qq ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -qq
apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "[3/4] Creating app user and directories..."
if ! id "app" &>/dev/null; then
  useradd -r -s /usr/sbin/nologin app
fi
usermod -aG docker app

mkdir -p /opt/mywebapp/nginx
chown -R app:app /opt/mywebapp

echo "[4/4] Installing systemd unit..."
cat <<'EOF' > /etc/systemd/system/mywebapp.service
[Unit]
Description=MyWebApp Docker Compose Service
After=docker.service network-online.target
Requires=docker.service
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
User=app
Group=app
WorkingDirectory=/opt/mywebapp

ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
ExecReload=/usr/bin/docker compose pull && /usr/bin/docker compose up -d

Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable mywebapp

echo "Setup complete! Target node is ready."