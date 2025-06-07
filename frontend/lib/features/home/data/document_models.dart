// Defines the DocumentType enum and related helper functions
enum DocumentType {
  file,
  folder,
  link
}

// Helper function to convert DocumentType enum to a string for serialization
String documentTypeToString(DocumentType type) {
  return type.toString().split('.').last;
}

// Helper function to parse a string into DocumentType enum, with a fallback
DocumentType documentTypeFromString(String? typeString) {
  if (typeString == null) {
    return DocumentType.file; // Default or handle as an error appropriately
  }
  return DocumentType.values.firstWhere(
    (e) => e.toString().split('.').last.toLowerCase() == typeString.toLowerCase(),
    orElse: () => DocumentType.file, // Default for unrecognized strings
  );
}

class DocumentDTO {
  final String id;
  final String name;
  final String projectId;
  final String? parentId;
  final DocumentType type; // Changed from String to DocumentType
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
    required this.type, // Type is DocumentType
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
        id: json['id'] as String,
        name: json['name'] as String,
        projectId: json['project_id'] as String,
        parentId: json['parent_id'] as String?,
        type: documentTypeFromString(json['type'] as String?), // Use helper for parsing
        contentType: json['content_type'] as String?,
        size: json['size'] as int?,
        url: json['url'] as String?,
        description: json['description'] as String?,
        version: json['version'] as int,
        creatorId: json['creator_id'] as String,
        tags: json['tags'] != null ? List<String>.from(json['tags'] as List<dynamic>) : null,
        metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data'] as Map<String,dynamic>) : null,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      );

  // Add toJson if needed for sending this DTO to backend (ensure type is converted back to string)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'project_id': projectId,
        'parent_id': parentId,
        'type': documentTypeToString(type), // Convert enum to string
        'content_type': contentType,
        'size': size,
        'url': url,
        'description': description,
        'version': version,
        'creator_id': creatorId,
        'tags': tags,
        'meta_data': metaData,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
} 