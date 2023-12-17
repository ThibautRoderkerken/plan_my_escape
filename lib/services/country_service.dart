import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plan_my_escape/models/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryService {
  final String baseUrl = "https://porthos-intra.cg.helmo.be/e180314/api/Country";

  Future<List<Country>> getCountries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCountries = prefs.getString('countries');


    if (savedCountries != null && savedCountries != '[]') {
      Iterable l = json.decode(savedCountries);
      return List<Country>.from(l.map((model) => Country.fromJson(model)));
    } else {
      try {
        String? cookie = prefs.getString('cookie');
        final response = await http.get(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
            if (cookie != null) 'Cookie': cookie,
          },
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          prefs.setString('countries', response.body);
          Iterable l = json.decode(response.body);
          return List<Country>.from(l.map((model) => Country.fromJson(model)));
        } else {
          throw Exception('Failed to load countries');
        }
      } on TimeoutException {
        throw Exception('Network timeout');
      } catch (e) {
        throw Exception('Network error: $e');
      }
    }
  }
}