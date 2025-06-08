import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'external_tools_models.dart';

class ExternalToolsService {
  static const String baseUrl = 'http://localhost:8000';
  final storage = const FlutterSecureStorage();

  Future<List<OAuthProviderDTO>> getOAuthProviders() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/oauth/providers'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => OAuthProviderDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch OAuth providers');
    }
  }

  Future<String> getAuthorizationUrl(String providerId, {String? redirectUri}) async {
    final token = await storage.read(key: 'access_token');
    final Map<String, dynamic> body = {
      "provider_id": providerId,
    };
    if (redirectUri != null) {
      body["redirect_uri"] = redirectUri;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/oauth/authorize'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Backend returns the URL string directly in the body
      return response.body;
    } else {
      throw Exception('Failed to get authorization URL. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<ExternalToolConnectionDTO> handleOAuthCallback(String providerId, String code, {String? state}) async {
    final token = await storage.read(key: 'access_token');
    final Map<String, dynamic> body = {
      "provider_id": providerId,
      "code": code,
    };
    if (state != null) {
      body["state"] = state;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/oauth/callback'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return ExternalToolConnectionDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to handle OAuth callback. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Obtener conexiones de usuario
  Future<List<ExternalToolConnectionDTO>> getUserConnections() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/connections'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ExternalToolConnectionDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch connections');
    }
  }

  // Eliminar conexión
  Future<void> deleteConnection(String connectionId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/connections/$connectionId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete connection');
    }
  }

  // Listar eventos de calendario externo
  Future<Map<String, dynamic>> listCalendarEvents() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/calendar/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch calendar events');
    }
  }

  // Crear evento en calendario externo
  Future<void> createCalendarEvent(String summary, String dtstart, String dtend) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      Uri.parse('$baseUrl/calendar/events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'summary': summary,
        'dtstart': dtstart,
        'dtend': dtend,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create calendar event');
    }
  }

  // Obtener datos de tarjeta de Metabase
  Future<Map<String, dynamic>> getMetabaseCardData(int cardId, String sessionToken, String metabaseUrl) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/analytics/card/$cardId?session_token=$sessionToken&metabase_url=$metabaseUrl'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch analytics data');
    }
  }
} 