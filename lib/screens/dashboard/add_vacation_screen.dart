import 'package:flutter/material.dart';
import 'package:plan_my_escape/utils/date_selector.dart';
import 'package:plan_my_escape/widgets/custom_autocomplete_field.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard/add_vacation_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatelessWidget {
  final Function onVacationAdded;

  const AddVacationScreen({Key? key, required this.onVacationAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            key: Key('add_vacation_title'),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Nom',
            controller: addVacationViewModel.destinationController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Adresse',
            controller: addVacationViewModel.adressController,
          ),
          const SizedBox(height: 16),
          CustomAutocomplete(
            controller: addVacationViewModel.countryController,
            viewModel: addVacationViewModel,
          ),
          const SizedBox(height: 16),
          CustomDateSelector(
            label: 'Sélectionnez la période',
            onDateSelected: addVacationViewModel.onDateSelected,
            validator: (DateTimeRange? range) {
              if (range == null) {
                return 'Veuillez sélectionner une plage de dates';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomActionButton(
            label: 'Ajouter',
            onPressed: () {
              if (addVacationViewModel.validateAndAddVacation()) {
                onVacationAdded();
              }
            },
          ),
        ],
      ),
    );
  }
}
