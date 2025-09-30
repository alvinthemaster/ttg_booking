# TTG Booking Database Setup Script
# This script will set up the MySQL database for the TTG Booking app

Write-Host "TTG Resort Booking - Database Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is running
$mysqlProcess = Get-Process mysql -ErrorAction SilentlyContinue
if ($mysqlProcess) {
    Write-Host "✅ MySQL service is running" -ForegroundColor Green
} else {
    Write-Host "❌ MySQL service is not running" -ForegroundColor Red
    Write-Host "Please start XAMPP and ensure MySQL service is running" -ForegroundColor Yellow
    Write-Host "Then run this script again" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if mysql command line is available
try {
    $mysqlVersion = & mysql --version 2>$null
    if ($mysqlVersion) {
        Write-Host "✅ MySQL command line is available" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ MySQL command line not found in PATH" -ForegroundColor Red
    Write-Host "You can still set up the database manually using phpMyAdmin" -ForegroundColor Yellow
    Write-Host "Go to http://localhost/phpmyadmin and run the SQL script" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setting up database..." -ForegroundColor Yellow

# Path to the SQL script
$sqlScript = "database_setup_complete.sql"

if (Test-Path $sqlScript) {
    Write-Host "✅ Found SQL script: $sqlScript" -ForegroundColor Green
    
    # Try to run the SQL script
    try {
        Write-Host "Executing SQL script..." -ForegroundColor Yellow
        & mysql -u root -p < $sqlScript
        Write-Host "✅ Database setup completed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to execute SQL script using command line" -ForegroundColor Red
        Write-Host "Please set up the database manually using phpMyAdmin:" -ForegroundColor Yellow
        Write-Host "1. Go to http://localhost/phpmyadmin" -ForegroundColor Cyan
        Write-Host "2. Click on 'SQL' tab" -ForegroundColor Cyan
        Write-Host "3. Copy and paste the contents of $sqlScript" -ForegroundColor Cyan
        Write-Host "4. Click 'Go' to execute" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ SQL script not found: $sqlScript" -ForegroundColor Red
    Write-Host "Please ensure the file exists in the current directory" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run the Flutter app: flutter run -d web-server --web-port 8080" -ForegroundColor White
Write-Host "2. Open browser at: http://localhost:8080" -ForegroundColor White
Write-Host "3. Click the settings icon on welcome screen to test database" -ForegroundColor White
Write-Host "4. Try registering a new user or logging in" -ForegroundColor White

Write-Host ""
Write-Host "Default test accounts:" -ForegroundColor Cyan
Write-Host "Email: admin@ttg.com | Password: admin123" -ForegroundColor White
Write-Host "Email: john.doe@example.com | Password: password123" -ForegroundColor White

Write-Host ""
Read-Host "Press Enter to continue"