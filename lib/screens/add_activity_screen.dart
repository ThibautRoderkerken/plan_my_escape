import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/add_activity_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../view_models/dashboard/dashboard_view_model.dart';
import '../widgets/custom_text_field.dart';

class AddActivityScreen extends StatelessWidget {
  final int vacationIndex;

  const AddActivityScreen({Key? key, required this.vacationIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final descriptionController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) => AddActivityViewModel(
        vacationIndex: vacationIndex,
        dashboardViewModel:
            Provider.of<DashboardViewModel>(context, listen: false),
      ),
      child: Consumer<AddActivityViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Ajouter une nouvelle activité',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                  controller: nameController, label: 'Nom de l\'activité'),
              const SizedBox(height: 16),
              CustomTextField(controller: addressController, label: 'Adresse'),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: descriptionController, label: 'Description'),
              const SizedBox(height: 16),
              CustomActionButton(
                label: 'Ajouter',
                onPressed: () {
                  viewModel.addActivity(
                    nameController.text,
                    addressController.text,
                    descriptionController.text,
                  );
                },
              ),
              // Liste des activités
              Expanded(
                child: viewModel.activities.isEmpty
                    ? const Center(child: Text('Aucune activité ajoutée'))
                    : ListView.builder(
                        itemCount: viewModel.activities.length,
                        itemBuilder: (context, index) {
                          final activity = viewModel.activities[index];
                          return ListTile(
                            title: Text(activity.name),
                            subtitle: Text(activity.address),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => viewModel.removeActivity(index),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
