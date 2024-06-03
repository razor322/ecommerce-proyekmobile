// To parse this JSON data, do
//
//     final modelGetFav = modelGetFavFromJson(jsonString);

import 'dart:convert';

ModelGetFav modelGetFavFromJson(String str) =>
    ModelGetFav.fromJson(json.decode(str));

String modelGetFavToJson(ModelGetFav data) => json.encode(data.toJson());

class ModelGetFav {
  int value;
  String message;
  List<Favorite> favorites;

  ModelGetFav({
    required this.value,
    required this.message,
    required this.favorites,
  });

  factory ModelGetFav.fromJson(Map<String, dynamic> json) => ModelGetFav(
        value: json["value"],
        message: json["message"],
        favorites: List<Favorite>.from(
            json["favorites"].map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "favorites": List<dynamic>.from(favorites.map((x) => x.toJson())),
      };
}

class Favorite {
  int favoriteId;
  int userId;
  int productId;
  DateTime createdAt;
  dynamic updated;
  String productName;
  String productCategory;
  String productDescription;
  String productImage;
  int productPrice;
  String productStore;
  int qty;

  Favorite({
    required this.favoriteId,
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
    required this.qty,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favoriteId: json["favorite_id"],
        userId: json["user_id"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updated: json["updated"],
        productName: json["product_name"],
        productCategory: json["product_category"],
        productDescription: json["product_description"],
        productImage: json["product_image"],
        productPrice: json["product_price"],
        productStore: json["product_store"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "favorite_id": favoriteId,
        "user_id": userId,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated": updated,
        "product_name": productName,
        "product_category": productCategory,
        "product_description": productDescription,
        "product_image": productImage,
        "product_price": productPrice,
        "product_store": productStore,
        "qty": qty,
      };
}
