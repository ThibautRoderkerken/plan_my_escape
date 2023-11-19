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
