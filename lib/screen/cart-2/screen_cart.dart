// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart-2/model_cart.dart';
import 'package:ecommerce_app/screen/cart-2/screen_checkout.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool isLoading = false;
  String? id, username;
  final priceFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');

  @override
  void initState() {
    super.initState();
    getSession().then((value) => getCart());
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print('id user $id');
    });
  }

  late List<Datum> _allCart = [];
  late Map<String, int> _quantities = {};

  Future<List<Datum>?> getCart() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(
        Uri.parse('${url}getcart.php'),
        body: {
          "user_id": id,
        },
      );
      ModelCart data = modelCartFromJson(res.body);
      setState(() {
        _allCart = data.data;
        _quantities = {
          for (var item in _allCart) item.cartId: int.parse(item.qty),
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (int i = 0; i < _allCart.length; i++) {
      int price = int.tryParse(_allCart[i].productPrice) ?? 0;
      int quantity = _quantities[_allCart[i].cartId] ?? 1;
      totalPrice += price * quantity;
    }
    return totalPrice;
  }

  String baseUrl = '$url';
  Future<void> deleteData(String id) async {
    final url = Uri.parse('$baseUrl/deletecart.php');
    final Map<String, String> data = {'id': id};

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          print('Data deleted successfully!');
          getCart(); // Refresh cart after deletion
        } else {
          print('Failed to delete data: ${decodedResponse['message']}');
        }
      } else {
        print('Error deleting data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();
    return Scaffold(
      backgroundColor: Color(0xffFCEFE7),
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Color(0xff5B4E3B),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _allCart.length,
              itemBuilder: (context, index) {
                Datum data = _allCart[index];
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final idToDelete = data.cartId;
                            await deleteData(idToDelete);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                        Image.network(
                          "${urlImg}${data.productImage}",
                          width: 60,
                          height: 60,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(data.productDescription),
                              Text(
                                priceFormatter
                                    .format(double.parse(data.productPrice)),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IncrementDecrementFormField<int>(
                          initialValue: _quantities[data.cartId] ?? 1,
                          displayBuilder: (value, field) {
                            return Text(
                              value == null ? "0" : value.toString(),
                            );
                          },
                          onDecrement: (currentValue) {
                            int newValue =
                                (currentValue! > 1) ? currentValue - 1 : 1;
                            setState(() {
                              _quantities[data.cartId] = newValue;
                            });
                            return newValue;
                          },
                          onIncrement: (currentValue) {
                            int newValue = currentValue! + 1;
                            setState(() {
                              _quantities[data.cartId] = newValue;
                            });
                            return newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total payment'),
                    Text(
                      priceFormatter.format(totalPrice),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            CheckoutPage(totalPrice, _allCart),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff5B4E3B),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
