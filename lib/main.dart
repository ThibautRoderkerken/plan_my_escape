import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}
// tet
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PlanMyEscape')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginScreen(),
        ),
      ),
    );
  }
}
