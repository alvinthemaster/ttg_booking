import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  String _connectionStatus = 'Testing...';
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      setState(() {
        _isLoading = true;
        _connectionStatus = 'Testing connection to oneglan database...';
      });

      // Test basic connection
      final isConnected = await DatabaseService.testConnection();
      
      if (isConnected) {
        setState(() {
          _connectionStatus = '✅ Connected to oneglan database successfully!';
        });
        
        // Create TTG tables if needed
        try {
          await DatabaseService.createResortTables();
          setState(() {
            _connectionStatus += '\n✅ TTG Resort tables verified/created';
          });
        } catch (e) {
          setState(() {
            _connectionStatus += '\n⚠️ Error with resort tables: $e';
          });
        }
        
        // Try to fetch users from app_users table
        try {
          final users = await DatabaseService.getAllUsers();
          setState(() {
            _users = users;
            _connectionStatus += '\n✅ Found ${users.length} users in app_users table';
          });
        } catch (e) {
          setState(() {
            _connectionStatus += '\n❌ Error fetching app users: $e';
          });
        }
      } else {
        setState(() {
          _connectionStatus = '❌ Database Connection Failed!';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = '❌ Connection Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testRegistration() async {
    try {
      setState(() {
        _connectionStatus += '\n\nTesting registration...';
      });

      final testUser = await DatabaseService.createUser(
        email: 'test_${DateTime.now().millisecondsSinceEpoch}@ttg.com',
        password: 'test123',
        firstName: 'Test',
        lastName: 'User',
        phone: '+1234567890',
      );

      if (testUser != null) {
        setState(() {
          _connectionStatus += '\n✅ Test registration successful!';
        });
        _testConnection(); // Refresh user list
      } else {
        setState(() {
          _connectionStatus += '\n❌ Test registration failed!';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus += '\n❌ Registration error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Database Connection Test',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2E7D94),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Status',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _connectionStatus,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _testConnection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D94),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Connection'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _testRegistration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5F7A),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Registration'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Database Configuration:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Host: localhost'),
                    Text('Port: 3306'),
                    Text('Database: oneglan'),
                    Text('Username: root'),
                    Text('Password: (empty)'),
                    Text('Table: app_users'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TTG App Users (${_users.length})',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _users.isEmpty
                            ? const Center(child: Text('No TTG app users found'))
                            : ListView.builder(
                                itemCount: _users.length,
                                itemBuilder: (context, index) {
                                  final user = _users[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF2E7D94),
                                      child: Text(
                                        user['first_name'][0],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      '${user['first_name']} ${user['last_name']}',
                                    ),
                                    subtitle: Text(user['email']),
                                    trailing: Text('ID: ${user['id']}'),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}