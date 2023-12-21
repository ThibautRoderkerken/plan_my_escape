import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plan_my_escape/models/weather_info.dart';

class MeteoService {
  final String baseUrl = 'https://weatherapi-com.p.rapidapi.com/forecast.json';
  final String key = '8082e96531mshfb1d1b639afaf58p1228d3jsn5d680dd0a2e0';
  final String host = 'weatherapi-com.p.rapidapi.com';

  // Methode pour récupérer la météo du jours d'une ville
  Future<WeatherInfo> getMeteo(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&days=1'),
      headers: {
        'X-RapidAPI-Key': key,
        'X-RapidAPI-Host': host,
      },
    );
    if (response.statusCode == 200) {
      WeatherInfo weatherInfo = WeatherInfo.fromJson(json.decode(response.body));
      return weatherInfo;
    } else {
      throw Exception('Erreur lors de la récupération de la météo');
    }
  }
}