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
              DropdownButton<String>(
                value: addVacationViewModel.selectedCountry,
                onChanged: (String? newValue) {
                  addVacationViewModel.setSelectedCountry(newValue);
                },
                items: countries.map<DropdownMenuItem<String>>((Country country) {
                  return DropdownMenuItem<String>(
                    value: country.name,
                    child: Text(country.name),
                  );
                }).toList(),
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
