// To parse this JSON data, do
//
//     final modelSnapToken = modelSnapTokenFromJson(jsonString);

import 'dart:convert';

ModelSnapToken modelSnapTokenFromJson(String str) =>
    ModelSnapToken.fromJson(json.decode(str));

String modelSnapTokenToJson(ModelSnapToken data) => json.encode(data.toJson());

class ModelSnapToken {
  String snapToken;

  ModelSnapToken({
    required this.snapToken,
  });

  factory ModelSnapToken.fromJson(Map<String, dynamic> json) => ModelSnapToken(
        snapToken: json["snap_token"],
      );

  Map<String, dynamic> toJson() => {
        "snap_token": snapToken,
      };
}
