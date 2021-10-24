// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.token,
    required this.loginId,
    required this.organizationName,
    required this.organizationLogo,
  });

  String token;
  int loginId;
  String organizationName;
  String organizationLogo;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json['token'],
        loginId: json['login_id'],
        organizationName: json['organization_name'],
        organizationLogo: json['organization_logo'],
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'login_id': loginId,
        'organization_name': organizationName,
        'organization_logo': organizationLogo,
      };
}
