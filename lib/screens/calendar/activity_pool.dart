import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/dashboard_view_model.dart';

class ActivityPool extends StatefulWidget {
  final List<Activity> activities;

  const ActivityPool({super.key, required this.activities});

  @override
  ActivityPoolState createState() => ActivityPoolState();
}

class ActivityPoolState extends State<ActivityPool> {
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (selectedDate != null && mounted) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null && mounted) {
        await _selectDuration(context, selectedDate, selectedTime);
      }
    }
  }

  Future<void> _selectDuration(BuildContext context, DateTime selectedDate, TimeOfDay selectedTime) async {
    Duration? duration = await showDialog<Duration>(
      context: context,
      builder: (context) {
        Duration tempDuration = const Duration(hours: 1); // Durée initiale par défaut
        return AlertDialog(
          title: const Text('Choisissez la durée'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${tempDuration.inHours} heures, ${tempDuration.inMinutes % 60} minutes'),
                  Slider(
                    min: 0,
                    max: 480, // Limite à 8 heures pour la durée
                    divisions: 16, // Intervalle de 30 minutes
                    value: tempDuration.inMinutes.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        tempDuration = Duration(minutes: value.round());
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempDuration),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (duration != null && mounted) {
      // Ici, vous avez selectedDate, selectedTime, et duration
      // Vous pouvez traiter ces informations comme nécessaire
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget.activities.map((activity) {
          return ListTile(
            title: Text(activity.name),
            leading: const Icon(Icons.event),
            onTap: () => _selectDateTime(context),
          );
        }).toList(),
      ),
    );
  }
}
