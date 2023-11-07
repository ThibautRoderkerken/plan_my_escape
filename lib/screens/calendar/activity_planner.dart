import 'package:flutter/material.dart';
import 'activity_pool.dart';
import 'activity_calendar.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityPlanner extends StatelessWidget {
  final int vacationIndex;  // Index de la période de vacances sélectionnée

  const ActivityPlanner({Key? key, required this.vacationIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final activities = dashboardViewModel.getActivitiesForVacation(vacationIndex);
    final VacationPeriod vacation = dashboardViewModel.vacationPeriods[vacationIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Planificateur d'Activités"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ActivityPool(activities: activities),
          ),
          Expanded(
            child: ActivityCalendar(
              firstDay: vacation.startDate,
              lastDay: vacation.endDate,
            ),
          ),
        ],
      ),
    );
  }
}
