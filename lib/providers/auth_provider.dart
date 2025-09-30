import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  final DatabaseService _databaseService = DatabaseService.instance;

  // Initialize auth provider
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Try to initialize database - don't fail if it doesn't work
      try {
        await _databaseService.initializeDatabase();
      } catch (e) {
        print('Database initialization warning: $e');
        // Continue without database for now
      }
      
      // Check if user is already logged in (from SharedPreferences only)
      try {
        _currentUser = await _databaseService.getCurrentUser();
      } catch (e) {
        print('Get current user warning: $e');
        // If database fails, just continue without user
        _currentUser = null;
      }
    } catch (e) {
      print('Auth initialization error: $e');
      _errorMessage = 'Initialization failed: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _databaseService.loginUser(
        email: email,
        password: password,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // If database is not available, check for demo/test login
      if (email == 'test@test.com' && password == 'test123') {
        _currentUser = User(
          id: 1,
          email: email,
          firstName: 'Test',
          lastName: 'User',
          phone: '+1234567890',
        );
        await _saveDemoUserSession(_currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _errorMessage = 'Login failed: Database not available. Try test@test.com / test123 for demo';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save demo user session (when database is not available)
  Future<void> _saveDemoUserSession(User user) async {
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

  // Register user
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Try database registration first
      final user = await DatabaseService.createUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (user != null) {
        // Create User object from the returned data
        _currentUser = User(
          id: user['id'],
          email: user['email'],
          firstName: user['first_name'],
          lastName: user['last_name'],
          phone: user['phone'],
        );
        
        // Save user session
        await _saveDemoUserSession(_currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to create user account';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // If database registration fails, show error but allow demo mode
      _errorMessage = 'Database registration failed: ${e.toString()}. Try demo login: test@test.com / test123';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.logout();
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
