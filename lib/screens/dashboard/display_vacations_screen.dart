import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plan_my_escape/screens/add_member.dart';
import 'package:plan_my_escape/screens/calendar/activity_planner.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';
import '../add_activity_screen.dart';

class DisplayVacationsScreen extends StatelessWidget {

  const DisplayVacationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context); // Ici, nous obtenons l'instance du ViewModel depuis le Provider.

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
            physics: const NeverScrollableScrollPhysics(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vacation.destination),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Logique pour éditer
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Logique pour supprimer
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.publish),
                                onPressed: () {
                                  // Logique pour importer
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.chat),
                                onPressed: () {
                                  // Logique pour accéder au tchat
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "${vacation.startDate.toLocal().toString().split(' ')[0]} - ${vacation.endDate.toLocal().toString().split(' ')[0]}\n"
                            "${vacation.weatherInfo.description}, ${vacation.weatherInfo.temperature}°C",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Membres:'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddParticipantScreen(vacationIndex: vacation.vacationIndex)),
                              );
                            },
                          ),

                        ],
                      ),
                      for (var memberIndex = 0; memberIndex < vacation.members.length; memberIndex++)
                        ListTile(
                          title: Text(vacation.members[memberIndex].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              dashboardViewModel.removeMember(index, memberIndex);
                            },
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Activités:'),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.schedule),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityPlanner(vacationIndex: vacation.vacationIndex),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddActivityScreen(vacationIndex: vacation.vacationIndex)),
                                  );
                                },
                              ),
                            ]
                          )
                        ],
                      ),
                      for (var activityIndex = 0; activityIndex < vacation.activities.length; activityIndex++)
                        ListTile(
                          title: Text(vacation.activities[activityIndex].name),
                          subtitle: Text(vacation.activities[activityIndex].address),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.map),
                                onPressed: () async {
                                  bool serviceEnabled;
                                  LocationPermission permission;

                                  // Vérifie si les services de localisation sont activés
                                  serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    // Les services de localisation ne sont pas activés, ne continuez pas
                                    // à récupérer la position et informez l'utilisateur.
                                    print('Les services de localisation sont désactivés.');
                                    return;
                                  }

                                  permission = await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission = await Geolocator.requestPermission();
                                    if (permission == LocationPermission.denied) {
                                      // Les permissions sont refusées, informez l'utilisateur.
                                      print('Les permissions de localisation sont refusées');
                                      return;
                                    }
                                  }

                                  if (permission == LocationPermission.deniedForever) {
                                    // Les permissions sont refusées pour toujours, les manipulations
                                    // ne peuvent pas être effectuées.
                                    print('Les permissions de localisation sont définitivement refusées, nous ne pouvons pas demander les permissions.');
                                    return;
                                  }

                                  // Quand on arrive ici, les permissions sont accordées et on peut
                                  // continuer à accéder à la position de l'appareil.
                                  Position position = await Geolocator.getCurrentPosition();
                                  print('Position actuelle : ${position.latitude}, ${position.longitude}');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  dashboardViewModel.removeActivity(index, activityIndex);
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
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
