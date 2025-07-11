// import'package:flutter/material.dart';

// class LoginRequest {
// final username;
// final password;
// LoginRequest(this.password,this.username);

// LoginRequest toJson()

// }

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
    String username;
    String password;

    LoginRequest({
        required this.username,
        required this.password,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}