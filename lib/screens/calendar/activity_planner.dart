import 'package:flutter/material.dart';
import 'activity_pool.dart';
import 'activity_calendar.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityPlanner extends StatelessWidget {
  final int vacationIndex;  // Index de la période de vacances sélectionnée

  const ActivityPlanner({Key? key, required this.vacationIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final activities = dashboardViewModel.getActivitiesForVacation(vacationIndex);
    final VacationPeriod vacation = dashboardViewModel.vacationPeriods[vacationIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Planificateur d'Activités"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,  // 30% de l'espace
            child: SingleChildScrollView( // Rend le contenu déroulant
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Définissez une hauteur minimale pour le contenu déroulant
                  minHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      ActivityPool(viewModel: dashboardViewModel, vacationIndex: vacationIndex),
                      // Ajoutez d'autres widgets si nécessaire
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,  // 70% de l'espace
            child: ActivityCalendar(
              firstDay: vacation.startDate,
              lastDay: vacation.endDate,
            ),
          ),
        ],
      ),
    );
  }
}
