import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard/add_vacation_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../shared_components/date_selector.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatelessWidget {
  final Function onVacationAdded;
  const AddVacationScreen({Key? key, required this.onVacationAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupération de l'instance partagée du AddVacationViewModel
    final addVacationViewModel = Provider.of<AddVacationViewModel>(context);

    return Form(
      key: addVacationViewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Ajouter une nouvelle période de vacances',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Destination',
            controller: addVacationViewModel.destinationController,
          ),
          const SizedBox(height: 16),
          CustomDateSelector(
            label: 'Sélectionnez la période',
            onDateSelected: addVacationViewModel.onDateSelected,
            errorMessage: addVacationViewModel.dateErrorMessage,
          ),
          const SizedBox(height: 16),
          CustomActionButton(
            label: 'Ajouter',
            onPressed: () {
              if (addVacationViewModel.validateAndAddVacation()) {
                // Appel à la fonction de rappel après l'ajout de la période de vacances
                onVacationAdded();
              }
            },
          ),
        ],
      ),
    );
  }
}
