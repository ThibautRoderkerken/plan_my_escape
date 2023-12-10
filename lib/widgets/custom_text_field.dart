import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isObscure = false,
    this.keyboardType,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('label: $label');
    print('isObscure: $isObscure');
    print('keyboardType: $keyboardType');
    print('controller: $controller');
    print('validator: $validator');
    return Material(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        obscureText: isObscure,
        keyboardType: keyboardType,
        validator: validator ?? (String? value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ ne peut pas être vide';
          }
          return null;
        },
      ),
    );
  }
}
