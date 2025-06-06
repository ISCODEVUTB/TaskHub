import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_models.dart';
import 'package:flutter/foundation.dart';

// Simple User model
class User {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  User({this.uid, this.displayName, this.email, this.photoURL});
}

// This is a simplified auth service. In a real app, you would integrate
// with Firebase Auth, your own backend, or another auth provider.
class AuthService extends ChangeNotifier {
  static const String baseUrl = 'http://localhost:8000'; // Cambia por tu IP real
  final storage = const FlutterSecureStorage();

  User? _currentUser;

  User? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Constructor - initialize with a debug user in debug mode
  AuthService() {
    // Simulamos un usuario autenticado para desarrollo
    if (kDebugMode) {
      _currentUser = User(
        uid: 'user123',
        displayName: 'Usuario de Prueba',
        email: 'usuario@example.com',
        photoURL: null,
      );
      notifyListeners();
    }
  }

  // Initialize the auth service and check for existing session
  Future<void> initialize() async {
    // Here you would check for existing auth tokens in secure storage
    // and validate them with your backend
    try {
      // Skip if we already have a debug user
      if (_currentUser != null) return;

      // Simulate loading user data
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, we'll assume no user is logged in initially
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      // Handle initialization error
      _currentUser = null;
      notifyListeners();
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    // Here you would make an API call to your auth endpoint
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, we'll create a mock user
      _currentUser = User(
        uid: 'user123',
        email: email,
        displayName: 'Usuario Autenticado',
        photoURL: null,
      );

      notifyListeners();
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  // Sign up with name, email and password
  Future<User?> signUp(String name, String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, we'll create a mock user
      _currentUser = User(
        uid: 'newuser456',
        email: email,
        displayName: name,
        photoURL: null,
      );

      notifyListeners();
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    // Here you would invalidate tokens on your backend
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    if (_currentUser == null) {
      throw Exception('No user is logged in');
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = User(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        displayName: displayName ?? _currentUser!.displayName,
        photoURL: photoURL ?? _currentUser!.photoURL,
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenDTO> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access_token']);
      return TokenDTO.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }

  Future<TokenDTO> register(String email, String password, String fullName, String companyName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        'company_name': companyName,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access_token']);
      return TokenDTO.fromJson(data);
    } else {
      throw Exception('Register failed');
    }
  }

  Future<UserProfileDTO> getProfile() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return UserProfileDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Profile fetch failed');
    }
  }
}
