import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String? errorMessage;
  final AuthService _authService = AuthService();

  // Validation de l'email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (!value.contains('@')) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Validation du mot de passe (vous pouvez ajouter plus de règles)
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  // Méthode pour traiter l'inscription
  bool validateAndSignUp() {
    if (formKey.currentState!.validate()) {
      try {
        // Appeler le service d'authentification pour créer un compte
        var response = _authService.signUp(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text,
        );

        // Traiter la réponse (si nécessaire)
        // ...

        return true; // Retourner vrai si l'inscription est réussie
      } catch (e) {
        errorMessage = e.toString();
        notifyListeners();
        return false;
      }
    } else {
      return false;
    }
  }
}
