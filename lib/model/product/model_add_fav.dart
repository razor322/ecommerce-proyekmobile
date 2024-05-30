// To parse this JSON data, do
//
//     final modelAddFavorite = modelAddFavoriteFromJson(jsonString);

import 'dart:convert';

ModelAddFavorite modelAddFavoriteFromJson(String str) =>
    ModelAddFavorite.fromJson(json.decode(str));

String modelAddFavoriteToJson(ModelAddFavorite data) =>
    json.encode(data.toJson());

class ModelAddFavorite {
  final int value;
  final String message;

  ModelAddFavorite({
    required this.value,
    required this.message,
  });

  factory ModelAddFavorite.fromJson(Map<String, dynamic> json) =>
      ModelAddFavorite(
        value: json["value"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
      };
}
