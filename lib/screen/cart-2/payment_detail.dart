import 'package:ecommerce_app/screen/cart-2/screen_success.dart';
import 'package:flutter/material.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetail extends StatefulWidget {
  final String snapToken;
  final int orderId;

  const PaymentDetail(
      {Key? key, required this.snapToken, required this.orderId})
      : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  bool isLoading = false;
  String? id, username;
  int? orderid;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      // print('id $id');
    });
  }

  Future getOrder() async {
    setState(() {
      orderid = widget.orderId;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    getSession();
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MidtransSnap(
        mode: MidtransEnvironment.sandbox,
        token: widget.snapToken,
        midtransClientKey: 'SB-Mid-client-jLX4oWShl5K3rVva',
        onPageFinished: (url) {
          print(url);
        },
        onPageStarted: (url) {
          print(url);
        },
        onResponse: (result) {
          print(result.toJson());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SuccessPage(orderid)),
              (route) => false);
        },
      ),
    );
  }
}
