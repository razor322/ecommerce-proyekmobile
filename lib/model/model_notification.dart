// To parse this JSON data, do
//
//     final modelNotification = modelNotificationFromJson(jsonString);

import 'dart:convert';

ModelNotification modelNotificationFromJson(String str) => ModelNotification.fromJson(json.decode(str));

String modelNotificationToJson(ModelNotification data) => json.encode(data.toJson());

class ModelNotification {
  int value;
  String message;
  List<Notification> notifications;

  ModelNotification({
    required this.value,
    required this.message,
    required this.notifications,
  });

  factory ModelNotification.fromJson(Map<String, dynamic> json) => ModelNotification(
    value: json["value"],
    message: json["message"],
    notifications: List<Notification>.from(json["notifications"].map((x) => Notification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
  };
}

class Notification {
  String notificationId;
  String title;
  String description;
  String time;
  String isRead;
  DateTime createdAt;
  dynamic updated;

  Notification({
    required this.notificationId,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
    required this.createdAt,
    required this.updated,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    notificationId: json["notification_id"],
    title: json["title"],
    description: json["description"],
    time: json["time"],
    isRead: json["is_read"],
    createdAt: DateTime.parse(json["created_at"]),
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "title": title,
    "description": description,
    "time": time,
    "is_read": isRead,
    "created_at": createdAt.toIso8601String(),
    "updated": updated,
  };
}
