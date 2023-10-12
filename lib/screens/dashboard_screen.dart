import 'package:flutter/material.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_date_selector.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ajouter une nouvelle période de vacances',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const CustomTextField(label: 'Destination'),
            const SizedBox(height: 16),
            const CustomDateSelector(label: 'Sélectionnez la période'), // Utilisation d'un seul sélecteur pour les dates de début et de fin
            const SizedBox(height: 16),
            CustomActionButton(
              label: 'Ajouter',
              onPressed: () {
                // Logique pour ajouter la période de vacances
              },
            ),
          ],
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }
}
