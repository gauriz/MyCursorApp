# Print header
Write-Host "=============================================" -ForegroundColor Green
Write-Host "     My Personal lil App - Docker Setup      " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Set root password (optional)
if (-not $env:MYSQL_ROOT_PASSWORD) {
  Write-Host "No MySQL root password set. Using default: 'Nora123'" -ForegroundColor Yellow
  $env:MYSQL_ROOT_PASSWORD = "Nora123"
}

# Build and start containers
Write-Host "`nBuilding and starting Docker containers..." -ForegroundColor Green
docker-compose up -d --build

Write-Host "`nContainers are starting..." -ForegroundColor Green
Write-Host "Please wait a few moments for everything to initialize."

Write-Host "`nYou can access the application at:" -ForegroundColor Yellow
Write-Host "Frontend: http://localhost:8080" -ForegroundColor Green
Write-Host "Backend API: http://localhost:3000" -ForegroundColor Green

Write-Host "`nTo stop the containers, run:" -ForegroundColor Yellow
Write-Host "docker-compose down"

Write-Host "`n=============================================" -ForegroundColor Green 