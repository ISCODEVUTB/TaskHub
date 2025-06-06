class TokenDTO {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final DateTime expiresAt;

  TokenDTO({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresAt,
  });

  factory TokenDTO.fromJson(Map<String, dynamic> json) => TokenDTO(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        tokenType: json['token_type'],
        expiresAt: DateTime.parse(json['expires_at']),
      );
}

class UserProfileDTO {
  final String id;
  final String email;
  final String fullName;
  final String? companyName;
  final String role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfileDTO({
    required this.id,
    required this.email,
    required this.fullName,
    this.companyName,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) => UserProfileDTO(
        id: json['id'],
        email: json['email'],
        fullName: json['full_name'],
        companyName: json['company_name'],
        role: json['role'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
} 