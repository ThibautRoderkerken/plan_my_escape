import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';  // Assurez-vous que cet import est correct
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_date_selector.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatefulWidget {
  AddVacationScreen({Key? key}) : super(key: key);

  @override
  _AddVacationScreenState createState() => _AddVacationScreenState();
}

class _AddVacationScreenState extends State<AddVacationScreen> {
  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;  // Date de début sélectionnée
  DateTime? endDate;  // Date de fin sélectionnée

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Column(
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
          controller: destinationController,  // Ajout du contrôleur ici
        ),
        const SizedBox(height: 16),
        CustomDateSelector(
          label: 'Sélectionnez la période',
          onDateSelected: (range) { // Ajout de la fonction de rappel
            setState(() {
              startDate = range.start;
              endDate = range.end;
            });
          },
        ),
        const SizedBox(height: 16),
        CustomActionButton(
          label: 'Ajouter',
          onPressed: () {
            if (startDate != null && endDate != null) {
              // Logique pour ajouter la période de vacances
              dashboardViewModel.addVacationPeriod(
                VacationPeriod(
                  vacationIndex: dashboardViewModel.vacationPeriods.length,
                  startDate: startDate!,
                  endDate: endDate!,
                  destination: destinationController.text,
                  members: [],
                  activities: [],
                  weatherInfo: WeatherInfo(description: 'Inconnu', temperature: 0.0),
                ),
              );
            } else {
              // Afficher une alerte indiquant que les dates sont nécessaires
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Erreur"),
                  content: Text("Veuillez sélectionner des dates de début et de fin."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
