#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print header
echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}     My Personal lil App - Docker Setup      ${NC}"
echo -e "${GREEN}==============================================${NC}"

# Set root password (optional)
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo -e "${YELLOW}No MySQL root password set. Using default: 'Nora123'${NC}"
  export MYSQL_ROOT_PASSWORD=Nora123
fi

# Build and start containers
echo -e "\n${GREEN}Building and starting Docker containers...${NC}"
docker-compose up -d --build

echo -e "\n${GREEN}Containers are starting...${NC}"
echo -e "Please wait a few moments for everything to initialize."

echo -e "\n${YELLOW}You can access the application at:${NC}"
echo -e "${GREEN}Frontend:${NC} http://localhost:8080"
echo -e "${GREEN}Backend API:${NC} http://localhost:3000"

echo -e "\n${YELLOW}To stop the containers, run:${NC}"
echo -e "docker-compose down"

echo -e "\n${GREEN}==============================================${NC}" 