import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/dashboard_view_model.dart';

class ActivityPool extends StatefulWidget {
  final DashboardViewModel viewModel;
  final int vacationIndex;
  final Function(BuildContext, Activity, Function(Activity)) onSelectDateTime;

  const ActivityPool({Key? key, required this.viewModel, required this.vacationIndex, required this.onSelectDateTime}) : super(key: key);

  @override
  ActivityPoolState createState() => ActivityPoolState();
}

class ActivityPoolState extends State<ActivityPool> {
  List<Activity> getSortedActivities() {
    List<Activity> activities = widget.viewModel.getActivitiesForVacation(widget.vacationIndex);

    List<Activity> activitiesWithoutDate = activities.where((a) => a.scheduledDate == null).toList();
    List<Activity> activitiesWithDate = activities.where((a) => a.scheduledDate != null).toList();
    activitiesWithDate.sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));

    return [...activitiesWithoutDate, ...activitiesWithDate];
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> sortedActivities = getSortedActivities();
    return SingleChildScrollView(
      child: Column(
        children: sortedActivities.map((activity) {
          return ListTile(
            title: Text(activity.name),
            leading: const Icon(Icons.event),
            onTap: () {
              widget.onSelectDateTime(context, activity, (updatedActivity) {
                setState(() {
                  widget.viewModel.updateActivity(updatedActivity);
                });
              });
            },
            trailing: activity.scheduledDate != null ? const Icon(Icons.check) : null,
          );
        }).toList(),
      ),
    );
  }
}
