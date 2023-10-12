import 'package:flutter/material.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_date_selector.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatelessWidget {
  const AddVacationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),  // Ajout de l'espace ici
        const Text(
          'Ajouter une nouvelle période de vacances',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        const CustomTextField(label: 'Destination'),
        const SizedBox(height: 16),
        const CustomDateSelector(label: 'Sélectionnez la période'),
        const SizedBox(height: 16),
        CustomActionButton(
          label: 'Ajouter',
          onPressed: () {
            // Logique pour ajouter la période de vacances
          },
        ),
      ],
    );
  }
}
