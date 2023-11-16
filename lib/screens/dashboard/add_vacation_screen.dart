// Fichier pour AddVacationScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vacation_period.dart';
import '../../models/weather_info.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../widgets/custom_action_button.dart';
import '../../widgets/custom_date_selector.dart';
import '../../widgets/custom_text_field.dart';

class AddVacationScreen extends StatefulWidget {
  final Function onVacationAdded;
  const AddVacationScreen({Key? key, required this.onVacationAdded}) : super(key: key);

  @override
  AddVacationScreenState createState() => AddVacationScreenState();
}

class AddVacationScreenState extends State<AddVacationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Form(
      key: _formKey,
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
            controller: destinationController,
          ),
          const SizedBox(height: 16),
          CustomDateSelector(
            label: 'Sélectionnez la période',
            onDateSelected: (range) {
              setState(() {
                startDate = range.start;
                endDate = range.end;
              });
            },
            errorMessage: _buttonPressed && (startDate == null || endDate == null)
                ? 'Les dates de début et de fin ne peuvent pas être vides'
                : null,
          ),
          const SizedBox(height: 16),
          CustomActionButton(
            label: 'Ajouter',
            onPressed: () {
              setState(() {
                _buttonPressed = true;
              });

              if (_formKey.currentState?.validate() == true && startDate != null && endDate != null) {
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

                // Appel à la fonction de rappel pour faire défiler la vue
                widget.onVacationAdded();
              }
            },
          ),
        ],
      ),
    );
  }
}
