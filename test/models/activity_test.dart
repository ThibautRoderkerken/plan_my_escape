import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/activity.dart';

void main() {
  group('Activity Model Tests', () {
    // Test de Constructeur
    test('Activity Constructor Test', () {
      final activity = Activity(
        id: '1',
        name: 'Football',
        address: 'Stade local',
        description: 'Match amical',
      );

      expect(activity.id, '1');
      expect(activity.name, 'Football');
      expect(activity.address, 'Stade local');
      expect(activity.description, 'Match amical');
      expect(activity.scheduledDate, isNull);
      expect(activity.scheduledTime, isNull);
      expect(activity.duration, isNull);
    });

    // Test de fromJson
    test('Activity FromJson Test', () {
      final json = {
        'id': '2',
        'name': 'Cinéma',
        'destination': 'Cinema City',
        'description': 'Film du soir',
        'startAt': '2023-01-01T20:00:00',
        'endAt': '2023-01-01T22:00:00'
      };

      final activity = Activity.fromJson(json);

      expect(activity.id, '2');
      expect(activity.name, 'Cinéma');
      expect(activity.address, 'Cinema City');
      expect(activity.description, 'Film du soir');
      expect(activity.scheduledDate, DateTime(2023, 1, 1, 20));
      expect(activity.scheduledTime, const TimeOfDay(hour: 20, minute: 0));
      expect(activity.duration, const Duration(hours: 2));
    });
  });
}
