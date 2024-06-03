// To parse this JSON data, do
//
//     final modelPayments = modelPaymentsFromJson(jsonString);

import 'dart:convert';

ModelPayments modelPaymentsFromJson(String str) =>
    ModelPayments.fromJson(json.decode(str));

String modelPaymentsToJson(ModelPayments data) => json.encode(data.toJson());

class ModelPayments {
  int value;
  String message;

  ModelPayments({
    required this.value,
    required this.message,
  });

  factory ModelPayments.fromJson(Map<String, dynamic> json) => ModelPayments(
        value: json["value"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
      };
}
