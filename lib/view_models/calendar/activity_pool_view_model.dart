import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';
import '../../models/activity.dart';

class ActivityPoolViewModel extends ChangeNotifier {
  final int vacationIndex;
  late List<Activity> activities; // Utilisation de 'late' pour déclarer une initialisation différée

  final DashboardViewModel dashboardViewModel;

  ActivityPoolViewModel({required this.vacationIndex, required this.dashboardViewModel}) {
    activities = dashboardViewModel.getActivitiesForVacation(vacationIndex); // Initialisation des activités
  }

  List<Activity> getSortedActivities() {
    List<Activity> activitiesWithoutDate = activities.where((a) => a.scheduledDate == null).toList();
    List<Activity> activitiesWithDate = activities.where((a) => a.scheduledDate != null).toList();
    activitiesWithDate.sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));

    return [...activitiesWithoutDate, ...activitiesWithDate];
  }

  void updateActivity(Activity updatedActivity) {
    int index = activities.indexWhere((a) => a.id == updatedActivity.id);
    if (index != -1) {
      activities[index] = updatedActivity;
      notifyListeners(); // Notifier les widgets à l'écoute de ce ViewModel
    }
  }
}
