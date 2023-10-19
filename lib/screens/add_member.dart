import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';

class AddParticipantScreen extends StatelessWidget {
  final int vacationIndex;  // Ajout du paramètre vacationIndex

  const AddParticipantScreen({super.key, required this.vacationIndex});  // Modification du constructeur pour inclure vacationIndex

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un participant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Ajouter un nouveau participant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const CustomTextField(label: 'Nom'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 16),
            CustomActionButton(
              label: 'Ajouter',
              onPressed: () {
                // Logique pour ajouter le participant
                // Utilisez dashboardViewModel pour ajouter un membre
                // Utilisez également vacationIndex pour cibler la période de vacances spécifique
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Liste des participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dashboardViewModel.vacationPeriods[vacationIndex].members.length, // Utilisez le bon nombre d'éléments
                itemBuilder: (context, index) {
                  final member = dashboardViewModel.vacationPeriods[vacationIndex].members[index];  // Utilisez vacationIndex pour cibler la période de vacances spécifique
                  return ListTile(
                    title: Text(member.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Logique pour supprimer le participant
                        // Utilisez dashboardViewModel pour supprimer un membre
                        // Utilisez également vacationIndex pour cibler la période de vacances spécifique
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
