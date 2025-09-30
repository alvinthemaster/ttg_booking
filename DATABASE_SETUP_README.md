# TTG Resort Booking - Database Setup Guide

## Overview
This guide will help you set up the MySQL database for the TTG Resort Booking application.

## Prerequisites
- XAMPP installed and running
- MySQL service started in XAMPP
- Flutter app dependencies installed (`flutter pub get`)

## Database Setup Steps

### 1. Start XAMPP Services
1. Open XAMPP Control Panel
2. Start **Apache** service
3. Start **MySQL** service

### 2. Create Database
1. Open your web browser
2. Go to `http://localhost/phpmyadmin`
3. Click on **SQL** tab
4. Copy and paste the contents of `database_setup_complete.sql`
5. Click **Go** to execute the script

### 3. Verify Database Setup
The script will create:
- Database: `ttg_booking`
- Tables: `users`, `resorts`, `bookings`
- Sample data for testing

### 4. Test Database Connection
1. Run the Flutter app: `flutter run`
2. On the Welcome screen, tap the settings icon (⚙️) in the top-right corner
3. Tap "Test Database Connection" to verify the connection
4. Tap "Test User Registration" to test user creation

## Database Configuration

The app is configured to connect to MySQL with these default settings:

- **Host**: localhost
- **Port**: 3306
- **Username**: root
- **Password**: (empty)
- **Database**: ttg_booking

To change these settings, edit the `DatabaseService` class in `lib/services/database_service.dart`.

## Default Test Users

The database setup includes these test users:

| Email | Password | Name |
|-------|----------|------|
| admin@ttg.com | admin123 | Admin User |
| john.doe@example.com | password123 | John Doe |
| jane.smith@example.com | password123 | Jane Smith |

## Features

### Authentication
- User registration with email validation
- User login with session management
- Password security (Note: In production, implement proper password hashing)
- Remember me functionality
- User profile management

### Database Schema

#### Users Table
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Resorts Table
```sql
CREATE TABLE resorts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    sand_type ENUM('white', 'black') NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    total_rooms INT DEFAULT 0,
    available_rooms INT DEFAULT 0,
    amenities JSON,
    images JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Bookings Table
```sql
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    resort_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_rooms INT NOT NULL DEFAULT 1,
    room_type VARCHAR(100),
    total_price DECIMAL(10, 2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (resort_id) REFERENCES resorts(id) ON DELETE CASCADE
);
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Ensure XAMPP MySQL service is running
   - Check if port 3306 is not blocked
   - Verify database credentials in `database_service.dart`

2. **Table Already Exists Error**
   - This is normal if running the setup script multiple times
   - The script uses `CREATE TABLE IF NOT EXISTS`

3. **Permission Denied**
   - Make sure MySQL user has proper permissions
   - Default XAMPP root user should work without issues

### Security Notes

⚠️ **Important for Production:**

1. **Password Hashing**: Currently passwords are stored in plain text. Implement proper password hashing (bcrypt, etc.) before production.

2. **SQL Injection**: The current implementation uses parameterized queries which help prevent SQL injection.

3. **Database Security**: Change default MySQL credentials in production.

4. **Connection Security**: Use SSL/TLS for database connections in production.

## Next Steps

1. Test the authentication flow
2. Implement password hashing for security
3. Add password reset functionality
4. Integrate resort booking with user accounts
5. Add user profile management features

## Support

If you encounter any issues during setup, please check:
1. XAMPP is properly installed and services are running
2. Database setup script ran successfully
3. Flutter dependencies are installed
4. No firewall blocking database connections