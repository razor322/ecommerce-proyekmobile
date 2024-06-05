// To parse this JSON data, do
//
//     final modelHistory = modelHistoryFromJson(jsonString);

import 'dart:convert';

ModelHistory modelHistoryFromJson(String str) =>
    ModelHistory.fromJson(json.decode(str));

String modelHistoryToJson(ModelHistory data) => json.encode(data.toJson());

class ModelHistory {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelHistory({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelHistory.fromJson(Map<String, dynamic> json) => ModelHistory(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String orderId;
  String amount;
  String customerAddress;
  String status;
  String snapToken;
  String cartProductId;
  DateTime createdAt;
  String idUser;

  Datum({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.customerAddress,
    required this.status,
    required this.snapToken,
    required this.cartProductId,
    required this.createdAt,
    required this.idUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        amount: json["amount"],
        customerAddress: json["customer_address"],
        status: json["status"],
        snapToken: json["snap_token"],
        cartProductId: json["cart_product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        idUser: json["id_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "amount": amount,
        "customer_address": customerAddress,
        "status": status,
        "snap_token": snapToken,
        "cart_product_id": cartProductId,
        "created_at": createdAt.toIso8601String(),
        "id_user": idUser,
      };
}
