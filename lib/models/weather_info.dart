class WeatherInfo {
  final String description;
  final double temperature;

  WeatherInfo({required this.description, required this.temperature});

  static WeatherInfo fromJson(Map<String, dynamic> json) {
    // La description se trouve dans "current"/"condution"/"text"
    String description = json['current']['condition']['text'] ?? 'Ensoleillé';
    double temperature;
    try {
      // La température se trouve dans "current"/"temp_c"
      temperature = json['current']['temp_c'] ?? 0.0;
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
