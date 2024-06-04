// To parse this JSON data, do
//
//     final modelCart = modelCartFromJson(jsonString);

import 'dart:convert';

ModelCart modelCartFromJson(String str) => ModelCart.fromJson(json.decode(str));

String modelCartToJson(ModelCart data) => json.encode(data.toJson());

class ModelCart {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelCart({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelCart.fromJson(Map<String, dynamic> json) => ModelCart(
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
