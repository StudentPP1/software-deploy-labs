#!/bin/bash
set -e

echo "5. Create jar"
chmod +x gradlew
./gradlew bootJar -x test

echo "6. Copy jar file"
mkdir -p /opt/mywebapp
cp build/libs/*-SNAPSHOT.jar /opt/mywebapp/mywebapp.jar
# Owner of folder is system user: mywebapp
chown -R mywebapp:mywebapp /opt/mywebapp
# Only read & execute
chmod 500 /opt/mywebapp/mywebapp.jar

echo "7. Configuring Systemd"

# Create the service file (config to auto run)
# After=network.target mariadb.service: run after we have network & db
# WantedBy=multi-user.target: After server is available to work it's run mywebapp.service
cat <<EOF > /etc/systemd/system/mywebapp.service
[Unit]
Description=MyWebApp Service
After=network.target mariadb.service

[Service]
User=mywebapp
Group=mywebapp
WorkingDirectory=/opt/mywebapp
ExecStart=/usr/bin/java -jar /opt/mywebapp/mywebapp.jar --spring.datasource.url=jdbc:mariadb://localhost:3306/simple_inventory --spring.datasource.username=mywebapp --spring.datasource.password=root --server.port=5000
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# kill & delete old socket
systemctl stop mywebapp.socket 2>/dev/null || true
systemctl disable mywebapp.socket 2>/dev/null || true
rm -f /etc/systemd/system/mywebapp.socket

systemctl daemon-reload # reload daemon to clean start service
systemctl enable --now mywebapp.service # run service
systemctl restart mywebapp.service # restart to pull new app config