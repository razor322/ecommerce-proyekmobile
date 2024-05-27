import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar(String message);

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
