// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String refresh;
    String access;
    User user;

    LoginResponse({
        required this.refresh,
        required this.access,
        required this.user,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        refresh: json["refresh"],
        access: json["access"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String username;
    String email;
    String role;
    bool isVerified;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.role,
        required this.isVerified,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        isVerified: json["is_verified"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "role": role,
        "is_verified": isVerified,
    };
    
}
//to add functionality to any class we use extension
extension LoginResponseMapper on LoginResponse {
  LoginEntity toEntity() {
    return LoginEntity(
      accessToken: access,
      refreshToken: refresh,
      user: user.toEntity(),
    );
  }
}

extension UserResponseMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      role: role,
      isVerified: isVerified,
    );
  }
}
