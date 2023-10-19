import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';

class AddParticipantScreen extends StatelessWidget {
  final int vacationIndex;
  final TextEditingController nameController = TextEditingController();  // Contrôleur pour le nom
  final TextEditingController emailController = TextEditingController();  // Contrôleur pour l'email

  AddParticipantScreen({Key? key, required this.vacationIndex}) : super(key: key);

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
            CustomTextField(controller: nameController, label: 'Nom'),  // Ajout du contrôleur
            const SizedBox(height: 16),
            CustomTextField(controller: emailController, label: 'Email'),  // Ajout du contrôleur
            const SizedBox(height: 16),
            CustomActionButton(
              label: 'Ajouter',
              onPressed: () {
                dashboardViewModel.addMember(
                    vacationIndex,
                    nameController.text,
                    emailController.text
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Liste des participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: dashboardViewModel.vacationPeriods[vacationIndex].members.isEmpty
                  ? const Center(
                child: Text('Aucun participant ajouté'),
              )
                  : ListView.builder(
                itemCount: dashboardViewModel.vacationPeriods[vacationIndex].members.length,
                itemBuilder: (context, index) {
                  final member = dashboardViewModel.vacationPeriods[vacationIndex].members[index];
                  return ListTile(
                    title: Text(member.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        dashboardViewModel.removeMember(vacationIndex, index);
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
