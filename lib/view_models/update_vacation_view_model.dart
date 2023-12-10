import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/services/holiday_service.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';
import 'package:provider/provider.dart';

import '../screens/dashboard/dashboard_screen.dart';

class UpdateVacationViewModel extends ChangeNotifier {
  final DashboardViewModel dashboardViewModel;
  late final TextEditingController destinationController;
  final HolidayService holidayService = HolidayService();
  DateTime? startDate;
  DateTime? endDate;

  UpdateVacationViewModel({required this.dashboardViewModel});

  String? get dateErrorMessage {
    if (startDate == null || endDate == null) {
      return 'Les dates de début et de fin ne peuvent pas être vides';
    }
    return null;
  }

  void onDateSelected(DateTimeRange range) {
    startDate = range.start;
    endDate = range.end;
    notifyListeners();
  }

  bool validateAndUpdateVacation(int vacationIndex, BuildContext context) {
    print("validateAndUpdateVacation");
    // Afficher toutes les informations de la période de vacances
    print("startDate: $startDate");
    print("endDate: $endDate");
    print("destination: ${destinationController.text}");
    if (startDate != null && endDate != null) {
      VacationPeriod updatedVacationPeriod = dashboardViewModel.getVacationPeriod()[vacationIndex];
      updatedVacationPeriod.startDate = startDate!;
      updatedVacationPeriod.endDate = endDate!;
      updatedVacationPeriod.destination = destinationController.text;

      try {
        holidayService.updateVacationPeriod(updatedVacationPeriod);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => DashboardViewModel(),
              child: DashboardMainScreen(),
            ),
          ),
        );
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
