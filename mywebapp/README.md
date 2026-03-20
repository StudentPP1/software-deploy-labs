# Variables
+ Variant: 14 (V2 = 1, V3 = 3, V5 = 5)
+ Web-app: Simple Inventory
+ Config: command line arguments
+ App port: 5000
+ Database: MariaDB

# Run app
```bash
./gradlew bootRun --args="--server.port=5000 --spring.datasource.url=jdbc:mariadb://localhost:3306/simple_inventory --spring.datasource.username=root --spring.datasource.password=root --spring.datasource.driver-class-name=org.mariadb.jdbc.Driver"
```
