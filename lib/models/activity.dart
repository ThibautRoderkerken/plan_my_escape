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
    return Activity(
      id: activityJson['id'],
      name: activityJson['name'],
      address: activityJson['address'],
      description: activityJson['description'],
      // Vous devrez convertir les chaînes en DateTime et TimeOfDay si nécessaire
      scheduledDate: activityJson['scheduledDate'] != null ? DateTime.parse(activityJson['scheduledDate']) : null,
      scheduledTime: activityJson['scheduledTime'] != null ? TimeOfDay(hour: int.parse(activityJson['scheduledTime'].split(":")[0]), minute: int.parse(activityJson['scheduledTime'].split(":")[1])) : null,
      duration: activityJson['duration'] != null ? Duration(minutes: int.parse(activityJson['duration'])) : null,
    );
  }
}
