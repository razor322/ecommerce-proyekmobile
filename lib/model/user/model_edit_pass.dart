// To parse this JSON data, do
//
//     final modelEditPass = modelEditPassFromJson(jsonString);

import 'dart:convert';

ModelEditPass modelEditPassFromJson(String str) =>
    ModelEditPass.fromJson(json.decode(str));

String modelEditPassToJson(ModelEditPass data) => json.encode(data.toJson());

class ModelEditPass {
  int value;
  String message;
  String email;
  String username;
  String id;
  DateTime updated;

  ModelEditPass({
    required this.value,
    required this.message,
    required this.email,
    required this.username,
    required this.id,
    required this.updated,
  });

  factory ModelEditPass.fromJson(Map<String, dynamic> json) => ModelEditPass(
        value: json["value"],
        message: json["message"],
        email: json["email"],
        username: json["username"],
        id: json["id"],
        updated: DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "email": email,
        "username": username,
        "id": id,
        "updated": updated.toIso8601String(),
      };
}
