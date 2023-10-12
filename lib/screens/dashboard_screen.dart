import 'package:flutter/material.dart';
import 'navigation_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
      ),
      body: const Center(
        child: Text('Bienvenue sur le tableau de bord !'),
      ),
      drawer: const AppNavigationDrawer (),
    );
  }
}
