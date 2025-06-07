import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_models.dart';
import 'package:flutter/foundation.dart'; // ChangeNotifier is here

// This is a simplified auth service. In a real app, you would integrate
// with Firebase Auth, your own backend, or another auth provider.
class AuthService extends ChangeNotifier {
  static const String baseUrl = 'http://api_gateway:8000';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserProfileDTO? _currentUser;

  UserProfileDTO? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Constructor
  AuthService() {
    initialize();
  }

  // Initialize the auth service and check for existing session
  Future<void> initialize() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (token != null && token.isNotEmpty) {
        // Validate token by fetching profile
        final userProfile = await getProfile(); // getProfile uses the stored token
        _currentUser = userProfile;
      } else {
        _currentUser = null;
      }
    } catch (e) {
      // If getProfile fails (e.g. token expired), clear token and user
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      _currentUser = null;
    }
    notifyListeners();
  }

  // Login with email and password
  Future<UserProfileDTO> login(String email, String password) async {
    print('[AuthService.login] Attempting to login...');
    print('[AuthService.login] URL: $baseUrl/auth/login');
    print('[AuthService.login] Headers: {Content-Type: application/x-www-form-urlencoded}');
    print('[AuthService.login] Body: {username: $email, password: <hidden>}');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Backend expects form data for login
      body: {'username': email, 'password': password}, // FastAPI's OAuth2PasswordRequestForm takes 'username'
    );

    if (response.statusCode == 200) {
      print('[AuthService.login] Login API call successful. Status: ${response.statusCode}');
      print('[AuthService.login] Response body: ${response.body}');
      final data = jsonDecode(response.body);
      final tokenDto = TokenDTO.fromJson(data);
      await _secureStorage.write(key: 'access_token', value: tokenDto.accessToken);
      await _secureStorage.write(key: 'refresh_token', value: tokenDto.refreshToken);

      try {
        _currentUser = await getProfile();
        notifyListeners();
        return _currentUser!; // Assuming getProfile will throw if it can't return a user
      } catch (e) {
        print('[AuthService.login] Error fetching profile after login: ${e.toString()}');
        // If getProfile fails after login, something is wrong. Clean up.
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        _currentUser = null;
        notifyListeners();
        throw Exception('Login succeeded but failed to fetch profile: ${e.toString()}');
      }
    } else {
      print('[AuthService.login] Login API call failed. Status: ${response.statusCode}');
      print('[AuthService.login] Response body: ${response.body}');
      _currentUser = null;
      notifyListeners();
      throw Exception('Login failed with status ${response.statusCode}: ${response.body}');
    }
  }

  // Register with email, password, full name, and company name
  Future<UserProfileDTO> register(String email, String password, String fullName, String? companyName) async {
    print('[AuthService.register] Attempting to register...');
    print('[AuthService.register] URL: $baseUrl/auth/register');
    final requestBodyMap = {
      'email': email,
      'password': password,
      'full_name': fullName,
      if (companyName != null && companyName.isNotEmpty) 'company_name': companyName,
    };
    print('[AuthService.register] Headers: {Content-Type: application/json}');
    // Mask password for logging
    final loggableBody = Map.from(requestBodyMap);
    loggableBody['password'] = '<hidden>';
    print('[AuthService.register] Request body (raw): $loggableBody');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBodyMap), // Send original map with actual password
    );

    if (response.statusCode == 200 || response.statusCode == 201) { // Typically 201 for register
      print('[AuthService.register] Register API call successful. Status: ${response.statusCode}');
      print('[AuthService.register] Response body: ${response.body}');
      final data = jsonDecode(response.body);
      final tokenDto = TokenDTO.fromJson(data);
      await _secureStorage.write(key: 'access_token', value: tokenDto.accessToken);
      await _secureStorage.write(key: 'refresh_token', value: tokenDto.refreshToken);

      try {
        _currentUser = await getProfile();
        notifyListeners();
        return _currentUser!;
      } catch (e) {
        print('[AuthService.register] Error fetching profile after registration: ${e.toString()}');
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        _currentUser = null;
        notifyListeners();
        throw Exception('Registration succeeded but failed to fetch profile: ${e.toString()}');
      }
    } else {
      print('[AuthService.register] Register API call failed. Status: ${response.statusCode}');
      print('[AuthService.register] Response body: ${response.body}');
      _currentUser = null;
      notifyListeners();
      throw Exception('Register failed with status ${response.statusCode}: ${response.body}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        // Regardless of API call success, clear local data
      } catch (e) {
        // Log error or handle silently, but still proceed with local cleanup
        if (kDebugMode) {
          print('Error during API logout: $e');
        }
      }
    }

    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    _currentUser = null;
    notifyListeners();
  }

  // Get user profile
  Future<UserProfileDTO> getProfile() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Not authenticated: No token found.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserProfileDTO.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) { // Unauthorized
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        _currentUser = null;
        notifyListeners();
        throw Exception('Session expired or token invalid. Please login again.');
    }
    else {
      throw Exception('Failed to fetch profile with status ${response.statusCode}: ${response.body}');
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? email}) async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Not authenticated for updating profile.');
    }

    final Map<String, String> body = {};
    if (displayName != null) body['full_name'] = displayName;
    if (email != null) body['email'] = email;

    if (body.isEmpty) {
      return; // No changes to update
    }

    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Optionally, re-fetch profile to update _currentUser if email or other critical fields changed
      _currentUser = await getProfile();
      notifyListeners();
    } else {
      throw Exception('Error al actualizar perfil: ${response.body}');
    }
  }
}
