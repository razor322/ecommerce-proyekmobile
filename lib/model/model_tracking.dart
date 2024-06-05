// To parse this JSON data, do
//
//     final modelTracking = modelTrackingFromJson(jsonString);

import 'dart:convert';

ModelTracking modelTrackingFromJson(String str) => ModelTracking.fromJson(json.decode(str));

String modelTrackingToJson(ModelTracking data) => json.encode(data.toJson());

class ModelTracking {
  int value;
  String message;
  List<Tracking> tracking;

  ModelTracking({
    required this.value,
    required this.message,
    required this.tracking,
  });

  factory ModelTracking.fromJson(Map<String, dynamic> json) => ModelTracking(
    value: json["value"],
    message: json["message"],
    tracking: List<Tracking>.from(json["tracking"].map((x) => Tracking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "tracking": List<dynamic>.from(tracking.map((x) => x.toJson())),
  };
}

class Tracking {
  String trackingId;
  String status;
  String description;
  DateTime createdAt;
  dynamic updated;

  Tracking({
    required this.trackingId,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.updated,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
    trackingId: json["tracking_id"],
    status: json["status"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "tracking_id": trackingId,
    "status": status,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated": updated,
  };
}
