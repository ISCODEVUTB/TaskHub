class ProjectDTO {
  final String id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final String ownerId;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProjectDTO({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    required this.status,
    required this.ownerId,
    this.tags,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProjectDTO.fromJson(Map<String, dynamic> json) => ProjectDTO(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
        endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        status: json['status'],
        ownerId: json['owner_id'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
}

class ProjectMemberDTO {
  final String id;
  final String projectId;
  final String userId;
  final String role;
  final DateTime joinedAt;

  ProjectMemberDTO({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  factory ProjectMemberDTO.fromJson(Map<String, dynamic> json) => ProjectMemberDTO(
        id: json['id'],
        projectId: json['project_id'],
        userId: json['user_id'],
        role: json['role'],
        joinedAt: DateTime.parse(json['joined_at']),
      );
}

class TaskDTO {
  final String id;
  final String title;
  final String? description;
  final String projectId;
  final String creatorId;
  final String? assigneeId;
  final DateTime? dueDate;
  final String priority;
  final String status;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TaskDTO({
    required this.id,
    required this.title,
    this.description,
    required this.projectId,
    required this.creatorId,
    this.assigneeId,
    this.dueDate,
    required this.priority,
    required this.status,
    this.tags,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) => TaskDTO(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        projectId: json['project_id'],
        creatorId: json['creator_id'],
        assigneeId: json['assignee_id'],
        dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
        priority: json['priority'],
        status: json['status'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
}

class ActivityDTO {
  final String id;
  final String projectId;
  final String userId;
  final String action;
  final String entityType;
  final String entityId;
  final Map<String, dynamic>? details;
  final DateTime createdAt;

  ActivityDTO({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.details,
    required this.createdAt,
  });

  factory ActivityDTO.fromJson(Map<String, dynamic> json) => ActivityDTO(
        id: json['id'],
        projectId: json['project_id'],
        userId: json['user_id'],
        action: json['action'],
        entityType: json['entity_type'],
        entityId: json['entity_id'],
        details: json['details'] != null ? Map<String, dynamic>.from(json['details']) : null,
        createdAt: DateTime.parse(json['created_at']),
      );
}

class TaskCommentDTO {
  final String id;
  final String taskId;
  final String userId;
  final String content;
  final String? parentId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TaskCommentDTO({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    this.parentId,
    required this.createdAt,
    this.updatedAt,
  });

  factory TaskCommentDTO.fromJson(Map<String, dynamic> json) => TaskCommentDTO(
        id: json['id'],
        taskId: json['task_id'],
        userId: json['user_id'],
        content: json['content'],
        parentId: json['parent_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
} 