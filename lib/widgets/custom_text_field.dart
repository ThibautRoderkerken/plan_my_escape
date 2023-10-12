import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  final TextInputType? keyboardType; // Ajout du paramètre keyboardType

  const CustomTextField({
    Key? key,
    required this.label,
    this.isObscure = false,
    this.keyboardType, // Initialiser à une valeur par défaut ou laisser tel quel pour null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      obscureText: isObscure,
      keyboardType: keyboardType, // Ajouter cette ligne
    );
  }
}
