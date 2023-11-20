import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';

class AddActivityScreen extends StatelessWidget {
  final int vacationIndex;
  final TextEditingController nameController = TextEditingController();  // Contrôleur pour le nom de l'activité
  final TextEditingController addressController = TextEditingController();  // Contrôleur pour l'adresse
  final TextEditingController descriptionController = TextEditingController();  // Contrôleur pour la description
  final DashboardViewModel dashboardViewModel;

  AddActivityScreen({Key? key, required this.dashboardViewModel, required this.vacationIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une activité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Ajouter une nouvelle activité',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomTextField(controller: nameController, label: 'Nom de l\'activité'),
            const SizedBox(height: 16),
            CustomTextField(controller: addressController, label: 'Adresse'),
            const SizedBox(height: 16),
            CustomTextField(controller: descriptionController, label: 'Description'),
            const SizedBox(height: 16),
            CustomActionButton(
              label: 'Ajouter',
              onPressed: () {
                dashboardViewModel.addActivity(
                    vacationIndex,
                    nameController.text,
                    addressController.text,
                    descriptionController.text
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Liste des activités',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: dashboardViewModel.vacationPeriods[vacationIndex].activities.isEmpty
                  ? const Center(
                child: Text('Aucune activité ajoutée'),
              )
                  : ListView.builder(
                itemCount: dashboardViewModel.vacationPeriods[vacationIndex].activities.length,
                itemBuilder: (context, index) {
                  final activity = dashboardViewModel.vacationPeriods[vacationIndex].activities[index];
                  return ListTile(
                    title: Text(activity.name),
                    subtitle: Text(activity.address),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        dashboardViewModel.removeActivity(vacationIndex, index);
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
