class WeatherInfo {
  final String description;
  final double temperature;

  WeatherInfo({required this.description, required this.temperature});

  static WeatherInfo fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      description: json['description'],
      temperature: json['temperature'].toDouble(),
    );
  }
}
