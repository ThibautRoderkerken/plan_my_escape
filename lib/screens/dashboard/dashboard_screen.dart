import 'package:flutter/material.dart';
import 'add_vacation_screen.dart';
import 'display_vacations_screen.dart';
import '../navigation_drawer.dart';

class DashboardMainScreen extends StatelessWidget {
  const DashboardMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVacationScreen(),
              const SizedBox(height: 16),
              const DisplayVacationsScreen(), // Removed Expanded
            ],
          ),
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }
}
