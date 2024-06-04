// To parse this JSON data, do
//
//     final modelAddjms = modelAddjmsFromJson(jsonString);

import 'dart:convert';

ModelAddjms modelAddjmsFromJson(String str) =>
    ModelAddjms.fromJson(json.decode(str));

String modelAddjmsToJson(ModelAddjms data) => json.encode(data.toJson());

class ModelAddjms {
  bool isSuccess;
  String message;

  ModelAddjms({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddjms.fromJson(Map<String, dynamic> json) => ModelAddjms(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
      };
}
