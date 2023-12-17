import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/models/weather_info.dart';

void main() {
  group('WeatherInfo Model Tests', () {
    // Test de Constructeur
    test('WeatherInfo Constructor Test', () {
      final weatherInfo = WeatherInfo(
        description: 'Ensoleillé',
        temperature: 25.0,
      );

      expect(weatherInfo.description, 'Ensoleillé');
      expect(weatherInfo.temperature, 25.0);
    });

    // Test de fromJson avec données complètes
    test('WeatherInfo FromJson Complete Data Test', () {
      final json = {
        'description': 'Nuageux',
        'temperature': 15.0,
      };

      final weatherInfo = WeatherInfo.fromJson(json);

      expect(weatherInfo.description, 'Nuageux');
      expect(weatherInfo.temperature, 15.0);
    });

    // Test de fromJson avec données manquantes ou incorrectes
    test('WeatherInfo FromJson Incomplete or Invalid Data Test', () {
      final json = {
        // description est manquante
        'temperature': 'non-numérique', // valeur incorrecte
      };

      final weatherInfo = WeatherInfo.fromJson(json);

      expect(weatherInfo.description, 'Ensoleillé'); // Valeur par défaut en cas d'absence de données
      expect(weatherInfo.temperature, 0.0); // Valeur par défaut en cas d'erreur
    });

  });
}
