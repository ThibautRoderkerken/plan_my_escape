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
      List<VacationPeriod> initialVacationPeriods = await _holidayService.getVacationPeriods();
      List<VacationPeriod> detailedVacationPeriods = [];
      for (var period in initialVacationPeriods) {
        detailedVacationPeriods.add(await _holidayService.getVacationPeriodDetails(period.vacationIndex));
      }
      _vacationPeriods = detailedVacationPeriods;
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
    // Ici c'est bien [vacationIndex] car c'est ca position dans la liste
    _vacationPeriods[vacationIndex].members.removeAt(memberIndex);
    _updateVacationPeriod(vacationIndex);
    notifyListeners();
  }

  Future<void> _updateVacationPeriod(int vacationIndex) async {
    try {
      VacationPeriod updatedVacationPeriod = _vacationPeriods[vacationIndex];
      await _holidayService.updateVacationPeriod(updatedVacationPeriod);
    } catch (e) {
      print('Erreur lors de la mise à jour de la période de vacances: $e');
    }
  }

  void addMember(int vacationIndex, String lastName, String mail, String firstName) {
    String newId = "m${getVacationPeriodById(vacationIndex).members.length + 1}";  // Générer un nouvel ID pour le membre
    getVacationPeriodById(vacationIndex).members.add(Member(id: newId, lastName: lastName, mail: mail, firstName: firstName));

    notifyListeners();
  }

  Activity addActivity(int vacationIndex, String name, String address, String description) {
    String newId = "a${getVacationPeriodById(vacationIndex).activities.length + 1}";
    Activity newActivity = Activity(id: newId, name: name, address: address, description: description);
    getVacationPeriodById(vacationIndex).activities.add(newActivity);
    notifyListeners();
    return newActivity;
  }

  void removeActivity(int vacationIndex, int activityIndex) {
    getVacationPeriodById(vacationIndex).activities.removeAt(activityIndex);
    notifyListeners();
  }

  List<Activity> getActivitiesForVacation(int vacationIndex) {
    if (vacationIndex >= 0) {
      return getVacationPeriodById(vacationIndex).activities;
    } else {
      return [];
    }
  }

  String exportToICalendar(int vacationIndex) {
    return exportToICalendarService(getActivitiesForVacation(vacationIndex));
  }

  void updateActivityDetails(Activity activity, DateTime selectedDate, TimeOfDay selectedTime, Duration duration, int vacationIndex) async {
    activity.scheduledDate = selectedDate;
    activity.scheduledTime = selectedTime;
    activity.duration = duration;

    try {
      VacationPeriod updatedVacationPeriod = getVacationPeriodById(vacationIndex);
      await _holidayService.updateVacationPeriod(updatedVacationPeriod);
    } catch (e) {
      print('Erreur lors de la mise à jour de la période de vacances: $e');
    }
    notifyListeners();
  }
}
