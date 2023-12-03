import 'package:flutter/material.dart';
import 'package:plan_my_escape/exceptions/internal_server_exception.dart';
import 'package:plan_my_escape/exceptions/network_exception.dart';
import 'package:plan_my_escape/exceptions/not_found_exception.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import 'package:plan_my_escape/view_models/sign_up_view_model.dart';
import 'package:provider/provider.dart';

import '../exceptions/invalid_credentials_exception.dart';
import '../screens/sign_up_screen.dart';
import '../services/auth_service.dart';
import '../exceptions/bad_request_exception.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool isLoginSuccess = false;
  final AuthService _authService = AuthService();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (!value.contains('@')) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  Future<void> validateAndLogin(Function onLoginSuccess, String email, String password) async {
    if (formKey.currentState!.validate()) {
      // Gestion des erreurs, on récupère chaque erreur et on mets un message d'erreur personnalisé.
      try {
        await _authService.login(email, password);
        onLoginSuccess();
      } on BadRequestException catch (_) {
        errorMessage = "Requête invalide";
      } on InvalidCredentialsException  catch (_) {
        errorMessage = "Login ou mot de passe incorrect";
      } on NotFoundException catch (_) {
        errorMessage = "Ressource non trouvée";
      } on InternalServerException catch (_) {
        errorMessage = "Erreur interne du serveur";
      } on NetworkException catch (_) {
        errorMessage = "Erreur réseau";
      } catch (e) {
        errorMessage = "Erreur inconnue";
      }
      notifyListeners();
    }
  }

  void authenticateWithOAuth() {
    _authService.signInWithGoogle();
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
          child: const SignUpScreen(),
        ),
      ),
    );
  }
}
