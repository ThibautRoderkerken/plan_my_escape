import 'package:flutter/material.dart';
import '../../models/vacation_period.dart';
import 'dashboard_view_model.dart';

class DisplayVacationsViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;

  DisplayVacationsViewModel({required this.dashboardViewModel});

  List<VacationPeriod> get vacationPeriods => dashboardViewModel.vacationPeriods;

  void removeMember(int vacationIndex, int memberIndex) {
    dashboardViewModel.removeMember(vacationIndex, memberIndex);
    notifyListeners();
  }

  void removeActivity(int vacationIndex, int activityIndex) {
    dashboardViewModel.removeActivity(vacationIndex, activityIndex);
    notifyListeners();
  }
}
