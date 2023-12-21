import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/member.dart';
import '../models/vacation_period.dart';
import '../services/holiday_service.dart';
import 'dashboard/dashboard_view_model.dart';

class AddParticipantViewModel extends ChangeNotifier {
  final int vacationIndex;
  final DashboardViewModel dashboardViewModel;
  final HolidayService _holidayService = HolidayService();

  AddParticipantViewModel({required this.vacationIndex, required this.dashboardViewModel});

  void addParticipant(String lastName, String email, String firstName) {
    dashboardViewModel.addMember(vacationIndex, lastName, email, firstName);
    _updateVacationPeriod();
    notifyListeners();
  }

  Future<void> _updateVacationPeriod() async {
    try {
      VacationPeriod updatedVacationPeriod = dashboardViewModel.getVacationPeriodById(vacationIndex);
      await _holidayService.updateVacationPeriod(updatedVacationPeriod);
    } catch (e) {
      // Si la mise à jour échoue, la vue ne sera pas mise à jour
    }
  }

  void removeParticipant(int index) {
    dashboardViewModel.removeMember(vacationIndex, index);
    _updateVacationPeriod();
    notifyListeners();
  }

  List<Member> get participants => dashboardViewModel.getVacationPeriodById(vacationIndex).members;
}
