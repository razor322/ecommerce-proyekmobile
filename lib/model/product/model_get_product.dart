// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

ModelProduct modelProductFromJson(String str) =>
    ModelProduct.fromJson(json.decode(str));

String modelProductToJson(ModelProduct data) => json.encode(data.toJson());

class ModelProduct {
  final int value;
  final String message;
  final List<Product> products;

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
  final String productId;
  final String productName;
  final String productDescription;
  final String productImage;
  final String productPrice;
  final String productStore;
  final DateTime created;
  final dynamic updated;

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.productPrice,
    required this.productStore,
    required this.created,
    required this.updated,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        productName: json["product_name"],
        productDescription: json["product_description"],
        productImage: json["product_image"],
        productPrice: json["product_price"],
        productStore: json["product_store"],
        created: DateTime.parse(json["created"]),
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_description": productDescription,
        "product_image": productImage,
        "product_price": productPrice,
        "product_store": productStore,
        "created": created.toIso8601String(),
        "updated": updated,
      };
}
