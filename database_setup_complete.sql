-- TTG Booking Database Setup
-- Run this script in your MySQL database to set up the required tables

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS ttg_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE ttg_booking;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_name (first_name, last_name)
);

-- Create resorts table (for future use)
CREATE TABLE IF NOT EXISTS resorts (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sand_type (sand_type),
    INDEX idx_price (price_per_night),
    INDEX idx_rating (rating)
);

-- Create bookings table (for future use)
CREATE TABLE IF NOT EXISTS bookings (
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
    FOREIGN KEY (resort_id) REFERENCES resorts(id) ON DELETE CASCADE,
    INDEX idx_user_booking (user_id),
    INDEX idx_resort_booking (resort_id),
    INDEX idx_booking_dates (check_in_date, check_out_date),
    INDEX idx_booking_status (booking_status)
);

-- Insert sample data for testing
INSERT IGNORE INTO users (email, password, first_name, last_name, phone) VALUES
('admin@ttg.com', 'admin123', 'Admin', 'User', '+1234567890'),
('john.doe@example.com', 'password123', 'John', 'Doe', '+1987654321'),
('jane.smith@example.com', 'password123', 'Jane', 'Smith', '+1122334455');

-- Insert sample resorts
INSERT IGNORE INTO resorts (name, description, location, sand_type, price_per_night, rating, total_rooms, available_rooms, amenities, images) VALUES
('Paradise White Beach Resort', 'Luxurious beachfront resort with pristine white sand beaches', 'Boracay, Philippines', 'white', 250.00, 4.8, 100, 85, '["WiFi", "Pool", "Spa", "Restaurant", "Bar"]', '["beach1.jpg", "room1.jpg", "pool1.jpg"]'),
('Black Sand Retreat', 'Unique volcanic black sand beach experience', 'Santorini, Greece', 'black', 350.00, 4.9, 50, 40, '["WiFi", "Pool", "Spa", "Restaurant", "Gym"]', '["beach2.jpg", "room2.jpg", "spa1.jpg"]'),
('Crystal Shore Resort', 'Family-friendly white sand beach resort', 'Maldives', 'white', 400.00, 4.7, 80, 65, '["WiFi", "Pool", "Kids Club", "Restaurant", "Water Sports"]', '["beach3.jpg", "room3.jpg", "pool2.jpg"]'),
('Volcanic Beach Hotel', 'Stunning black sand beaches with modern amenities', 'Iceland', 'black', 200.00, 4.6, 60, 50, '["WiFi", "Spa", "Restaurant", "Hot Springs"]', '["beach4.jpg", "room4.jpg", "spa2.jpg"]'),
('White Pearl Resort', 'Exclusive white sand beach with premium service', 'Bahamas', 'white', 500.00, 4.9, 40, 35, '["WiFi", "Pool", "Private Beach", "Butler Service", "Fine Dining"]', '["beach5.jpg", "room5.jpg", "dining1.jpg"]');

COMMIT;

-- Show success message
SELECT 'TTG Booking database setup completed successfully!' AS status;