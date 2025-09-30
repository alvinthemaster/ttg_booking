import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  String _testResult = 'Not tested yet';
  bool _isLoading = false;
  
  Future<void> _testDatabaseConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing database connection...';
    });

    try {
      final dbService = DatabaseService.instance;
      
      // Test database initialization
      bool initResult = await dbService.initializeDatabase();
      
      if (initResult) {
        setState(() {
          _testResult = 'Database connection successful!\nDatabase initialized properly.';
        });
      } else {
        setState(() {
          _testResult = 'Database connection failed!\nPlease check your MySQL configuration.';
        });
      }
    } catch (e) {
      setState(() {
        _testResult = 'Error: ${e.toString()}';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testUserRegistration() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing user registration...';
    });

    try {
      final dbService = DatabaseService.instance;
      
      // Test user registration
      final result = await dbService.registerUser(
        email: 'test${DateTime.now().millisecondsSinceEpoch}@test.com',
        password: 'test123',
        firstName: 'Test',
        lastName: 'User',
        phone: '+1234567890',
      );
      
      setState(() {
        _testResult = 'Registration test result:\n${result.toString()}';
      });
    } catch (e) {
      setState(() {
        _testResult = 'Registration test error: ${e.toString()}';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: const Color(0xFF2E7D94),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Database Connection Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testDatabaseConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D94),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Test Database Connection'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testUserRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A5F7A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Test User Registration'),
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Result:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _testResult,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Database Setup Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Make sure XAMPP MySQL is running\n'
                    '2. Open phpMyAdmin (http://localhost/phpmyadmin)\n'
                    '3. Run the SQL script: database_setup_complete.sql\n'
                    '4. Database will be created: ttg_booking\n'
                    '5. Tables will be created: users, resorts, bookings',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}