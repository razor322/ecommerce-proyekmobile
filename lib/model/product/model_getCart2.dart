// To parse this JSON data, do
//
//     final modelGetCart2 = modelGetCart2FromJson(jsonString);

import 'dart:convert';

ModelGetCart2 modelGetCart2FromJson(String str) =>
    ModelGetCart2.fromJson(json.decode(str));

String modelGetCart2ToJson(ModelGetCart2 data) => json.encode(data.toJson());

class ModelGetCart2 {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelGetCart2({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelGetCart2.fromJson(Map<String, dynamic> json) => ModelGetCart2(
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
  String cartId;
  String productName;
  String productImage;
  String productDescription;
  String productPrice;
  String qty;
  String status;

  Datum({
    required this.cartId,
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.productPrice,
    required this.qty,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cartId: json["cart_id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        productDescription: json["product_description"],
        productPrice: json["product_price"],
        qty: json["qty"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_name": productName,
        "product_image": productImage,
        "product_description": productDescription,
        "product_price": productPrice,
        "qty": qty,
        "status": status,
      };
}
