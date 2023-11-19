import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool isLoginSuccess = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (!value.contains('@')) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  void validateAndLogin(Function onLoginSuccess) {
    if (formKey.currentState!.validate()) {
      // Todo: connecter a l'API
      if (isLoginSuccess) {
        errorMessage = null;
        onLoginSuccess();
      } else {
        errorMessage = 'Email ou mot de passe incorrect';
        notifyListeners();
        isLoginSuccess = true;
      }
    }
  }

  void authenticateWithOAuth() {
    // Todo: connecter a l'API
  }

  void navigateToSignUp() {
    // Todo: rediriger vers la page d'inscription
  }
}
