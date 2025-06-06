class OAuthProviderDTO {
  final String id;
  final String name;
  final String type;
  final String authUrl;
  final String tokenUrl;
  final String scope;
  final String clientId;
  final String redirectUri;
  final Map<String, dynamic>? additionalParams;

  OAuthProviderDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.authUrl,
    required this.tokenUrl,
    required this.scope,
    required this.clientId,
    required this.redirectUri,
    this.additionalParams,
  });

  factory OAuthProviderDTO.fromJson(Map<String, dynamic> json) => OAuthProviderDTO(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        authUrl: json['auth_url'],
        tokenUrl: json['token_url'],
        scope: json['scope'],
        clientId: json['client_id'],
        redirectUri: json['redirect_uri'],
        additionalParams: json['additional_params'] != null ? Map<String, dynamic>.from(json['additional_params']) : null,
      );
}

class ExternalToolConnectionDTO {
  final String id;
  final String userId;
  final String providerId;
  final String providerType;
  final String? accountName;
  final String? accountEmail;
  final String? accountId;
  final bool isActive;
  final Map<String, dynamic>? metaData;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastUsedAt;
  final DateTime? expiresAt;

  ExternalToolConnectionDTO({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.providerType,
    this.accountName,
    this.accountEmail,
    this.accountId,
    this.isActive = true,
    this.metaData,
    required this.createdAt,
    this.updatedAt,
    this.lastUsedAt,
    this.expiresAt,
  });

  factory ExternalToolConnectionDTO.fromJson(Map<String, dynamic> json) => ExternalToolConnectionDTO(
        id: json['id'],
        userId: json['user_id'],
        providerId: json['provider_id'],
        providerType: json['provider_type'],
        accountName: json['account_name'],
        accountEmail: json['account_email'],
        accountId: json['account_id'],
        isActive: json['is_active'] ?? true,
        metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data']) : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
        lastUsedAt: json['last_used_at'] != null ? DateTime.parse(json['last_used_at']) : null,
        expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      );
}

class ExternalResourceDTO {
  final String id;
  final String connectionId;
  final String resourceId;
  final String name;
  final String type;
  final String? url;
  final String? path;
  final int? size;
  final DateTime? lastModified;
  final Map<String, dynamic>? metaData;

  ExternalResourceDTO({
    required this.id,
    required this.connectionId,
    required this.resourceId,
    required this.name,
    required this.type,
    this.url,
    this.path,
    this.size,
    this.lastModified,
    this.metaData,
  });

  factory ExternalResourceDTO.fromJson(Map<String, dynamic> json) => ExternalResourceDTO(
        id: json['id'],
        connectionId: json['connection_id'],
        resourceId: json['resource_id'],
        name: json['name'],
        type: json['type'],
        url: json['url'],
        path: json['path'],
        size: json['size'],
        lastModified: json['last_modified'] != null ? DateTime.parse(json['last_modified']) : null,
        metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data']) : null,
      );
}

class ExternalResourceSyncDTO {
  final String connectionId;
  final String resourceId;
  final String? projectId;
  final String? targetFolderId;
  final String syncDirection;
  final bool autoSync;
  final int? syncInterval;

  ExternalResourceSyncDTO({
    required this.connectionId,
    required this.resourceId,
    this.projectId,
    this.targetFolderId,
    this.syncDirection = 'download',
    this.autoSync = false,
    this.syncInterval,
  });

  factory ExternalResourceSyncDTO.fromJson(Map<String, dynamic> json) => ExternalResourceSyncDTO(
        connectionId: json['connection_id'],
        resourceId: json['resource_id'],
        projectId: json['project_id'],
        targetFolderId: json['target_folder_id'],
        syncDirection: json['sync_direction'] ?? 'download',
        autoSync: json['auto_sync'] ?? false,
        syncInterval: json['sync_interval'],
      );
} 