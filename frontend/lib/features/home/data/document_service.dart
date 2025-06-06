import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'document_models.dart';

class DocumentService {
  static const String baseUrl = 'http://localhost:8000';
  final storage = const FlutterSecureStorage();

  Future<List<DocumentDTO>> getProjectDocuments(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/documents'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DocumentDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch documents');
    }
  }

  Future<DocumentDTO> createDocument({
    required String name,
    required String projectId,
    required String type,
    String? parentId,
    String? contentType,
    String? url,
    String? description,
    List<String>? tags,
    Map<String, dynamic>? metaData,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      'name': name,
      'project_id': projectId,
      'type': type,
      if (parentId != null) 'parent_id': parentId,
      if (contentType != null) 'content_type': contentType,
      if (url != null) 'url': url,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (metaData != null) 'meta_data': metaData,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/documents'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return DocumentDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create document');
    }
  }

  Future<DocumentDTO> getDocumentById(String documentId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/documents/$documentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return DocumentDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch document detail');
    }
  }

  Future<void> deleteDocument(String documentId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/documents/$documentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete document');
    }
  }
} 