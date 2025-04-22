# Docker Setup for My Personal lil App

This document provides instructions for running the application using Docker containers.

## Prerequisites

1. [Docker](https://docs.docker.com/get-docker/)
2. [Docker Compose](https://docs.docker.com/compose/install/)

## Container Structure

The application consists of three Docker containers:

1. **Frontend**: Vue.js application served by Nginx (exposed on port 8080)
2. **Backend**: Node.js/Express API server (exposed on port 3000)
3. **Database**: MySQL server (exposed on port 3306)

## Quick Start

### Using the Script (Recommended)

#### On Linux/Mac:

```bash
# Make the script executable
chmod +x run-docker.sh

# Run the script
./run-docker.sh
```

#### On Windows (PowerShell):

```powershell
# Run the script
.\run-docker.ps1
```

### Manual Setup

1. Set the MySQL root password (optional, default is Nora123):

```bash
# Linux/Mac
export MYSQL_ROOT_PASSWORD=your_password

# Windows PowerShell
$env:MYSQL_ROOT_PASSWORD = "your_password"
```

2. Build and start containers:

```bash
docker-compose up -d --build
```

## Accessing the Application

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:3000

## Connecting to the Database with MySQL Workbench

1. Install [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
2. Launch MySQL Workbench
3. Click on the "+" icon to add a new connection
4. Configure the connection:
   - Connection Name: My Personal lil App
   - Connection Method: Standard (TCP/IP)
   - Hostname: 127.0.0.1
   - Port: 3306
   - Username: root
   - Password: Click "Store in Vault" and enter "Nora123" (or your custom password if set)
5. Click "Test Connection" to verify
6. Click "OK" to save the connection
7. Double-click on the new connection to connect to the database

## Stopping the Application

```bash
docker-compose down
```

To remove the volumes (database data) as well:

```bash
docker-compose down -v
```

## Logs

To view logs of a specific container:

```bash
# Frontend logs
docker logs myapp-frontend

# Backend logs
docker logs myapp-backend

# Database logs
docker logs myapp-mysql
```

## Common Issues

### Database Connection Issues

#### "Access Denied" Error for MySQL

If you encounter an "Access denied for user 'root'" error when trying to connect with MySQL Workbench:

1. **Reset the MySQL container:**
   ```bash
   # Stop and remove existing containers
   docker-compose down
   
   # Remove the MySQL volume to clear any corrupt data
   docker volume rm $(docker volume ls -q | grep mysql_data)
   
   # Start everything again
   docker-compose up -d
   ```

2. **Connect using correct credentials:**
   - Host: 127.0.0.1 (use this instead of 'localhost')
   - Port: 3306
   - Username: root
   - Password: Nora123

3. **Verify connection parameters:**
   - Make sure you're using 127.0.0.1 instead of localhost
   - Double-check that the port 3306 is not blocked by a firewall
   - Ensure the password is exactly "Nora123" with correct capitalization

4. **Check MySQL container status:**
   ```bash
   docker ps | grep myapp-mysql
   ```

5. **View MySQL logs:**
   ```bash
   docker logs myapp-mysql
   ```

6. **Connect from within the container:**
   ```bash
   docker exec -it myapp-mysql mysql -u root -p
   ```
   When prompted, enter the password: Nora123

If the backend can't connect to the database:

1. Check if the MySQL container is running:
   ```bash
   docker ps | grep myapp-mysql
   ```

2. Check backend logs for connection errors:
   ```bash
   docker logs myapp-backend
   ```

### Frontend Can't Connect to Backend

If the frontend can't connect to the backend:

1. Ensure the backend container is running
2. Check nginx configuration inside the frontend container
3. Check network connectivity between containers 