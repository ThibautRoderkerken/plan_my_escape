import 'package:plan_my_escape/models/weather_info.dart';

import 'activity.dart';
import 'member.dart';

class VacationPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final List<Member> members;
  final List<Activity> activities;
  final WeatherInfo weatherInfo;
  late final int vacationIndex;

  VacationPeriod({
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.members,
    required this.activities,
    required this.weatherInfo,
  });

  static VacationPeriod fromJson(Map<String, dynamic> json) {
    print(json);
    var membersList = (json['members'] as List)
        .map((memberJson) => Member.fromJson(memberJson))
        .toList();
    var activitiesList = (json['activities'] as List)
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();
    var weatherInfo = WeatherInfo.fromJson(json['weatherInfo']);

    return VacationPeriod(
      startDate: DateTime.parse(json['start_at']),
      endDate: DateTime.parse(json['end_at']),
      destination: json['destination'],
      members: membersList,
      activities: activitiesList,
      weatherInfo: weatherInfo,
    );
  }
}

