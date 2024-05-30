// To parse this JSON data, do
//
//     final modelEditProfile = modelEditProfileFromJson(jsonString);

import 'dart:convert';

ModelEditProfile modelEditProfileFromJson(String str) =>
    ModelEditProfile.fromJson(json.decode(str));

String modelEditProfileToJson(ModelEditProfile data) =>
    json.encode(data.toJson());

class ModelEditProfile {
  final int value;
  final String message;
  final String email;
  final String username;
  final String id;
  final DateTime updated;

  ModelEditProfile({
    required this.value,
    required this.message,
    required this.email,
    required this.username,
    required this.id,
    required this.updated,
  });

  factory ModelEditProfile.fromJson(Map<String, dynamic> json) =>
      ModelEditProfile(
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
