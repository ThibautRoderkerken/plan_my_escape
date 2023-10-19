import 'package:flutter/material.dart';
import '../../view_models/dashboard_view_model.dart';

class DisplayVacationsScreen extends StatelessWidget {
  final dashboardViewModel = DashboardViewModel();

  DisplayVacationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Ajouté un SingleChildScrollView ici
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Vos périodes de vacances planifiées',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dashboardViewModel.vacationPeriods.length,
            itemBuilder: (context, index) {
              final vacation = dashboardViewModel.vacationPeriods[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vacation.destination),
                      Text(
                        "${vacation.startDate.toLocal().toString().split(' ')[0]} - ${vacation.endDate.toLocal().toString().split(' ')[0]}\n"
                            "${vacation.weatherInfo.description}, ${vacation.weatherInfo.temperature}°C",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text('Membres:'),
                      for (var member in vacation.members)
                        ListTile(
                          title: Text(member.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Logique pour supprimer le membre
                            },
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text('Activités:'),
                      for (var activity in vacation.activities)
                        ListTile(
                          title: Text(activity.name),
                          subtitle: Text(activity.address),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.map),
                                onPressed: () {
                                  // Logique pour ouvrir dans Maps
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Logique pour supprimer l'activité
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
