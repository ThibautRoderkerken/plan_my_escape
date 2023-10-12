import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isObscure;
  const CustomTextField({Key? key, required this.label, this.isObscure = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      obscureText: isObscure,
    );
  }
}
