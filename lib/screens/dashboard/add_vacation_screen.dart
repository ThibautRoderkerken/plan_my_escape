import 'package:flutter/material.dart';
import 'package:plan_my_escape/utils/date_selector.dart';
import 'package:provider/provider.dart';
import 'package:plan_my_escape/models/country.dart';
import '../../view_models/dashboard/add_vacation_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatelessWidget {
  final Function onVacationAdded;

  const AddVacationScreen({Key? key, required this.onVacationAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addVacationViewModel = Provider.of<AddVacationViewModel>(context);

    // Initialisation de la liste des pays avec une liste vide
    List<Country> countries = addVacationViewModel.countries;

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
          Autocomplete<Country>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Country>.empty();
              }
              return countries.where((Country country) {
                return country.name.toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (Country selection) {
              addVacationViewModel.setSelectedCountry(selection.name);
              addVacationViewModel.countryController.text = selection.name;
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Tapez pour rechercher un pays',
                  hintText: 'Commencez à taper le nom du pays',
                ),
              );
            },
            displayStringForOption: (Country option) => option.name,
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
                onVacationAdded();
              }
            },
          ),
        ],
      ),
    );
  }
}
