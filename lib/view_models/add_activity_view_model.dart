import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import '../../models/activity.dart';
import '../services/holiday_service.dart';
import 'dashboard/dashboard_view_model.dart';

class AddActivityViewModel extends ChangeNotifier {
  final int vacationIndex;
  final DashboardViewModel dashboardViewModel;
  final HolidayService _holidayService = HolidayService();

  AddActivityViewModel({required this.vacationIndex, required this.dashboardViewModel});

  Future<void> addActivity(String name, String address, String description) async {
    dashboardViewModel.addActivity(vacationIndex, name, address, description);
    await _updateVacationPeriod();
    notifyListeners(); // Notifier les écouteurs de ce ViewModel
  }

  Future<void> _updateVacationPeriod() async {
    try {
      VacationPeriod updatedVacationPeriod = dashboardViewModel.getVacationPeriodById(vacationIndex);
      await _holidayService.updateVacationPeriod(updatedVacationPeriod);
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }

  void removeActivity(int activityIndex) {
    dashboardViewModel.removeActivity(vacationIndex, activityIndex);
    notifyListeners();
  }

  List<Activity> get activities => dashboardViewModel.getVacationPeriodById(vacationIndex).activities;
}
