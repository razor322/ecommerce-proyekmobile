import 'package:ecommerce_app/components/bottom_navigation.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart/model_payment.dart';
import 'package:ecommerce_app/noti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CartdetailPage extends StatefulWidget {
  final String token;
  final String cart_id;
  const CartdetailPage(this.token, this.cart_id, {super.key});

  @override
  State<CartdetailPage> createState() => _CartdetailPageState();
}

class _CartdetailPageState extends State<CartdetailPage> {
  String? snap_token, cart_idp, iduser;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getSession();
    snap_token = widget.token;
    cart_idp = widget.cart_id;
    print(cart_idp);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      iduser = pref.getString("id") ?? '';

      print('id $iduser');
      ;
    });
  }

  Future<ModelPayments?> updateStatusCart(String idp) async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('${url}edit_cart.php'), body: {
        "user_id": idp,
      });
      ModelPayments data = modelPaymentsFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        updateStatusPayment(widget.cart_id);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BotNav()),
            (route) => false);
      } else if (data.value == 0) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<ModelPayments?> updateStatusPayment(String idpay) async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('${url}edit_payment.php'), body: {
        "cart_id": idpay,
      });
      ModelPayments data = modelPaymentsFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BotNav()),
            (route) => false);
      } else if (data.value == 0) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MidtransSnap(
        mode: MidtransEnvironment.sandbox,
        token: snap_token!,
        midtransClientKey: 'SB-Mid-client-DDX8WrbpQ0HRhBPH',
        onPageFinished: (url) {
          print(' onPageFinished $url');
        },
        onPageStarted: (url) {
          print(' onPageStarted $url');
        },
        onResponse: (result) {
          print(' onResponse ${result.toJson()}');
          if (result.transactionStatus == 'settlement' ||
              result.transactionStatus == 'capture') {
            // Pembayaran berhasil

            updateStatusCart(iduser!);
            Noti.showBigTextNotification(
                title: "Checkout Berhasil",
                body: "terimakasih telah berbelanja",
                fln: flutterLocalNotificationsPlugin);
            // updateStatusPayment(cart_idp.toString());
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => BotNav()),
            //   (route) => false,
            // );
          } else if (result.transactionStatus == 'pending') {
            // Pembayaran tertunda
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pembayaran tertunda')),
            );
          } else {
            // Pembayaran gagal atau dibatalkan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pembayaran gagal atau dibatalkan')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BotNav()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
