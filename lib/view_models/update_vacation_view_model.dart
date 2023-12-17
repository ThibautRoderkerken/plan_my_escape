import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';

class UpdateVacationViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;
  TextEditingController destinationController = TextEditingController();
  final HolidayService holidayService = HolidayService();
  DateTime? startDate;
  DateTime? endDate;

  UpdateVacationViewModel({required this.dashboardViewModel});

  String? get dateErrorMessage {
    if (startDate == null || endDate == null) {
      return 'Les dates de début et de fin ne peuvent pas être vides';
    }
    notifyListeners();
    return null;
  }

  void onDateSelected(DateTimeRange range) {
    startDate = range.start;
    endDate = range.end;
    dateErrorMessage;
    notifyListeners(); // Notifier les listeners après la construction du widget
  }

  bool validateAndUpdateVacation(int vacationIndex, BuildContext context) {
    if (startDate != null && endDate != null) {
      VacationPeriod updatedVacationPeriod =
      dashboardViewModel.getVacationPeriod()[vacationIndex];
      updatedVacationPeriod.startDate = startDate!;
      updatedVacationPeriod.endDate = endDate!;
      updatedVacationPeriod.destination = destinationController.text;

      try {
        holidayService.updateVacationPeriod(updatedVacationPeriod);
        dashboardViewModel.notifyListeners();
        Navigator.pop(context);
      } catch (e) {
        if (kDebugMode) {
          print('Erreur lors de la mise à jour de la période de vacances: $e');
        }
      }
      return true;
    }
    return false;
  }
}
