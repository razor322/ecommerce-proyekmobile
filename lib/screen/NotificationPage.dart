import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/model_notification.dart' as my_notification;
import 'package:ecommerce_app/model/model_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<my_notification.Notification> _notifications = []; // Using the alias
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotificationData();
  }

  Future<void> _fetchNotificationData() async {
    final response = await http.get(Uri.parse('${url}get_notification.php'));

    if (response.statusCode == 200) {
      final data = modelNotificationFromJson(response.body);
      setState(() {
        _notifications = data.notifications;
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  "Notification",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Card(
                          elevation: 3, // Adjust elevation as needed
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text(notification.title),
                            subtitle: Text(notification.description),
                            trailing: Text(notification.time),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
