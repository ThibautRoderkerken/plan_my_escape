import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/dashboard_view_model.dart';

class ActivityPool extends StatelessWidget {
  final List<Activity> activities;

  const ActivityPool({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(activities[index].name),
          leading: const Icon(Icons.event),
          trailing: const Icon(Icons.drag_handle),
        );
      },
    );
  }
}
