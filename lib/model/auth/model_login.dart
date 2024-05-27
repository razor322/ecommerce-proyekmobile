// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) =>
    ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String email;
  String id;

  ModelLogin({
    required this.value,
    required this.message,
    required this.email,
    required this.id,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        value: json["value"],
        message: json["message"],
        email: json["email"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "email": email,
        "id": id,
      };
}
