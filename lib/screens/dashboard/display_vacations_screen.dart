import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plan_my_escape/screens/add_member_screen.dart';
import 'package:plan_my_escape/screens/calendar/activity_planner_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../view_models/dashboard_view_model.dart';
import '../add_activity_screen.dart';


class DisplayVacationsScreen extends StatefulWidget {
  const DisplayVacationsScreen({Key? key}) : super(key: key);

  @override
  DisplayVacationsScreenState createState() => DisplayVacationsScreenState();
}

class DisplayVacationsScreenState extends State<DisplayVacationsScreen> {
  bool _isLoading = false;

  Future<void> _launchGoogleMaps(String startPosition, String destination) async {
    try {
      setState(() => _isLoading = true);

      var encodedStartPosition = Uri.encodeComponent(startPosition);
      var encodedDestination = Uri.encodeComponent(destination);
      var googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$encodedStartPosition&destination=$encodedDestination&travelmode=driving';
      await Future.delayed(const Duration(seconds: 1));

      await launch(googleMapsUrl);

      // Attendre quelques secondes avant de masquer l'indicateur de chargement
    } catch (e) {
      // Afficher un message d'erreur si nécessaire
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

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
                              IconButton(
                                icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.map),
                                onPressed: _isLoading ? null : () async {
                                  String address = vacation.destination;
                                  var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                  String currentPosition = "${position.latitude},${position.longitude}";
                                  _launchGoogleMaps(currentPosition, address);
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
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider.value(
                                    value: dashboardViewModel,
                                    child: AddParticipantScreen(
                                      dashboardViewModel: dashboardViewModel,
                                      vacationIndex: vacation.vacationIndex,
                                    ),
                                  ),
                                ),
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
                                    MaterialPageRoute(
                                      builder: (context) => ChangeNotifierProvider.value(
                                        value: dashboardViewModel,
                                        child: AddActivityScreen(
                                          dashboardViewModel: dashboardViewModel,
                                          vacationIndex: vacation.vacationIndex,
                                        ),
                                      ),
                                    ),
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
                                icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.map),
                                onPressed: _isLoading ? null : () async {
                                  String address = vacation.activities[activityIndex].address;
                                  // Récupérer l'adresse actuelle de l'utilisateur
                                  var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                  // Convertir en string
                                  String currentPosition = "${position.latitude},${position.longitude}";
                                  _launchGoogleMaps(currentPosition, address);
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
