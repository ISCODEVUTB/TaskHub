class DocumentDTO {
  final String id;
  final String name;
  final String projectId;
  final String? parentId;
  final String type;
  final String? contentType;
  final int? size;
  final String? url;
  final String? description;
  final int version;
  final String creatorId;
  final List<String>? tags;
  final Map<String, dynamic>? metaData;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DocumentDTO({
    required this.id,
    required this.name,
    required this.projectId,
    this.parentId,
    required this.type,
    this.contentType,
    this.size,
    this.url,
    this.description,
    required this.version,
    required this.creatorId,
    this.tags,
    this.metaData,
    required this.createdAt,
    this.updatedAt,
  });

  factory DocumentDTO.fromJson(Map<String, dynamic> json) => DocumentDTO(
        id: json['id'],
        name: json['name'],
        projectId: json['project_id'],
        parentId: json['parent_id'],
        type: json['type'],
        contentType: json['content_type'],
        size: json['size'],
        url: json['url'],
        description: json['description'],
        version: json['version'],
        creatorId: json['creator_id'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data']) : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
} 