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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Ajout des marges horizontales
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ajouter une nouvelle période de vacances',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Destination',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date de début',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date de fin',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logique pour ajouter la période de vacances
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }
}
