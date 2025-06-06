import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'project_models.dart';

class ProjectService {
  static const String baseUrl = 'http://api_gateway:8000';
  final storage = const FlutterSecureStorage();

  Future<List<ProjectDTO>> getProjects() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProjectDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch projects');
    }
  }

  Future<ProjectDTO> createProject({
    required String name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String status = 'planning',
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate.toIso8601String(),
      if (endDate != null) 'end_date': endDate.toIso8601String(),
      'status': status,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return ProjectDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  Future<ProjectDTO> getProjectById(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return ProjectDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch project detail');
    }
  }

  Future<void> deleteProject(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }

  Future<List<ProjectMemberDTO>> getProjectMembers(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/members'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProjectMemberDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch project members');
    }
  }

  Future<List<TaskDTO>> getProjectTasks(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TaskDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch project tasks');
    }
  }

  Future<TaskDTO> getTaskDetails(String projectId, String taskId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/tasks/$taskId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return TaskDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch task details');
    }
  }

  Future<List<ActivityDTO>> getProjectActivities(String projectId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/activities'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ActivityDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch project activities');
    }
  }

  Future<TaskDTO> createTask({
    required String projectId,
    required String title,
    String? description,
    String? assigneeId,
    DateTime? dueDate,
    String priority = 'medium',
    String status = 'todo',
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      'title': title,
      if (description != null) 'description': description,
      if (assigneeId != null) 'assignee_id': assigneeId,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return TaskDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<TaskDTO> updateTask({
    required String projectId,
    required String taskId,
    String? title,
    String? description,
    String? assigneeId,
    DateTime? dueDate,
    String? priority,
    String? status,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (assigneeId != null) 'assignee_id': assigneeId,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/projects/$projectId/tasks/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return TaskDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String projectId, String taskId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/projects/$projectId/tasks/$taskId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<ProjectDTO> updateProject({
    required String projectId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate.toIso8601String(),
      if (endDate != null) 'end_date': endDate.toIso8601String(),
      if (status != null) 'status': status,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return ProjectDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update project');
    }
  }

  Future<ProjectMemberDTO> addProjectMember({
    required String projectId,
    required String userId,
    String role = 'member',
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      'user_id': userId,
      'role': role,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/members'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return ProjectMemberDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add project member');
    }
  }

  Future<void> removeProjectMember({
    required String projectId,
    required String memberId,
  }) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/projects/$projectId/members/$memberId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove project member');
    }
  }

  Future<List<TaskCommentDTO>> getTaskComments({
    required String projectId,
    required String taskId,
  }) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/tasks/$taskId/comments'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TaskCommentDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch task comments');
    }
  }

  Future<TaskCommentDTO> addTaskComment({
    required String projectId,
    required String taskId,
    required String content,
    String? parentId,
  }) async {
    final token = await storage.read(key: 'access_token');
    final body = {
      'content': content,
      if (parentId != null) 'parent_id': parentId,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/tasks/$taskId/comments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return TaskCommentDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add task comment');
    }
  }
} 