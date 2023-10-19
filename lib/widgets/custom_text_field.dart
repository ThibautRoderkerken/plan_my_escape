import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;  // Ajout du champ controller

  const CustomTextField({
    Key? key,
    required this.label,
    this.isObscure = false,
    this.keyboardType,
    this.controller,  // Ajout du paramètre dans le constructeur
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        controller: controller,  // Utilisation du contrôleur ici
        decoration: InputDecoration(
          labelText: label,
        ),
        obscureText: isObscure,
        keyboardType: keyboardType,
      ),
    );
  }
}
