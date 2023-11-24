import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../exceptions/authentication_exception.dart';
import '../exceptions/bad_request_exception.dart';
import '../exceptions/internal_server_exception.dart';
import '../exceptions/invalid_credentials_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/not_found_exception.dart';

class AuthService {
  final String baseUrl = "https://porthos-intra.cg.helmo.be/e180314";

  Future<dynamic> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 3));


      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
          case 401:
            throw InvalidCredentialsException('Authentication failed');
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
        // Si l'erreur n'est pas une de nos exceptions personnalisées
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }
}