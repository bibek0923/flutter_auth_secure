// domain/entities/user_entity.dart
class UserEntity {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isVerified,
  });
}



class LoginEntity {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
