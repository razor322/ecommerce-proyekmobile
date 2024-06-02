// To parse this JSON data, do
//
//     final modelAddCart = modelAddCartFromJson(jsonString);

import 'dart:convert';

ModelAddCart modelAddCartFromJson(String str) => ModelAddCart.fromJson(json.decode(str));

String modelAddCartToJson(ModelAddCart data) => json.encode(data.toJson());

class ModelAddCart {
    int value;
    String message;

    ModelAddCart({
        required this.value,
        required this.message,
    });

    factory ModelAddCart.fromJson(Map<String, dynamic> json) => ModelAddCart(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
