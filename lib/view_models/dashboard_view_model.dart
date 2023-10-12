class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});
}

class Activity {
  final String id;
  final String name;
  final String address;

  Activity({required this.id, required this.name, required this.address});
}

class WeatherInfo {
  final String description;
  final double temperature;

  // Vous pouvez ajouter d'autres détails si nécessaire, comme l'humidité, la vitesse du vent, etc.
  WeatherInfo({required this.description, required this.temperature});
}

class VacationPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final List<Member> members;
  final List<Activity> activities;
  final WeatherInfo weatherInfo;

  VacationPeriod({
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.members,
    required this.activities,
    required this.weatherInfo,
  });
}

class DashboardViewModel {
  List<VacationPeriod> vacationPeriods = [
    VacationPeriod(
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      destination: 'Barcelone',
      members: [
        Member(id: 'm1', name: 'Alice Dupont'),
        Member(id: 'm2', name: 'Bob Martin'),
      ],
      activities: [
        Activity(id: 'a1', name: 'Visite du Parc Güell', address: "Carrer d'Olot, Barcelone, Espagne"),
            Activity(id: 'a2', name: 'Dîner à El Nacional', address: 'Passeig de Gràcia, Barcelone, Espagne'),
      ],
      weatherInfo: WeatherInfo(description: 'Ensoleillé', temperature: 26.5),
    ),
    VacationPeriod(
      startDate: DateTime.now().add(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      destination: 'Rome',
      members: [
        Member(id: 'm3', name: 'Caroline Lambert'),
        Member(id: 'm4', name: 'David Bernard'),
      ],
      activities: [
        Activity(id: 'a3', name: 'Visite du Colisée', address: 'Piazza del Colosseo, Rome, Italie'),
        Activity(id: 'a4', name: 'Déjeuner à la Pergola', address: 'Via Alberto Cadlolo, Rome, Italie'),
      ],
      weatherInfo: WeatherInfo(description: 'Légèrement nuageux', temperature: 23.0),
    ),
  ];
}

