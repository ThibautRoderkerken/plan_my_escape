import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/activity.dart';
import '../../view_models/calendar/activity_pool_view_model.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityPool extends StatelessWidget {
  final int vacationIndex;
  final Function(BuildContext, Activity, Function(Activity)) onSelectDateTime;

  const ActivityPool({Key? key, required this.vacationIndex, required this.onSelectDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => ActivityPoolViewModel(
          vacationIndex: vacationIndex,
          dashboardViewModel: dashboardViewModel,
      ),
      child: Consumer<ActivityPoolViewModel>(
        builder: (context, viewModel, child) {
          List<Activity> sortedActivities = viewModel.getSortedActivities();
          return SingleChildScrollView(
            child: Column(
              children: sortedActivities.map((activity) {
                return ListTile(
                  title: Text(activity.name),
                  leading: const Icon(Icons.event),
                  onTap: () {
                    onSelectDateTime(context, activity, (updatedActivity) {
                      viewModel.updateActivity(updatedActivity);
                    });
                  },
                  trailing: activity.scheduledDate != null ? const Icon(Icons.check) : null,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
