class NotificationDTO {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final String priority;
  final List<String> channels;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String? actionUrl;
  final Map<String, dynamic>? metaData;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final DateTime? sentAt;

  NotificationDTO({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    required this.channels,
    this.relatedEntityType,
    this.relatedEntityId,
    this.actionUrl,
    this.metaData,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.scheduledAt,
    this.sentAt,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) => NotificationDTO(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        title: json['title'],
        message: json['message'],
        priority: json['priority'],
        channels: List<String>.from(json['channels']),
        relatedEntityType: json['related_entity_type'],
        relatedEntityId: json['related_entity_id'],
        actionUrl: json['action_url'],
        metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data']) : null,
        isRead: json['is_read'],
        readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
        createdAt: DateTime.parse(json['created_at']),
        scheduledAt: json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at']) : null,
        sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      );
}

class NotificationPreferencesDTO {
  final String userId;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool smsEnabled;
  final bool inAppEnabled;
  final bool digestEnabled;
  final String? digestFrequency;
  final bool quietHoursEnabled;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final Map<String, dynamic>? preferencesByType;

  NotificationPreferencesDTO({
    required this.userId,
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.smsEnabled = false,
    this.inAppEnabled = true,
    this.digestEnabled = false,
    this.digestFrequency,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.preferencesByType,
  });

  factory NotificationPreferencesDTO.fromJson(Map<String, dynamic> json) => NotificationPreferencesDTO(
        userId: json['user_id'],
        emailEnabled: json['email_enabled'] ?? true,
        pushEnabled: json['push_enabled'] ?? true,
        smsEnabled: json['sms_enabled'] ?? false,
        inAppEnabled: json['in_app_enabled'] ?? true,
        digestEnabled: json['digest_enabled'] ?? false,
        digestFrequency: json['digest_frequency'],
        quietHoursEnabled: json['quiet_hours_enabled'] ?? false,
        quietHoursStart: json['quiet_hours_start'],
        quietHoursEnd: json['quiet_hours_end'],
        preferencesByType: json['preferences_by_type'] != null ? Map<String, dynamic>.from(json['preferences_by_type']) : null,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'email_enabled': emailEnabled,
        'push_enabled': pushEnabled,
        'sms_enabled': smsEnabled,
        'in_app_enabled': inAppEnabled,
        'digest_enabled': digestEnabled,
        'digest_frequency': digestFrequency,
        'quiet_hours_enabled': quietHoursEnabled,
        'quiet_hours_start': quietHoursStart,
        'quiet_hours_end': quietHoursEnd,
        'preferences_by_type': preferencesByType,
      };
} 