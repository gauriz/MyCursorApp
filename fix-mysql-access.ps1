# PowerShell script to fix MySQL access issues

# Define color codes for PowerShell
$Green = [ConsoleColor]::Green
$Yellow = [ConsoleColor]::Yellow
$Red = [ConsoleColor]::Red

Write-Host "=============================================" -ForegroundColor $Green
Write-Host "     MySQL Access Fix Script (Enhanced)      " -ForegroundColor $Green
Write-Host "=============================================" -ForegroundColor $Green

Write-Host "Stopping all containers..." -ForegroundColor $Yellow
docker-compose down

Write-Host "Removing MySQL data volume to clear any corrupt data..." -ForegroundColor $Yellow
docker volume rm $(docker volume ls -q | Where-Object { $_ -match "mysql_data" }) -ErrorAction SilentlyContinue

# Copy the MySQL configuration file
Write-Host "Copying MySQL configuration file to Docker volume..." -ForegroundColor $Yellow
if (Test-Path "mysql-config.cnf") {
    if (!(Test-Path "./docker/mysql/config")) {
        New-Item -ItemType Directory -Path "./docker/mysql/config" -Force | Out-Null
    }
    Copy-Item -Path "mysql-config.cnf" -Destination "./docker/mysql/config/my.cnf" -Force
    Write-Host "MySQL configuration file copied successfully!" -ForegroundColor $Green
} else {
    Write-Host "Warning: MySQL configuration file not found!" -ForegroundColor $Red
}

Write-Host "Starting containers with fixed configuration..." -ForegroundColor $Yellow
docker-compose up -d

Write-Host "Waiting for MySQL to initialize (60 seconds)..." -ForegroundColor $Green
Start-Sleep -Seconds 60

Write-Host "Executing MySQL fix commands..." -ForegroundColor $Yellow

$sqlCommands = @"
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Nora123';

DROP USER IF EXISTS 'root'@'localhost';
DROP USER IF EXISTS 'root'@'127.0.0.1';
DROP USER IF EXISTS 'workbench'@'localhost';
DROP USER IF EXISTS 'workbench'@'%';
DROP USER IF EXISTS 'workbench'@'127.0.0.1';

CREATE USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Nora123';
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
"@

$result = $sqlCommands | docker exec -i myapp-mysql mysql -uroot -pNora123 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "First attempt to fix MySQL failed. Trying again with default password..." -ForegroundColor $Yellow
    $sqlCommands | docker exec -i myapp-mysql mysql -uroot 2>&1
}

Write-Host "Testing connection..." -ForegroundColor $Yellow
$testCmd = "SELECT 'Connection successful!' AS Status;"
$testResult = $testCmd | docker exec -i myapp-mysql mysql -uroot -pNora123 2>&1
if ($testResult -match "Connection successful") {
    Write-Host "Connection test successful!" -ForegroundColor $Green
} else {
    Write-Host "Connection test failed. Please check Docker logs for more details." -ForegroundColor $Red
    Write-Host "Run: docker logs myapp-mysql" -ForegroundColor $Yellow
}

Write-Host "Fix completed!" -ForegroundColor $Green
Write-Host "Try connecting to MySQL again with the following details:"

Write-Host "`nOPTION 1 - Root User" -ForegroundColor $Yellow
Write-Host "Host:" -ForegroundColor $Yellow -NoNewline
Write-Host " 127.0.0.1 (or localhost)"
Write-Host "Port:" -ForegroundColor $Yellow -NoNewline
Write-Host " 3306"
Write-Host "Username:" -ForegroundColor $Yellow -NoNewline
Write-Host " root"
Write-Host "Password:" -ForegroundColor $Yellow -NoNewline
Write-Host " Nora123"

Write-Host "`nOPTION 2 - Workbench User" -ForegroundColor $Yellow
Write-Host "Host:" -ForegroundColor $Yellow -NoNewline
Write-Host " 127.0.0.1 (or localhost)"
Write-Host "Port:" -ForegroundColor $Yellow -NoNewline
Write-Host " 3306"
Write-Host "Username:" -ForegroundColor $Yellow -NoNewline
Write-Host " workbench"
Write-Host "Password:" -ForegroundColor $Yellow -NoNewline
Write-Host " Nora123"

Write-Host "`n=============================================" -ForegroundColor $Green 