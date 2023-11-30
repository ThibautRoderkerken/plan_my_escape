import 'package:flutter/material.dart';
import '../exceptions/bad_request_exception.dart';
import '../exceptions/internal_server_exception.dart';
import '../exceptions/invalid_credentials_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/not_found_exception.dart';
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
  // bool validateAndSignUp() {
  //   if (formKey.currentState!.validate()) {
  //     try {
  //       // Appeler le service d'authentification pour créer un compte
  //       var response = _authService.signUp(
  //         emailController.text,
  //         passwordController.text,
  //         firstNameController.text,
  //         lastNameController.text,
  //       );
  //       return true; // Retourner vrai si l'inscription est réussie
  //     } catch (e) {
  //       errorMessage = e.toString();
  //       notifyListeners();
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> validateAndSignUp(Function onRegisterSuccess) async {
    if (formKey.currentState!.validate()) {
      try {
        await _authService.signUp(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text,
        );
        onRegisterSuccess();
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
}
