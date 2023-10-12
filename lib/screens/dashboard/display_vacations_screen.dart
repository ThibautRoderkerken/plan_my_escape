import 'package:flutter/material.dart';
import '../../view_models/dashboard_view_model.dart';

class DisplayVacationsScreen extends StatelessWidget {
  final dashboardViewModel = DashboardViewModel();

  DisplayVacationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Vos périodes de vacances planifiées',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dashboardViewModel.vacationPeriods.length,
            itemBuilder: (context, index) {
              final vacation = dashboardViewModel.vacationPeriods[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  leading: const Icon(Icons.beach_access),
                  title: Text(vacation.destination),
                  subtitle: Text(
                      "${vacation.startDate.toLocal().toString().split(' ')[0]} - ${vacation.endDate.toLocal().toString().split(' ')[0]}\n"
                          "${vacation.weatherInfo.description}, ${vacation.weatherInfo.temperature}°C"
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.group),
                      Text(vacation.members.length.toString()), // Nombre de membres
                      const SizedBox(height: 4),
                      const Icon(Icons.event),
                      Text(vacation.activities.length.toString()), // Nombre d'activités
                    ],
                  ),
                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VacationDetailScreen(vacation: vacation))), // Pour une future page de détails
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
