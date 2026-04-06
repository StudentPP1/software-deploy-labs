# Simple inventory service
Project to understand how to deploy without docker

# Variables
+ Variant: 14 (V2 = 1, V3 = 3, V5 = 5)
+ Web-app: Simple Inventory
+ Config: command line arguments
+ App port: 5000
+ Database: MariaDB

# Run app via docker-compose
```bash
docker-compose up -d
```

# Local run 
```bash
./gradlew bootRun --args="--server.port=5000 --spring.datasource.url=jdbc:mariadb://localhost:3306/simple_inventory --spring.datasource.username=root --spring.datasource.password=root --spring.datasource.driver-class-name=org.mariadb.jdbc.Driver"
```

# Linux run app
+ Use ubuntu [image](https://ubuntu.com/download/server)

+ Clone repo
```bash
git clone https://github.com/StudentPP1/software-deploy-labs.git
```

+ Go to project folder
```bash
cd software-deploy-labs
cd mywebapp
```

+ Run script
```bash
sudo bash setup.sh
```

# API 
````http request
# list of items (id, name)
GET /items
###

# create a new item
POST /items 
###

# item details by id
GET /items/<id> 
###

# Return OK if app run
GET /health/alive
###

# Return OK if db connected
GET /health/ready
````

# Testing
Run these commands from the virtual machine terminal to verify the deployment, network restrictions, and user permissions.

### 1. Nginx & API Endpoints 

+ Test root endpoint 
```bash
curl -i -H "Accept: text/html" http://localhost/
```

+ Test Nginx security: internal health checks must be blocked (should return 403 Forbidden)
```bash
curl -i http://localhost/health/alive
```

+ Test business logic GET with JSON accept header (should return JSON array)
```bash
curl -i -H "Accept: application/json" http://localhost/items
```

+ Test business logic GET with HTML accept header (should return plain HTML table)
```bash
curl -i -H "Accept: text/html" http://localhost/items
```

+ Test business logic POST (should return 201 Created or 200 OK)
```bash
curl -i -X POST -H "Content-Type: application/json" -d '{"name":"Test Item", "quantity":5}' http://localhost/items
```

### 2. Users and Permissions
+ Test 'teacher' user (Default password: '12345678')
```bash
su - teacher
sudo ls /root # Expectation: Success (has admin rights)
exit
```

+ Test 'operator' user (Default password: '12345678')
```bash
su - operator
sudo systemctl restart mywebapp.service # Expectation: Success (allowed command)
sudo ls /root # Expectation: Permission denied (restricted sudo access)
exit
```

+ Verify default cloud user is locked for security
```bash
sudo passwd -S ubuntu
```

# 3. Systemd Service & Automation Artifacts
+ Verify the Java app is running 
```bash
ps -o user,pid,cmd -C java
```

+ Verify the automation script created the grade book 
```bash
sudo cat /home/student/gradebook
```
