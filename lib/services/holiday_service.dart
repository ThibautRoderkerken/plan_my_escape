import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vacation_period.dart'; // Assurez-vous que ce modèle correspond à IHoliday
import '../exceptions/bad_request_exception.dart';
import '../exceptions/internal_server_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/not_found_exception.dart';

class HolidayService {
  final String baseUrl = "https://porthos-intra.cg.helmo.be/e180314/api/Holiday";

  Future<dynamic> addVacationPeriod(VacationPeriod vacation) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie, // Ajout du cookie dans les en-têtes
        },
        body: jsonEncode({
          'destination': vacation.destination,
          'start_at': vacation.startDate.toIso8601String().split('T')[0],
          'end_at': vacation.endDate.toIso8601String().split('T')[0],
          'activities': [],
          // Ajoutez d'autres champs si nécessaire
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
          case 404:
            throw NotFoundException('Resource not found');
          case 500:
            throw InternalServerException('Internal server error');
          default:
            throw NetworkException('Unknown network error');
        }
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Future<List<VacationPeriod>> getVacationPeriods() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        return List<VacationPeriod>.from(l.map((model) => VacationPeriod.fromJson(model)));
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
          case 404:
            throw NotFoundException('Resource not found');
          case 500:
            throw InternalServerException('Internal server error');
          default:
            throw NetworkException('Unknown network error');
        }
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> updateVacationPeriod(VacationPeriod vacation) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.put(
        Uri.parse('$baseUrl/${vacation.vacationIndex}'), // Utiliser l'ID de la période de vacances
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
        body: jsonEncode({
          'Id': vacation.vacationIndex,
          'Destination': vacation.destination,
          'Start_at': vacation.startDate.toIso8601String().split('T')[0],
          'End_at': vacation.endDate.toIso8601String().split('T')[0],
          'Activities': vacation.activities
              .map((activity) => {
            'Name': activity.name,
            'Description': activity.description,
            'Destination': activity.address, // Utiliser 'address' pour la destination de l'activité
            'Start_at': activity.scheduledDate?.toIso8601String().split('T')[0],
            'End_at': activity.scheduledDate?.add(activity.duration ?? const Duration(hours: 0)).toIso8601String().split('T')[0],
          })
              .toList(),
          'Users': []  // Ajoutez des informations sur les utilisateurs si nécessaire
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
          case 404:
            throw NotFoundException('Resource not found');
          case 500:
            throw InternalServerException('Internal server error');
          default:
            throw NetworkException('Unknown network error');
        }
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }
}
