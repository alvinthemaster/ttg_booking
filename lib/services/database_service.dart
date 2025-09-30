import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  
  DatabaseService._();
  
  MySqlConnection? _connection;
  
  // Database connection settings
  static const String _host = 'localhost';
  static const int _port = 3306;
  static const String _user = 'root';
  static const String _password = '';
  static const String _database = 'oneglan';
  
  // Connect to MySQL database
  Future<MySqlConnection?> _getConnection() async {
    try {
      _connection ??= await MySqlConnection.connect(ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
        timeout: const Duration(seconds: 10),
      ));
      
      return _connection;
    } catch (e) {
      print('Database connection error: $e');
      print('Make sure XAMPP MySQL is running and database "$_database" exists');
      return null;
    }
  }
  
  // Initialize database tables
  Future<bool> initializeDatabase() async {
    try {
      final connection = await _getConnection();
      if (connection == null) return false;
      
      // Create users table if it doesn't exist
      await connection.query('''
        CREATE TABLE IF NOT EXISTS app_users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          email VARCHAR(255) UNIQUE NOT NULL,
          password VARCHAR(255) NOT NULL,
          first_name VARCHAR(100) NOT NULL,
          last_name VARCHAR(100) NOT NULL,
          phone VARCHAR(20),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
      ''');
      
      return true;
    } catch (e) {
      print('Database initialization error: $e');
      return false;
    }
  }
  
  // Register new user
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final connection = await _getConnection();
      if (connection == null) {
        return {'success': false, 'message': 'Database connection failed'};
      }
      
      // Check if user already exists in app_users table
      var existingUser = await connection.query(
        'SELECT id FROM app_users WHERE email = ?',
        [email],
      );
      
      if (existingUser.isNotEmpty) {
        return {'success': false, 'message': 'Email already registered'};
      }
      
      // Insert new user into app_users table
      var result = await connection.query(
        'INSERT INTO app_users (email, password, first_name, last_name, phone) VALUES (?, ?, ?, ?, ?)',
        [email, password, firstName, lastName, phone],
      );
      
      if (result.affectedRows! > 0) {
        return {
          'success': true,
          'message': 'User registered successfully',
          'user_id': result.insertId,
        };
      } else {
        return {'success': false, 'message': 'Registration failed'};
      }
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'message': 'Registration failed: ${e.toString()}'};
    }
  }
  
  // Login user
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final connection = await _getConnection();
      if (connection == null) {
        return {'success': false, 'message': 'Database connection failed'};
      }
      
      // Find user by email and password in app_users table
      var result = await connection.query(
        'SELECT * FROM app_users WHERE email = ? AND password = ?',
        [email, password],
      );
      
      if (result.isNotEmpty) {
        var row = result.first;
        User user = User(
          id: row['id'],
          email: row['email'],
          firstName: row['first_name'],
          lastName: row['last_name'],
          phone: row['phone'],
        );
        
        // Save user session
        await _saveUserSession(user);
        
        return {
          'success': true,
          'message': 'Login successful',
          'user': user,
        };
      } else {
        return {'success': false, 'message': 'Invalid email or password'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Login failed: ${e.toString()}'};
    }
  }
  
  // Save user session
  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_first_name', user.firstName);
    await prefs.setString('user_last_name', user.lastName);
    if (user.phone != null) {
      await prefs.setString('user_phone', user.phone!);
    }
    await prefs.setBool('is_logged_in', true);
  }
  
  // Get current user session
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (!isLoggedIn) return null;
      
      final userId = prefs.getInt('user_id');
      final email = prefs.getString('user_email');
      final firstName = prefs.getString('user_first_name');
      final lastName = prefs.getString('user_last_name');
      
      // Return user from SharedPreferences even if database is not available
      if (userId != null && email != null && firstName != null && lastName != null) {
        return User(
          id: userId,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: prefs.getString('user_phone'),
        );
      }
      
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
  
  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // Close database connection
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
  
  // Static methods for testing and additional functionality
  static Future<bool> testConnection() async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
        timeout: const Duration(seconds: 10),
      ));
      
      await conn.close();
      return true;
    } catch (e) {
      print('Database connection test failed: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
        timeout: const Duration(seconds: 10),
      ));

      final results = await conn.query(
        'SELECT id, email, first_name, last_name, phone, created_at FROM app_users ORDER BY created_at DESC'
      );
      
      List<Map<String, dynamic>> users = [];
      for (var row in results) {
        users.add({
          'id': row[0],
          'email': row[1],
          'first_name': row[2],
          'last_name': row[3],
          'phone': row[4],
          'created_at': row[5],
        });
      }

      await conn.close();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }

  static Future<Map<String, dynamic>?> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      print('Creating user in app_users table: $email');
      
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
        timeout: const Duration(seconds: 10),
      ));

      // Check if user already exists in app_users table
      final existingUser = await conn.query(
        'SELECT id FROM app_users WHERE email = ?',
        [email],
      );

      if (existingUser.isNotEmpty) {
        await conn.close();
        throw Exception('User with this email already exists');
      }

      // Insert new user into app_users table
      final result = await conn.query(
        'INSERT INTO app_users (email, password, first_name, last_name, phone) VALUES (?, ?, ?, ?, ?)',
        [email, password, firstName, lastName, phone],
      );

      final userId = result.insertId;
      print('User created with ID: $userId');

      // Fetch the created user
      final userResult = await conn.query(
        'SELECT id, email, first_name, last_name, phone, created_at FROM app_users WHERE id = ?',
        [userId],
      );

      await conn.close();

      if (userResult.isNotEmpty) {
        final row = userResult.first;
        return {
          'id': row[0],
          'email': row[1],
          'first_name': row[2],
          'last_name': row[3],
          'phone': row[4],
          'created_at': row[5],
        };
      }

      return null;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  static Future<void> createResortTables() async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
        timeout: const Duration(seconds: 10),
      ));

      // Create resorts table for TTG app
      await conn.query('''
        CREATE TABLE IF NOT EXISTS ttg_resorts (
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
        )
      ''');

      // Create bookings table for TTG app
      await conn.query('''
        CREATE TABLE IF NOT EXISTS ttg_bookings (
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
          FOREIGN KEY (user_id) REFERENCES app_users(id) ON DELETE CASCADE,
          FOREIGN KEY (resort_id) REFERENCES ttg_resorts(id) ON DELETE CASCADE,
          INDEX idx_user_booking (user_id),
          INDEX idx_resort_booking (resort_id),
          INDEX idx_booking_dates (check_in_date, check_out_date),
          INDEX idx_booking_status (booking_status)
        )
      ''');

      // Insert sample resorts if table is empty
      final resortCount = await conn.query('SELECT COUNT(*) as count FROM ttg_resorts');
      if (resortCount.first[0] == 0) {
        await conn.query('''
          INSERT INTO ttg_resorts (name, description, location, sand_type, price_per_night, rating, total_rooms, available_rooms, amenities, images) VALUES
          ('Paradise White Beach Resort', 'Luxurious beachfront resort with pristine white sand beaches', 'Boracay, Philippines', 'white', 250.00, 4.8, 100, 85, '["WiFi", "Pool", "Spa", "Restaurant", "Bar"]', '["beach1.jpg", "room1.jpg", "pool1.jpg"]'),
          ('Black Sand Retreat', 'Unique volcanic black sand beach experience', 'Santorini, Greece', 'black', 350.00, 4.9, 50, 40, '["WiFi", "Pool", "Spa", "Restaurant", "Gym"]', '["beach2.jpg", "room2.jpg", "spa1.jpg"]'),
          ('Crystal Shore Resort', 'Family-friendly white sand beach resort', 'Maldives', 'white', 400.00, 4.7, 80, 65, '["WiFi", "Pool", "Kids Club", "Restaurant", "Water Sports"]', '["beach3.jpg", "room3.jpg", "pool2.jpg"]'),
          ('Volcanic Beach Hotel', 'Stunning black sand beaches with modern amenities', 'Iceland', 'black', 200.00, 4.6, 60, 50, '["WiFi", "Spa", "Restaurant", "Hot Springs"]', '["beach4.jpg", "room4.jpg", "spa2.jpg"]'),
          ('White Pearl Resort', 'Exclusive white sand beach with premium service', 'Bahamas', 'white', 500.00, 4.9, 40, 35, '["WiFi", "Pool", "Private Beach", "Butler Service", "Fine Dining"]', '["beach5.jpg", "room5.jpg", "dining1.jpg"]')
        ''');
      }

      await conn.close();
      print('TTG Resort tables created/verified successfully');
    } catch (e) {
      print('Error creating resort tables: $e');
      rethrow;
    }
  }
}
