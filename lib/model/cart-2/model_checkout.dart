// To parse this JSON data, do
//
//     final modelCheckout = modelCheckoutFromJson(jsonString);

import 'dart:convert';

ModelCheckout modelCheckoutFromJson(String str) =>
    ModelCheckout.fromJson(json.decode(str));

String modelCheckoutToJson(ModelCheckout data) => json.encode(data.toJson());

class ModelCheckout {
  String snapToken;
  String userId;
  int orderId;

  ModelCheckout({
    required this.snapToken,
    required this.userId,
    required this.orderId,
  });

  factory ModelCheckout.fromJson(Map<String, dynamic> json) => ModelCheckout(
        snapToken: json["snap_token"],
        userId: json["user_id"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "snap_token": snapToken,
        "user_id": userId,
        "order_id": orderId,
      };
}
