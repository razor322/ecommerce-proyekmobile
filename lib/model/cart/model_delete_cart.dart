// To parse this JSON data, do
//
//     final modelDeleteCart = modelDeleteCartFromJson(jsonString);

import 'dart:convert';

ModelDeleteCart modelDeleteCartFromJson(String str) =>
    ModelDeleteCart.fromJson(json.decode(str));

String modelDeleteCartToJson(ModelDeleteCart data) =>
    json.encode(data.toJson());

class ModelDeleteCart {
  String status;
  String message;

  ModelDeleteCart({
    required this.status,
    required this.message,
  });

  factory ModelDeleteCart.fromJson(Map<String, dynamic> json) =>
      ModelDeleteCart(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
