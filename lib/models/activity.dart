import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final String address;
  final String description;
  DateTime? scheduledDate;
  TimeOfDay? scheduledTime;
  Duration? duration;

  Activity({required this.id, required this.name, required this.address, required this.description, this.scheduledDate, this.scheduledTime, this.duration});
}