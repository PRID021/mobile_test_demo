import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';

class UserCredentialModel extends UserCredential {
  const UserCredentialModel({
    required super.accessToken,
    required super.refreshToken,
    super.expiresAt,
    super.tokenType,
    super.userId,
  });

  factory UserCredentialModel.fromJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'],
      userId: json['user_id'],
      expiresAt: json['expires_in'] != null
          ? DateTime.now().add(Duration(seconds: json['expires_in'] as int))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user_id': userId,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
