// UserCredential là domain entity
// Không có JSON
// Không có fromJson()
// Không phụ thuộc tầng data
// Không xử lý logic mạng
// → Đây là pure Dart object, dùng trong UseCase và Bloc.

class UserCredential {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  final String? tokenType;
  final String? userId;

  const UserCredential({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    this.tokenType,
    this.userId,
  });

  bool get isExpired {
    if (expiresAt == null) {
      return false;
    }
    return DateTime.now().isAfter(expiresAt!);
  }
}
