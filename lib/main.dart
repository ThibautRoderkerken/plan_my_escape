import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plan_my_escape/router/router.dart';

void main() {
  runApp(const MyApp());
  if (!const bool.fromEnvironment('runIntegrationTest', defaultValue: false)) {
    Geolocator.requestPermission();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanMyEscape',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
