import 'package:flutter/material.dart';
import '../../models/activity.dart';
import '../../models/member.dart';
import '../../models/vacation_period.dart';
import '../../models/weather_info.dart';
import '../../services/calendar_export.dart';

class DashboardViewModel extends ChangeNotifier {
  final List<VacationPeriod> _vacationPeriods = [
  ];

  List<VacationPeriod> get vacationPeriods => _vacationPeriods;

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
    _vacationPeriods[vacationIndex].members.removeAt(memberIndex);
    notifyListeners();
  }

  void addMember(int vacationIndex, String name, String mail) {
    String newId = "m${_vacationPeriods[vacationIndex].members.length + 1}";  // Générer un nouvel ID pour le membre
    _vacationPeriods[vacationIndex].members.add(Member(id: newId, name: name));
    notifyListeners();
  }

  void addActivity(int vacationIndex, String name, String address, String description) {
    String newId = "a${_vacationPeriods[vacationIndex].activities.length + 1}";
    _vacationPeriods[vacationIndex].activities.add(Activity(id: newId, name: name, address: address, description: description));
    notifyListeners();
  }

  void removeActivity(int vacationIndex, int activityIndex) {
    _vacationPeriods[vacationIndex].activities.removeAt(activityIndex);
    notifyListeners();
  }

  List<Activity> getActivitiesForVacation(int vacationIndex) {
    if (vacationIndex >= 0 && vacationIndex < _vacationPeriods.length) {
      return _vacationPeriods[vacationIndex].activities;
    } else {
      return [];
    }
  }

  String exportToICalendar(int vacationIndex) {
    return exportToICalendarService(getActivitiesForVacation(vacationIndex));
  }
}
