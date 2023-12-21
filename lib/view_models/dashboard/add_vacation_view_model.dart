import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/country.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/models/weather_info.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import 'package:plan_my_escape/utils/global_data.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';

class AddVacationViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final HolidayService holidayService = HolidayService();
  List<Country> countries = [];
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isButtonPressed = false;
  String? selectedCountry;

  AddVacationViewModel({required this.dashboardViewModel}) {
    initCountries(); // Appel initial pour charger les pays
  }

  List<Country> get getCountries => countries;

  void setSelectedCountry(String? newValue) {
    selectedCountry = newValue;
    notifyListeners(); // Notifie les listeners du changement
  }

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
    if (formKey.currentState?.validate() == true &&
        startDate != null &&
        endDate != null) {
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
      country: selectedCountry!,
      address: adressController.text,
      city: cityController.text,
    );

    try {
      // Appeler l'API pour ajouter la nouvelle période de vacances
      var response = await holidayService.addVacationPeriod(newVacation);
      // Juste récupérer l'id de la période de vacances ajoutée
      newVacation.vacationIndex = response["id"];
      dashboardViewModel.addVacationPeriod(newVacation);
    } catch (e) {
      // Si la période n'est pas ajoutée, la vue ne sera pas mise à jour
    }

    // Réinitialiser les champs après l'ajout
    destinationController.clear();
    startDate = null;
    endDate = null;
    notifyListeners();
  }

  void initCountries() {
    countries = GlobalData().countries;
    notifyListeners();
  }
}
