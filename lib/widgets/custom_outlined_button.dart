import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  const CustomOutlinedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }
}
