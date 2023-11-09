import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});
}

class Activity {
  final String id;
  final String name;
  final String address;
  final String description;
  DateTime? scheduledDate;
  TimeOfDay? scheduledTime;
  Duration? duration;

  Activity({required this.id, required this.name, required this.address, required this.description, this.scheduledDate, this.scheduledTime, this.duration});
}

class WeatherInfo {
  final String description;
  final double temperature;

  // Vous pouvez ajouter d'autres détails si nécessaire, comme l'humidité, la vitesse du vent, etc.
  WeatherInfo({required this.description, required this.temperature});
}

class VacationPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final List<Member> members;
  final List<Activity> activities;
  final WeatherInfo weatherInfo;
  final int vacationIndex;

  VacationPeriod({
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.members,
    required this.activities,
    required this.weatherInfo,
    required this.vacationIndex,
  });
}

class DashboardViewModel extends ChangeNotifier {
  final List<VacationPeriod> _vacationPeriods = [
    VacationPeriod(
      // Ajouter un champs vacationIndex
      vacationIndex: 0,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      destination: 'Barcelone',
      members: [
        Member(id: 'm1', name: 'Alice Dupont'),
        Member(id: 'm2', name: 'Bob Martin'),
      ],
      activities: [
        Activity(id: 'a1', name: 'Visite du Parc Güell', address: "Carrer d'Olot, Barcelone, Espagne", description: 'Visite du parc et de la maison de Gaudi'),
        Activity(id: 'a2', name: 'Dîner à El Nacional', address: 'Passeig de Gràcia, Barcelone, Espagne', description: 'Dîner dans un restaurant typique'),
      ],
      weatherInfo: WeatherInfo(description: 'Ensoleillé', temperature: 26.5),
    ),
    VacationPeriod(
      vacationIndex: 1,
      startDate: DateTime.now().add(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      destination: 'Rome',
      members: [
        Member(id: 'm3', name: 'Caroline Lambert'),
        Member(id: 'm4', name: 'David Bernard'),
      ],
      activities: [
        Activity(id: 'a3', name: 'Visite du Colisée', address: 'Piazza del Colosseo, Rome, Italie', description: 'Visite du Colisée et du Forum Romain'),
        Activity(id: 'a4', name: 'Déjeuner à la Pergola', address: 'Via Alberto Cadlolo, Rome, Italie', description: 'Déjeuner dans un restaurant étoilé'),
      ],
      weatherInfo: WeatherInfo(description: 'Légèrement nuageux', temperature: 23.0),
    ),
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

  void addMember(int vacationIndex, String name, String text) {
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
}
