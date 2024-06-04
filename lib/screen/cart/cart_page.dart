// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart/model_delete_cart.dart';
import 'package:ecommerce_app/model/cart/model_snap.dart';
import 'package:ecommerce_app/model/product/model_get_cart.dart';
import 'package:ecommerce_app/screen/cart/cart_detail_page.dart';
import 'package:ecommerce_app/screen/product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  late List<Cart> _productList = [];
  List<int> _quantities = [];
  List<double> _itemTotalPrices = [];
  String? id, username;
  double _totalPrice = 0.0;
  int? _selectedProductId, _selectedCarttId;

  @override
  void initState() {
    super.initState();
    // getProduct();
    getSession().then((value) => getProduct());
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print('id user $id');
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _quantities[index]++;
      _itemTotalPrices[index] =
          _quantities[index] * _productList[index].productPrice.toDouble();
      _totalPrice = _calculateTotalPrice();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_quantities[index] > 1) {
        _quantities[index]--;
        _itemTotalPrices[index] =
            _quantities[index] * _productList[index].productPrice.toDouble();
        _totalPrice = _calculateTotalPrice();
      }
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (double itemTotal in _itemTotalPrices) {
      total += itemTotal;
    }
    return total;
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      print('id userr $id');
      final res = await http.get(Uri.parse('${url}get_cart.php?user_id=$id'));

      if (res.statusCode == 200) {
        ModelGetCart data = modelGetCartFromJson(res.body);
        setState(() {
          _productList =
              data.cart.where((item) => item.status != 'done').toList();
          _quantities =
              List.filled(_productList.length, 1); // Inisialisasi kuantitas
          _itemTotalPrices = List.generate(_productList.length,
              (index) => _productList[index].productPrice.toDouble());
          _totalPrice = _calculateTotalPrice();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed Load data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('data belum ada')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteCart(int idp) async {
    try {
      http.Response res = await http.post(Uri.parse('${url}delete_cart.php'),
          body: {"cart_id": idp.toString()});

      if (res.statusCode == 200) {
        ModelDeleteCart data = modelDeleteCartFromJson(res.body);

        if (data.status == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          setState(() {
            getProduct();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal menghapus data')),
      );
    }
  }

  void _showCheckoutDialog(
      double total, String username, String product_id, String cart_id) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _address = TextEditingController();
    Future<void> checkout() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        try {
          http.Response res = await http.post(
            Uri.parse('${url}payment_api.php'),
            body: {
              "name": username,
              "price":
                  total.toString(), // Ensure `total` is converted to `String`
              "id": product_id,
              "customer_address": "padang",
              "cart_id": cart_id
            },
          );

          if (res.statusCode == 200) {
            var response = jsonDecode(res.body);

            print(response);
            if (response.containsKey('snap_token')) {
              String snapToken = response['snap_token'];
              // Navigate to CartdetailPage with the snapToken and cart_id
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartdetailPage(snapToken, cart_id),
                ),
              );
            } else {
              // Handle error
              print('Error: ${response['message']}');
            }
          } else {
            print('Server error: ${res.statusCode}');
          }
        } catch (e) {
          print('Error: $e');
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Total Belanja ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'en_US', symbol: '\$')
                          .format(total),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF67729429),
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        checkout();
                      },
                      child: Text("Bayar",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0EBE7F), // Warna tombol continue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(295, 54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "My Cart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 500,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _productList.isEmpty
                          ? Center(child: Text("No products available"))
                          : ListView.separated(
                              itemCount: _productList.length,
                              itemBuilder: (context, index) {
                                Cart data = _productList[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedProductId = data.productId;
                                      _selectedCarttId = data.cartId;
                                    });
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailProductPage(data)));
                                  },
                                  child: Container(
                                    height: 110,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image.network(
                                          '${urlImg}${data.productImage}',
                                          width: 100,
                                          height: 100,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 222,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      data.productName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      data.cartId.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          print(data.cartId);
                                                          deleteCart(
                                                              data.cartId);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .delete_forever_rounded,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 222,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  _decrementQuantity(
                                                                      index),
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .white),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '${_quantities[index]}',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  _incrementQuantity(
                                                                      index),
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .black),
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 12,
                                                                )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(NumberFormat.currency(
                                                            locale: 'en_US',
                                                            symbol: '\$')
                                                        .format(
                                                            _itemTotalPrices[
                                                                index]))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 175,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pembelian",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'en_US', symbol: '\$')
                            .format(_totalPrice),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedProductId != null) {
                        _showCheckoutDialog(
                          _totalPrice,
                          username!,
                          _selectedProductId.toString(),
                          _selectedCarttId.toString(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a product')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.greenAccent),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Checkout',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
