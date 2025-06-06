import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'notification_models.dart';

class NotificationService {
  static const String baseUrl = 'http://api_gateway:8000';
  final storage = const FlutterSecureStorage();

  Future<List<NotificationDTO>> getNotifications() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NotificationDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/$notificationId/read'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/notifications/$notificationId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/read-all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // Backend returns a dictionary like {"message": "...", "count": ...}, so 200 is expected.
    // 204 No Content could also be valid for some PUT operations if nothing is returned.
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to mark all notifications as read. Status: ${response.statusCode}');
    }
  }

  // Nuevo: obtener notificaciones del usuario
  Future<List<NotificationDTO>> getUserNotifications() async {
    return getNotifications();
  }

  // Nuevo: marcar notificación como leída
  Future<void> markNotificationAsRead(String notificationId) async {
    return markAsRead(notificationId);
  }

  // Nuevo: obtener preferencias de notificación
  Future<NotificationPreferencesDTO> getNotificationPreferences() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/notification-preferences'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return NotificationPreferencesDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch notification preferences');
    }
  }

  // Nuevo: actualizar preferencias de notificación
  Future<void> updateNotificationPreferences(NotificationPreferencesDTO dto) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.put(
      Uri.parse('$baseUrl/notification-preferences'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update notification preferences');
    }
  }
} 