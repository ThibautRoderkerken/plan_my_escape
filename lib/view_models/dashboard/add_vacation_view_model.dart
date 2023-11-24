import 'package:flutter/material.dart';
import '../../models/vacation_period.dart';
import '../../models/weather_info.dart';
import 'dashboard_view_model.dart';

class AddVacationViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isButtonPressed = false;

  AddVacationViewModel({required this.dashboardViewModel});

  String? get dateErrorMessage {
    if (isButtonPressed && (startDate == null || endDate == null)) {
      return 'Les dates de début et de fin ne peuvent pas être vides';
    }
    return null;
  }

  void onDateSelected(DateTimeRange range) {
    startDate = range.start;
    endDate = range.end;
    notifyListeners();
  }

  bool validateAndAddVacation() {
    isButtonPressed = true;
    if (formKey.currentState?.validate() == true && startDate != null && endDate != null) {
      addVacationPeriod();
      isButtonPressed = false;
      return true;
    }
    isButtonPressed = false;
    notifyListeners();
    return false;
  }

  void addVacationPeriod() {
    var newVacation = VacationPeriod(
      vacationIndex: dashboardViewModel.vacationPeriods.length, // Générer l'index basé sur le nombre de périodes existantes
      startDate: startDate!,
      endDate: endDate!,
      destination: destinationController.text,
      members: [],
      activities: [],
      weatherInfo: WeatherInfo(description: 'Inconnu', temperature: 0.0),
    );

    // Ajouter la nouvelle période de vacances au DashboardViewModel
    dashboardViewModel.addVacationPeriod(newVacation);

    // Réinitialiser les champs après l'ajout
    destinationController.clear();
    startDate = null;
    endDate = null;
    notifyListeners();
  }
}
