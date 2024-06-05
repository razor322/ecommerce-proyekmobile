import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/user/model_get_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Datum> _allData = [];
  bool isLoading = false;
  String? id;

  @override
  void initState() {
    super.initState();
    getSession().then((_) => getData());
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      print('SharedPreferences ID: $id');
    });
  }

  Future<void> getData() async {
    if (id == null || id!.isEmpty) {
      print('User ID is null or empty');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse('${url}get_payments.php'),
        body: {'user_id': id},
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        ModelHistory data = modelHistoryFromJson(response.body);
        if (data.isSuccess) {
          setState(() {
            _allData = data.data;
          });
        } else {
          print('Error: ${data.message}');
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                SizedBox(
                  width: 120,
                ),
                Text(
                  "History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _allData.length,
                    itemBuilder: (context, index) {
                      Datum data = _allData[index];
                      double amount = 0;
                      try {
                        amount = double.parse(data.amount);
                      } catch (e) {
                        print('Error parsing amount: $e');
                      }
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order ID: ${data.orderId}'),
                            Container(
                                decoration: BoxDecoration(
                                    color: data.status == 'success'
                                        ? Colors.green
                                        : Colors.amber,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    ' ${data.status}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NumberFormat.currency(
                                        locale: 'en_US', symbol: '\$')
                                    .format(amount),
                              ),
                              Text(DateFormat('dd MMMM yyyy')
                                  .format(data.createdAt)),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
