#!/bin/bash
set -e

echo "5. Create jar"
chmod +x gradlew
./gradlew bootJar -x test

echo "6. Copy jar file"
mkdir -p /opt/mywebapp
cp build/libs/*-SNAPSHOT.jar /opt/mywebapp/mywebapp.jar
chown -R mywebapp:mywebapp /opt/mywebapp
chmod 500 /opt/mywebapp/mywebapp.jar

echo "7. Configuring Systemd and Socket Activation"
# Create the socket file
cat <<EOF > /etc/systemd/system/mywebapp.socket
[Unit]
Description=MyWebApp Socket

[Socket]
ListenStream=5000

[Install]
WantedBy=sockets.target
EOF

# Create the service file
cat <<EOF > /etc/systemd/system/mywebapp.service
[Unit]
Description=MyWebApp Service
Requires=mywebapp.socket
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

# Apply systemd changes and start the socket
systemctl daemon-reload
systemctl enable --now mywebapp.socket
systemctl restart mywebapp.service