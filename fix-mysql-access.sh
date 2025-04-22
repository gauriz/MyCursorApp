#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}     MySQL Access Fix Script                 ${NC}"
echo -e "${GREEN}==============================================${NC}"

echo -e "${YELLOW}Stopping all containers...${NC}"
docker-compose down

echo -e "${YELLOW}Removing MySQL data volume to clear any corrupt data...${NC}"
docker volume rm $(docker volume ls -q | grep mysql_data) || true

echo -e "${YELLOW}Starting containers with fixed configuration...${NC}"
docker-compose up -d

echo -e "${GREEN}Waiting for MySQL to initialize (45 seconds)...${NC}"
sleep 45

echo -e "${YELLOW}Executing MySQL fix commands...${NC}"
docker exec -i myapp-mysql mysql -uroot -pNora123 <<EOF
DROP USER IF EXISTS 'root'@'localhost';
DROP USER IF EXISTS 'root'@'%';
DROP USER IF EXISTS 'root'@'127.0.0.1';
DROP USER IF EXISTS 'workbench'@'localhost';
DROP USER IF EXISTS 'workbench'@'%';
DROP USER IF EXISTS 'workbench'@'127.0.0.1';

CREATE USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'workbench'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'workbench'@'%' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'workbench'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'Nora123';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'127.0.0.1' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SELECT user, host FROM mysql.user;
EOF

echo -e "${GREEN}Fix completed!${NC}"
echo -e "Try connecting to MySQL again with the following details:"
echo -e "\n${YELLOW}OPTION 1 - Root User${NC}"
echo -e "${YELLOW}Host:${NC} 127.0.0.1"
echo -e "${YELLOW}Port:${NC} 3306"
echo -e "${YELLOW}Username:${NC} root"
echo -e "${YELLOW}Password:${NC} Nora123"

echo -e "\n${YELLOW}OPTION 2 - Workbench User${NC}"
echo -e "${YELLOW}Host:${NC} 127.0.0.1"
echo -e "${YELLOW}Port:${NC} 3306"
echo -e "${YELLOW}Username:${NC} workbench"
echo -e "${YELLOW}Password:${NC} Nora123"

echo -e "\n${GREEN}==============================================${NC}" 