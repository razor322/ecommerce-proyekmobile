// To parse this JSON data, do
//
//     final modelAdd = modelAddFromJson(jsonString);

import 'dart:convert';

ModelAdd modelAddFromJson(String str) =>
    ModelAdd.fromJson(json.decode(str));

String modelAddToJson(ModelAdd data) => json.encode(data.toJson());

class ModelAdd {
  bool isSuccess;
  String message;

  ModelAdd({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAdd.fromJson(Map<String, dynamic> json) => ModelAdd(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
      };
}
