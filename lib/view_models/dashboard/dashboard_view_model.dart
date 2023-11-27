import 'package:flutter/material.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import '../../models/activity.dart';
import '../../models/member.dart';
import '../../models/vacation_period.dart';
import '../../services/calendar_export.dart';

class DashboardViewModel extends ChangeNotifier {
  final HolidayService _holidayService = HolidayService();
  late List<VacationPeriod> _vacationPeriods = [];

  DashboardViewModel() {
    _initializeVacationPeriods();
  }

  void _initializeVacationPeriods() async {
    try {
      _vacationPeriods = await _holidayService.getVacationPeriods();
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des périodes de vacances: $e');
    }
  }

  List<VacationPeriod> get vacationPeriods => _vacationPeriods;
  
  // Getter pour récupéréer une période de vacance sur base de son id
  VacationPeriod getVacationPeriodById(int id) {
    return _vacationPeriods.firstWhere((period) => period.vacationIndex == id);
  }

  void updateActivity(Activity updatedActivity) {
    for (var period in _vacationPeriods) {
      for (var i = 0; i < period.activities.length; i++) {
        if (period.activities[i].id == updatedActivity.id) {
          period.activities[i].duration = updatedActivity.duration;
          period.activities[i].scheduledDate = updatedActivity.scheduledDate;
          period.activities[i].scheduledTime = updatedActivity.scheduledTime;
          notifyListeners();
          break;
        }
      }
    }
  }

  void addVacationPeriod(VacationPeriod period) {
    _vacationPeriods.add(period);
    notifyListeners();
  }

  void removeVacationPeriod(String id) {
    _vacationPeriods.removeWhere((period) => period.destination == id);
    notifyListeners();
  }

  void removeMember(int vacationIndex, int memberIndex) {
    getVacationPeriodById(vacationIndex).members.removeAt(memberIndex);
    notifyListeners();
  }

  void addMember(int vacationIndex, String name, String mail) {
    String newId = "m${getVacationPeriodById(vacationIndex).members.length + 1}";  // Générer un nouvel ID pour le membre
    getVacationPeriodById(vacationIndex).members.add(Member(id: newId, name: name));
    notifyListeners();
  }

  void addActivity(int vacationIndex, String name, String address, String description) {
    String newId = "a${getVacationPeriodById(vacationIndex).activities.length + 1}";
    getVacationPeriodById(vacationIndex).activities.add(Activity(id: newId, name: name, address: address, description: description));
    notifyListeners();
  }

  void removeActivity(int vacationIndex, int activityIndex) {
    getVacationPeriodById(vacationIndex).activities.removeAt(activityIndex);
    notifyListeners();
  }

  List<Activity> getActivitiesForVacation(int vacationIndex) {
    if (vacationIndex >= 0 && vacationIndex < _vacationPeriods.length) {
      return getVacationPeriodById(vacationIndex).activities;
    } else {
      return [];
    }
  }

  String exportToICalendar(int vacationIndex) {
    return exportToICalendarService(getActivitiesForVacation(vacationIndex));
  }
}
