import 'package:flutter/material.dart';
import 'add_vacation_screen.dart';
import 'display_vacations_screen.dart';
import '../navigation_drawer_screen.dart';

class DashboardMainScreen extends StatelessWidget {
  DashboardMainScreen({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        key: const Key('dashboard_screen_title'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVacationScreen(
                onVacationAdded: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                },
              ),
              const SizedBox(height: 16),
              DisplayVacationsScreen(), // Removed Expanded
            ],
          ),
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }
}

