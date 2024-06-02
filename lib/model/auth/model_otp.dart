// To parse this JSON data, do
//
//     final modelOtp = modelOtpFromJson(jsonString);

import 'dart:convert';

ModelOtp modelOtpFromJson(String str) => ModelOtp.fromJson(json.decode(str));

String modelOtpToJson(ModelOtp data) => json.encode(data.toJson());

class ModelOtp {
  int value;
  String message;

  ModelOtp({
    required this.value,
    required this.message,
  });

  factory ModelOtp.fromJson(Map<String, dynamic> json) => ModelOtp(
        value: json["value"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
      };
}
