import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final ButtonStyle? style;

  const CustomActionButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
      child: Text(label),
    );
  }
}
