import 'package:flutter/material.dart';
import '../../models/vacation_period.dart';
import '../../models/weather_info.dart';
import '../../services/holiday_service.dart'; // Assurez-vous d'importer HolidayService
import 'dashboard_view_model.dart';

class AddVacationViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController destinationController = TextEditingController();
  final HolidayService holidayService = HolidayService();
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

  Future<void> addVacationPeriod() async {
    var newVacation = VacationPeriod(
      startDate: startDate!,
      endDate: endDate!,
      destination: destinationController.text,
      members: [],
      activities: [],
      weatherInfo: WeatherInfo(description: 'Inconnu', temperature: 0.0),
    );

    try {
      // Appeler l'API pour ajouter la nouvelle période de vacances
      var response = await holidayService.addVacationPeriod(newVacation);
      // Juste récupérer l'id de la période de vacances ajoutée
      newVacation.vacationIndex = response["id"];
      dashboardViewModel.addVacationPeriod(newVacation);
    } catch (e) {
      // Gérer les erreurs ici
      print('Erreur lors de l\'ajout de la période de vacances: $e');
    }

    // Réinitialiser les champs après l'ajout
    destinationController.clear();
    startDate = null;
    endDate = null;
    notifyListeners();
  }
}
