import 'package:plan_my_escape/models/weather_info.dart';

import 'activity.dart';
import 'member.dart';

class VacationPeriod {
  DateTime startDate;
  DateTime endDate;
  String destination;
  final List<Member> members;
  final List<Activity> activities;
  final WeatherInfo weatherInfo;
  late final int vacationIndex;
  final String country;
  final String address;
  final String city;

  VacationPeriod({
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.members,
    required this.activities,
    required this.weatherInfo,
    required this.country,
    required this.address,
    required this.city,
  });

  static VacationPeriod fromJson(Map<String, dynamic> json) {
    List<Member> membersList = [];
    if (json['users'] != null) {
      membersList = (json['users'] as List)
          .map((memberJson) =>
              Member.fromJson(memberJson as Map<String, dynamic>))
          .toList();
    }
    List<Activity> activitiesList = [];
    if (json['activities'] != null) {
      activitiesList = (json['activities'] as List)
          .map((activityJson) =>
              Activity.fromJson(activityJson as Map<String, dynamic>))
          .toList();
    }

    WeatherInfo weatherInfo;
    if (json['weatherInfo'] != null) {
      weatherInfo =
          WeatherInfo.fromJson(json['weatherInfo'] as Map<String, dynamic>);
    } else {
      weatherInfo = WeatherInfo(description: 'Inconnu', temperature: 0.0);
    }

    DateTime? parsedStartDate;
    if (json['startAt'] != null) {
      parsedStartDate = DateTime.parse(json['startAt'] as String);
    }

    DateTime? parsedEndDate;
    if (json['endAt'] != null) {
      parsedEndDate = DateTime.parse(json['endAt'] as String);
    }

    // Récupérer l'ID de la période de vacances
    int? vacationIndex = json['id'] as int?;

    return VacationPeriod(
      startDate: parsedStartDate ?? DateTime.now(),
      endDate: parsedEndDate ?? DateTime.now().add(const Duration(days: 1)),
      destination: json['name'] as String? ?? 'Inconnu',
      members: membersList,
      activities: activitiesList,
      weatherInfo: weatherInfo,
      country: json['country'] as String? ?? 'Belgium',
      address: json['address'] as String? ?? 'Inconnu',
      city: json['city'] as String? ?? 'Paris',
    )..vacationIndex = vacationIndex ?? 0;
  }

  // Méthode pour afficher toute les données dans la console (uniquement pour le débogage)
  @override
  String toString() {
    return 'VacationPeriod{startDate: $startDate, endDate: $endDate, destination: $destination, members: $members, activities: $activities, weatherInfo: $weatherInfo, vacationIndex: $vacationIndex}';
  }
}
