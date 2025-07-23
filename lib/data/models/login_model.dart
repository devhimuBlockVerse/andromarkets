class UserModel {
  final String id;
  final String name;
  final String email;
  final String? emailVerifiedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
    );
  }
}

class LoginResponseModel {
  final UserModel user;
  final String token;
  final List<String> roles;
  final List<String> permissions;

  LoginResponseModel({
    required this.user,
    required this.token,
    required this.roles,
    required this.permissions,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
      roles: List<String>.from(json['roles']),
      permissions: List<String>.from(json['permissions']),
    );
  }
}
