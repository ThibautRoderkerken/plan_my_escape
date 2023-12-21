import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_escape/exceptions/bad_request_exception.dart';
import 'package:plan_my_escape/exceptions/internal_server_exception.dart';
import 'package:plan_my_escape/exceptions/network_exception.dart';
import 'package:plan_my_escape/exceptions/not_found_exception.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/utils/global_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
          if (cookie != null) 'Cookie': cookie,
        },
        body: jsonEncode({
          'name': vacation.destination,
          'startAt': vacation.startDate.toIso8601String().split('T')[0],
          'endAt': vacation.endDate.toIso8601String().split('T')[0],
          'activities': [],
          'users': [],
          'address': vacation.address,
          'city': vacation.city,
          'country': {
            'id': GlobalData().countries.firstWhere((country) => country.name == vacation.country).code,
            'name': vacation.country,
          },

        }),
      ).timeout(const Duration(seconds: 20));

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
      ).timeout(const Duration(seconds: 20));

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
        Uri.parse('$baseUrl/${vacation.vacationIndex}'),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
        body: jsonEncode({
          'Id': vacation.vacationIndex,
          'Name': vacation.destination,
          'StartAt': vacation.startDate.toIso8601String().split('T')[0],
          'EndAt': vacation.endDate.toIso8601String().split('T')[0],
          'Address': vacation.address,
          'City': vacation.city,
          'Country': {
            'Id': GlobalData().countries.firstWhere((country) => country.name == vacation.country).code,
            'Name': vacation.country,
          },
          'Activities': vacation.activities.map((activity) => {
            'Name': activity.name,
            'Description': activity.description,
            'Destination': activity.address,
            'Start_at': _combineDateTimeAndTime(activity.scheduledDate ?? vacation.startDate, activity.scheduledTime),
            'End_at': _combineDateTimeAndTime(activity.scheduledDate ?? vacation.startDate, activity.scheduledTime, addDuration: activity.duration),
          }).toList(),
          'Users': vacation.members.map((member) => {
            'Email': member.mail,
            'Firstname': member.firstName ?? '',
            'Lastname': member.lastName ?? '',
          }).toList()
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return response.body.isEmpty ? null : json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request: ${response.body}');
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

  String _combineDateTimeAndTime(DateTime? date, TimeOfDay? time, {Duration? addDuration}) {
    final dateTime = DateTime(date?.year ?? 0, date?.month ?? 1, date?.day ?? 1, time?.hour ?? 0, time?.minute ?? 0);
    final combinedDateTime = addDuration != null ? dateTime.add(addDuration) : dateTime;
    return combinedDateTime.toIso8601String();
  }

  Future<VacationPeriod> getVacationPeriodDetails(int vacationId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');
      final response = await http.get(
        Uri.parse('$baseUrl/$vacationId'),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return VacationPeriod.fromJson(json.decode(response.body));
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request: ${response.body}');
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
      rethrow;
    }
  }

  Future deleteVacationPeriod(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request: ${response.body}');
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