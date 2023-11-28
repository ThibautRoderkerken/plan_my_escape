import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final String address;
  final String description;
  DateTime? scheduledDate;
  TimeOfDay? scheduledTime;
  Duration? duration;

  Activity({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    this.scheduledDate,
    this.scheduledTime,
    this.duration,
  });

  static Activity fromJson(Map<String, dynamic> activityJson) {
    DateTime? startDate;
    Duration? duration;

    if (activityJson['start_at'] != null) {
      startDate = DateTime.parse(activityJson['start_at']);
    }

    if (activityJson['end_at'] != null && startDate != null) {
      DateTime endDate = DateTime.parse(activityJson['end_at']);
      duration = endDate.difference(startDate);
    }

    return Activity(
      id: activityJson['id'].toString(),
      name: activityJson['name'],
      address: activityJson['destination'],
      description: activityJson['description'],
      scheduledDate: startDate,
      scheduledTime: startDate != null ? TimeOfDay(hour: startDate.hour, minute: startDate.minute) : null,
      duration: duration,
    );
  }
}
