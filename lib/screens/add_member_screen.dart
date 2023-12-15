import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/add_participant_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';
import '../view_models/dashboard/dashboard_view_model.dart';

class AddParticipantScreen extends StatelessWidget {
  final int vacationIndex;

  const AddParticipantScreen({Key? key, required this.vacationIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastName = TextEditingController();
    final firstName = TextEditingController();
    final emailController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) => AddParticipantViewModel(
        vacationIndex: vacationIndex,
        dashboardViewModel:
            Provider.of<DashboardViewModel>(context, listen: false),
      ),
      child: Consumer<AddParticipantViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Ajouter un nouveau participant',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(controller: lastName, label: 'Nom'),
              const SizedBox(height: 16),
              CustomTextField(controller: firstName, label: 'Prénom'),
              const SizedBox(height: 16),
              CustomTextField(controller: emailController, label: 'Email'),
              const SizedBox(height: 16),
              CustomActionButton(
                label: 'Ajouter',
                onPressed: () {
                  if (lastName.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    viewModel.addParticipant(
                      lastName.text,
                      emailController.text,
                      firstName.text,
                    );
                  }
                },
              ),
              // Liste des participants
              Expanded(
                child: viewModel.participants.isEmpty
                    ? const Center(child: Text('Aucun participant ajouté'))
                    : ListView.builder(
                        itemCount: viewModel.participants.length,
                        itemBuilder: (context, index) {
                          final participant = viewModel.participants[index];
                          return ListTile(
                            title: Text(
                                '${participant.lastName} ${participant.firstName}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  viewModel.removeParticipant(index),
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
