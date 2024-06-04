// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart-2/model_cart.dart';
import 'package:ecommerce_app/model/cart-2/model_checkout.dart';
import 'package:ecommerce_app/screen/cart-2/payment_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final int total;
  final List<Datum> items;
  const CheckoutPage(this.total, this.items, {Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  String? id, username, address;
  final priceFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      address = pref.getString("address") ?? '';
    });
  }

  Future<void> placeOrder() async {
    setState(() {
      isLoading = true;
    });
    print("userr, ${id}");

    if (id == null) {
      // Handle the case where id is null (e.g., show an error message)
      showErrorDialog('You are not logged in. Please login to place an order.');
      return;
    }
    var jsonData = jsonEncode({
      'user_id': id ?? '', // Use an empty string if id is null
      'items': widget.items.map((item) {
        return {
          'product_id': item.cartId,
          'product_name': item.productName,
          'product_price': item.productPrice,
          'qty': item.qty,
        };
      }).toList(),
      'customer_address': 'padang',
      'total_price': widget.total.toString(),
    });

    try {
      http.Response response = await http.post(
        Uri.parse('${url}api.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );
      print(jsonData);

      if (response.statusCode == 200) {
        ModelCheckout data = modelCheckoutFromJson(response.body);
        if (data.snapToken.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetail(
                snapToken: data.snapToken,
                orderId: data.orderId,
              ),
            ),
          );
        } else {
          showErrorDialog('Failed to place order. 1.');
        }
      } else {
        showErrorDialog('Failed to place order. Please try again later 2.');
      }
    } catch (e) {
      print(e.toString());
      showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
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
              'Products Ordered',
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
                    subtitle: widget.items[index].productDescription,
                    price: priceFormatter
                        .format(double.parse(widget.items[index].productPrice)),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
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
              'Payment Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal For Products'),
                Text(priceFormatter.format(widget.total)),
              ],
            ),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payment',
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
                onPressed: () {
                  placeOrder();
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Place Order'),
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

  ProductItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
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
          ],
        ),
      ),
    );
  }
}
