#!/bin/bash
set -e

echo "5. Create jar"
chmod +x gradlew
./gradlew bootJar -x test

echo "6. Copy jar file"
mkdir -p /opt/mywebapp
cp build/libs/*-SNAPSHOT.jar /opt/mywebapp/mywebapp.jar
# Owner of folder is system user: mywebapp
chown -R app:app /opt/mywebapp
# Only read & execute
chmod 500 /opt/mywebapp/mywebapp.jar

echo "7. Configuring Systemd"

# /etc/systemd/system/mywebapp.socket
cat <<EOF > /etc/systemd/system/mywebapp.socket
[Unit]
Description=MyWebApp Socket

[Socket]
ListenStream=5000
Accept=no

[Install]
WantedBy=sockets.target
EOF

# Create the service file (config to auto run)
# After=network.target mariadb.service: run after we have network & db
# WantedBy=multi-user.target: After server is available to work it's run mywebapp.service
# SuccessExitStatus=143: when java stop service to restart it will return 15, linux add 128 => 143 success stop
cat <<EOF > /etc/systemd/system/mywebapp.service
[Unit]
Description=MyWebApp Service
After=network.target mariadb.service
Wants=mywebapp.socket

[Service]
User=app
Group=app
WorkingDirectory=/opt/mywebapp
ExecStart=/usr/bin/java -jar /opt/mywebapp/mywebapp.jar --spring.datasource.url=jdbc:mariadb://localhost:3306/simple_inventory --spring.datasource.username=mywebapp --spring.datasource.password=root --server.port=5000
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload # reload daemon to clean start service
# systemctl enable --now mywebapp.socket -> prevent port conflict with spring app
systemctl enable --now mywebapp.service # run service
systemctl restart mywebapp.service # restart to pull new app config