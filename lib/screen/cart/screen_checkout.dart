// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart/model_checkout.dart';
import 'package:ecommerce_app/model/product/model_get_cart.dart';
import 'package:ecommerce_app/screen/cart/cart_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  // final Datum? data;
  final int total;
  final List<Cart> items;
  const CheckoutPage(this.total, this.items, {Key? key}) : super(key: key);
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  String? id, username, address;
  String? snap;
  final priceFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      address = pref.getString("address") ?? '';
      // print(json.encode(widget.items.map((item) => item.toJson()).toList()));
      // print(id);
      // print(widget.total.toString());
      // print(address);
    });
  }

  Future<ModelCheckout?> placeOrder() async {
    try {
      // setState(() {
      //   isLoading = true;
      // });
      var jsonData = jsonEncode({
        'user_id': id,
        'items': widget.items.map((item) {
          return {
            'id': item.productId,
            'product_name': item.productName,
            'product_price': item.productPrice,
          };
        }).toList(),
        'customer_address': address,
        'total_price': widget.total.toString(),
      });

      http.Response response = await http.post(
        Uri.parse('${url}api.php'),
        headers: {
          'Content-Type': 'application/json', // Set header Content-Type
        },
        body: jsonData,
      );
      ModelCheckout data = modelCheckoutFromJson(response.body);
      print(response.body);
      if (data.snapToken.isNotEmpty) {
        final responseData = json.decode(response.body);
        if (responseData['snap_token'] != null &&
            responseData['user_id'] != null) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => CartdetailPage(
          //               data.snapToken,
          //               data.orderId,
          //             )));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(responseData['snap_token'])));
        } else {
          // Jika respons tidak lengkap, tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to place order. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Failed to place order');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCEFE7),
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Color(0xff5B4E3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat Pengiriman',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '$username | (+62) 89999999999\n$address, Indonesia\n2500',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'product ordered',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return ProductItem(
                    imageUrl: '${urlImg}${widget.items[index].productImage}',
                    title: widget.items[index].productName,
                    subtitle: (widget.items[index].productDescription),
                    price: priceFormatter.format(double.parse(
                        widget.items[index].productPrice.toString())),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payment method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Select Payment Method'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff5B4E3B),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'payment details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal For Products',
                ),
                Text(priceFormatter.format(widget.total)),
              ],
            ),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total payment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  priceFormatter.format(widget.total),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: placeOrder,
                child: Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff5B4E3B),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  // final String quantity;

  ProductItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    // required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(subtitle),
                  Text(price),
                ],
              ),
            ),
            // Text(quantity),
          ],
        ),
      ),
    );
  }
}
