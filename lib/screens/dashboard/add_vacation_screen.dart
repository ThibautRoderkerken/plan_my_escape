import 'package:flutter/material.dart';
import 'package:plan_my_escape/screens/shared_components/date_selector.dart';
import 'package:plan_my_escape/view_models/dashboard/add_vacation_view_model.dart';
import 'package:plan_my_escape/widgets/custom_action_button.dart';
import 'package:plan_my_escape/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:plan_my_escape/models/country.dart';


class AddVacationScreen extends StatelessWidget {
  final Function onVacationAdded;

  const AddVacationScreen({Key? key, required this.onVacationAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addVacationViewModel = Provider.of<AddVacationViewModel>(context);

    return FutureBuilder<List<Country>>(
      future: addVacationViewModel.getCountriesFromPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

        List<Country> countries = snapshot.data ?? [];

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
      },
    );
  }
}
