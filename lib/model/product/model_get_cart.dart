// To parse this JSON data, do
//
//     final modelGetCart = modelGetCartFromJson(jsonString);

import 'dart:convert';

ModelGetCart modelGetCartFromJson(String str) =>
    ModelGetCart.fromJson(json.decode(str));

String modelGetCartToJson(ModelGetCart data) => json.encode(data.toJson());

class ModelGetCart {
  int value;
  String message;
  List<Cart> cart;

  ModelGetCart({
    required this.value,
    required this.message,
    required this.cart,
  });

  factory ModelGetCart.fromJson(Map<String, dynamic> json) => ModelGetCart(
        value: json["value"],
        message: json["message"],
        cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
      };
}

class Cart {
  int cartId;
  int userId;
  int productId;
  DateTime createdAt;
  DateTime updated;
  String productName;
  String productCategory;
  String productDescription;
  String productImage;
  int productPrice;
  String productStore;

  Cart({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.updated,
    required this.productName,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productPrice,
    required this.productStore,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json["cart_id"],
        userId: json["user_id"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updated: DateTime.parse(json["updated"]),
        productName: json["product_name"],
        productCategory: json["product_category"],
        productDescription: json["product_description"],
        productImage: json["product_image"],
        productPrice: json["product_price"],
        productStore: json["product_store"],
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "user_id": userId,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated": updated.toIso8601String(),
        "product_name": productName,
        "product_category": productCategory,
        "product_description": productDescription,
        "product_image": productImage,
        "product_price": productPrice,
        "product_store": productStore,
      };
}
