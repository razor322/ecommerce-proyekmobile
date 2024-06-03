// To parse this JSON data, do
//
//     final modelDeleteFav = modelDeleteFavFromJson(jsonString);

import 'dart:convert';

ModelDeleteFav modelDeleteFavFromJson(String str) =>
    ModelDeleteFav.fromJson(json.decode(str));

String modelDeleteFavToJson(ModelDeleteFav data) => json.encode(data.toJson());

class ModelDeleteFav {
  String status;
  String message;

  ModelDeleteFav({
    required this.status,
    required this.message,
  });

  factory ModelDeleteFav.fromJson(Map<String, dynamic> json) => ModelDeleteFav(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
