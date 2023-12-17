class WeatherInfo {
  final String description;
  final double temperature;

  WeatherInfo({required this.description, required this.temperature});

  static WeatherInfo fromJson(Map<String, dynamic> json) {
    // Utilisation de valeurs par défaut en cas d'absence de données ou d'erreur
    String description = json['description'] ?? 'Ensoleillé';
    double temperature;
    try {
      temperature = json['temperature'].toDouble();
    } catch (e) {
      // Valeur par défaut en cas d'erreur
      temperature = 0.0;
    }

    return WeatherInfo(
      description: description,
      temperature: temperature,
    );
  }
}
