import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/models/member.dart';
import 'package:plan_my_escape/models/activity.dart';
import 'package:plan_my_escape/models/weather_info.dart';

void main() {
  group('VacationPeriod Model Tests', () {
    // Test de Constructeur
    test('VacationPeriod Constructor Test', () {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 7));
      final members = [Member(id: '1', firstName: 'Alice', lastName: 'Dupont', mail: 'alice@example.com')];
      final activities = [Activity(id: '2', name: 'Plage', address: 'Côte', description: 'Relaxation au soleil')];
      final weatherInfo = WeatherInfo(description: 'Ensoleillé', temperature: 25.0);

      final vacation = VacationPeriod(
        startDate: startDate,
        endDate: endDate,
        destination: 'Ibiza',
        members: members,
        activities: activities,
        weatherInfo: weatherInfo,
        country: 'France',
        address: '1 rue de la plage',
      );

      expect(vacation.startDate, startDate);
      expect(vacation.endDate, endDate);
      expect(vacation.destination, 'Ibiza');
      expect(vacation.members, members);
      expect(vacation.activities, activities);
      expect(vacation.weatherInfo, weatherInfo);
    });

    // Test de fromJson
    test('VacationPeriod FromJson Test', () {
      final json = {
        'id': 123,
        'startAt': '2023-01-01',
        'endAt': '2023-01-08',
        'destination': 'Paris',
        'users': [
          {'id': '1', 'firstname': 'Bob', 'lastname': 'Martin', 'email': 'bob@example.com'},
        ],
        'activities': [
          {'id': '2', 'name': 'Musée', 'destination': 'Louvre', 'description': 'Visite culturelle'},
        ],
        'weatherInfo': {'description': 'Nuageux', 'temperature': 15.0},
      };

      final vacation = VacationPeriod.fromJson(json);

      expect(vacation.vacationIndex, 123);
      expect(vacation.startDate, DateTime(2023, 1, 1));
      expect(vacation.endDate, DateTime(2023, 1, 8));
      expect(vacation.destination, 'Paris');
      expect(vacation.members.length, 1);
      expect(vacation.activities.length, 1);
      expect(vacation.weatherInfo.description, 'Nuageux');
      expect(vacation.weatherInfo.temperature, 15.0);
    });

    // Test de toString
    test('VacationPeriod toString Test', () {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 7));
      final members = [Member(id: '1', firstName: 'Alice', lastName: 'Dupont', mail: 'alice@example.com')];
      final activities = [Activity(id: '2', name: 'Plage', address: 'Côte', description: 'Relaxation au soleil')];
      final weatherInfo = WeatherInfo(description: 'Ensoleillé', temperature: 25.0);

      final vacation = VacationPeriod(
        startDate: startDate,
        endDate: endDate,
        destination: 'Ibiza',
        members: members,
        activities: activities,
        weatherInfo: weatherInfo,
        country: 'France',
        address: '1 rue de la plage',
      );

      // Initialisation manuelle de vacationIndex car il est late
      vacation.vacationIndex = 0;

      final expectedString = 'VacationPeriod{startDate: $startDate, endDate: $endDate, destination: Ibiza, members: $members, activities: $activities, weatherInfo: $weatherInfo, vacationIndex: 0}';

      expect(vacation.toString(), expectedString);
    });

    // Test pour le cas où weatherInfo est absent dans le JSON
    test('VacationPeriod FromJson with Default WeatherInfo Test', () {
      final json = {
        'id': 123,
        'startAt': '2023-01-01',
        'endAt': '2023-01-08',
        'destination': 'Paris',
        'users': [],
        'activities': [],
        // 'weatherInfo' est volontairement omis
      };

      final vacation = VacationPeriod.fromJson(json);

      expect(vacation.weatherInfo.description, 'Inconnu');
      expect(vacation.weatherInfo.temperature, 0.0);
    });

    // Test pour les valeurs par défaut de startDate et endDate
    test('VacationPeriod FromJson with Default Dates Test', () {
      final json = {
        'id': 123,
        'destination': 'Paris',
        'users': [],
        'activities': [],
        'weatherInfo': {'description': 'Nuageux', 'temperature': 15.0},
        // 'start_at' et 'end_at' sont volontairement omis
      };

      final vacation = VacationPeriod.fromJson(json);
      final now = DateTime.now();

      // Comparaison approximative car now sera légèrement différent
      expect(vacation.startDate.difference(now).inSeconds, lessThan(5));
      expect(vacation.endDate.difference(now.add(const Duration(days: 1))).inSeconds, lessThan(5));
    });
  });
}
