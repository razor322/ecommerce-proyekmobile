import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print("Plugin notifikasi diinisialisasi");

    // Create a notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ECOMMERCE', // id
      'E-commerce Notifications', // title
      description:
          'This channel is used for e-commerce app notifications.', // description
      importance: Importance.max,
    );

    // Register the channel with the plugin
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print("Channel notifikasi dibuat: ${channel.id}");
    } else {
      print(
          "Gagal mendapatkan implementasi AndroidFlutterLocalNotificationsPlugin");
    }
  }

  static Future<void> showBigTextNotification(
      {int id = 0,
      required String title,
      required String body,
      String? payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    print("Menampilkan notifikasi dengan judul: $title dan isi: $body");

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'ECOMMERCE',
      'E-commerce Notifications',
      channelDescription:
          'This channel is used for e-commerce app notifications.',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(id, title, body, platformChannelSpecifics, payload: payload);
  }
}
