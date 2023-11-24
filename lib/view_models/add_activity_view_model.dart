import 'package:flutter/material.dart';
import '../../models/activity.dart';
import 'dashboard/dashboard_view_model.dart';

class AddActivityViewModel extends ChangeNotifier {
  final int vacationIndex;
  final DashboardViewModel dashboardViewModel;

  AddActivityViewModel({required this.vacationIndex, required this.dashboardViewModel});

  void addActivity(String name, String address, String description) {
    dashboardViewModel.addActivity(vacationIndex, name, address, description);
    notifyListeners(); // Notifier les écouteurs de ce ViewModel
  }

  void removeActivity(int activityIndex) {
    dashboardViewModel.removeActivity(vacationIndex, activityIndex);
    notifyListeners();
  }

  List<Activity> get activities => dashboardViewModel.vacationPeriods[vacationIndex].activities;
}
