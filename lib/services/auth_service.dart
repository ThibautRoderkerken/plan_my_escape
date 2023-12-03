import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        await extractCookie(response);
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
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Future<void> extractCookie(http.Response response) async {
    // Extraire le cookie de la réponse
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      if (index != -1) {
        rawCookie = rawCookie.substring(0, index);
      }
      print('Cookie: $rawCookie'); // Afficher le cookie dans la console

      // Stocker le cookie sur l'appareil
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cookie', rawCookie);
    }
  }

  Future<dynamic> signUp(String email, String password, String firstName, String lastName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstname': firstName,
          'lastname': lastName,
          'isActive': true
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        await extractCookie(response);
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
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

  Future<void> signInWithGoogle() async {
    try {
      print("Tentative de connexion avec Google...");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Afficher dans la console le nom de l'utilisateur
      print("Utilisateur : ${googleUser?.displayName}");

      // Récupération du token d'authentification
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Afficher dans la console le token d'authentification
      print("Token : ${googleAuth?.accessToken}");

      if (googleAuth != null && googleAuth.accessToken != null) {
        // Envoyer le token à votre serveur
        final response = await http.post(
          Uri.parse('$baseUrl/api/Auth/google-login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'googleToken': googleAuth.accessToken}),
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200 || response.statusCode == 201) {
          await extractCookie(response);
          return json.decode(response.body);
        } else {
          switch (response.statusCode) {
            case 400:
              throw BadRequestException('Bad request');
            case 500:
              throw InternalServerException('Internal server error');
            default:
              throw NetworkException('Unknown network error');
          }
        }
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (error) {
      if (error is! Exception) {
        throw NetworkException('Network error: $error');
      }
      rethrow;
    }
  }
}
