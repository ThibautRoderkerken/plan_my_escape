import 'package:flutter/material.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import 'package:plan_my_escape/services/meteo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/activity.dart';
import '../../models/member.dart';
import '../../models/vacation_period.dart';
import '../../services/calendar_export.dart';

class DashboardViewModel extends ChangeNotifier {
  final HolidayService _holidayService;
  final MeteoService _meteoService = MeteoService();
  late List<VacationPeriod> _vacationPeriods = [];
  bool _isLoading = true;
  final Future<String> userID = SharedPreferences.getInstance()
      .then((prefs) => prefs.getString('userID') ?? '');

  DashboardViewModel({HolidayService? holidayService})
      : _holidayService = holidayService ?? HolidayService() {
    _initializeVacationPeriods();
  }

  void _initializeVacationPeriods() async {
    try {
      _isLoading = true;
      List<VacationPeriod> initialVacationPeriods =
          await _holidayService.getVacationPeriods();
      List<VacationPeriod> detailedVacationPeriods = [];
      for (var period in initialVacationPeriods) {
        detailedVacationPeriods.add(await _holidayService
            .getVacationPeriodDetails(period.vacationIndex));
        // Pour la dernière période de vacance ajouter on mets a jours la météo
        detailedVacationPeriods.last.weatherInfo =
            await _meteoService.getMeteo(
                detailedVacationPeriods.last.city); // Mettre à jour la météo
      }
      _vacationPeriods = detailedVacationPeriods;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VacationPeriod> get vacationPeriods => _vacationPeriods;

  bool get isLoading => _isLoading;

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

  void removeVacationPeriod(int id) {
    try {
      _holidayService.deleteVacationPeriod(_vacationPeriods[id].vacationIndex);
      _vacationPeriods.remove(_vacationPeriods[id]);
      notifyListeners();
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
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
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }

  void addMember(
      int vacationIndex, String lastName, String mail, String firstName) {
    String newId =
        "m${getVacationPeriodById(vacationIndex).members.length + 1}"; // Générer un nouvel ID pour le membre
    getVacationPeriodById(vacationIndex).members.add(Member(
        id: newId, lastName: lastName, mail: mail, firstName: firstName));

    notifyListeners();
  }

  Activity addActivity(
      int vacationIndex, String name, String address, String description) {
    String newId =
        "a${getVacationPeriodById(vacationIndex).activities.length + 1}";
    Activity newActivity = Activity(
        id: newId, name: name, address: address, description: description);
    getVacationPeriodById(vacationIndex).activities.add(newActivity);
    notifyListeners();
    return newActivity;
  }

  void removeActivity(int vacationIndex, int activityIndex) {
    _vacationPeriods[vacationIndex].activities.removeAt(activityIndex);
    _updateVacationPeriod(vacationIndex);
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

  void updateActivityDetails(Activity activity, DateTime selectedDate,
      TimeOfDay selectedTime, Duration duration, int vacationIndex) async {
    activity.scheduledDate = selectedDate;
    activity.scheduledTime = selectedTime;
    activity.duration = duration;

    try {
      VacationPeriod updatedVacationPeriod =
          getVacationPeriodById(vacationIndex);
      await _holidayService.updateVacationPeriod(updatedVacationPeriod);
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
    notifyListeners();
  }

  void updateVacationPeriod(int index, BuildContext context) {
    // Récupérer les 3 informations de la période de vacances
    String destination = _vacationPeriods[index].destination;
    DateTime startDate = _vacationPeriods[index].startDate;
    DateTime endDate = _vacationPeriods[index].endDate;
    Navigator.pushNamed(context, '/dashboard/updateVacation', arguments: {
      'dashboardViewModel': this,
      'vacationIndex': index,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate
    });
  }

  List<VacationPeriod> getVacationPeriod() {
    return _vacationPeriods;
  }
}
