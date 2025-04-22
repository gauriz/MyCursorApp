-- Drop user if exists and recreate to ensure clean slate
DROP USER IF EXISTS 'root'@'localhost';
DROP USER IF EXISTS 'root'@'%';
DROP USER IF EXISTS 'root'@'127.0.0.1';

-- Create users for all host variations
CREATE USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'Nora123';

-- Create a specific user for MySQL Workbench
CREATE USER 'workbench'@'%' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'workbench'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Nora123';
CREATE USER 'workbench'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'Nora123';

-- Grant privileges to all root variations
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;

-- Grant privileges to workbench user
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'workbench'@'127.0.0.1' WITH GRANT OPTION;

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS mydb;

-- Switch to mydb
USE mydb;

-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  firstName VARCHAR(255),
  lastName VARCHAR(255),
  dob DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Ensure database access
GRANT ALL PRIVILEGES ON mydb.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON mydb.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON mydb.* TO 'root'@'127.0.0.1';
GRANT ALL PRIVILEGES ON mydb.* TO 'workbench'@'%';
GRANT ALL PRIVILEGES ON mydb.* TO 'workbench'@'localhost';
GRANT ALL PRIVILEGES ON mydb.* TO 'workbench'@'127.0.0.1';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Show users to verify
SELECT user, host FROM mysql.user; 