// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

ModelProduct modelProductFromJson(String str) =>
    ModelProduct.fromJson(json.decode(str));

String modelProductToJson(ModelProduct data) => json.encode(data.toJson());

class ModelProduct {
  int value;
  String message;
  List<Product> products;

  ModelProduct({
    required this.value,
    required this.message,
    required this.products,
  });

  factory ModelProduct.fromJson(Map<String, dynamic> json) => ModelProduct(
        value: json["value"],
        message: json["message"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String productId;
  String productName;
  String productCategory;
  String productDescription;
  String productImage;
  String productPrice;
  String productStore;
  String qty;
  DateTime created;
  dynamic updated;

  Product({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productPrice,
    required this.productStore,
    required this.qty,
    required this.created,
    required this.updated,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        productName: json["product_name"],
        productCategory: json["product_category"],
        productDescription: json["product_description"],
        productImage: json["product_image"],
        productPrice: json["product_price"],
        productStore: json["product_store"],
        qty: json["qty"],
        created: DateTime.parse(json["created"]),
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_category": productCategory,
        "product_description": productDescription,
        "product_image": productImage,
        "product_price": productPrice,
        "product_store": productStore,
        "qty": qty,
        "created": created.toIso8601String(),
        "updated": updated,
      };
}
