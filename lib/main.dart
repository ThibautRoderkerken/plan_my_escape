import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/login_view_model.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: const MyApp(),
    ),
  );
}

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
