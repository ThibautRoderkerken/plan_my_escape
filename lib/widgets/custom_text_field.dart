import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isObscure = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        obscureText: isObscure,
        keyboardType: keyboardType,
      ),
    );
  }
}
