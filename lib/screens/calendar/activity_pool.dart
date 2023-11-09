import 'package:flutter/material.dart';
import 'package:plan_my_escape/view_models/dashboard_view_model.dart';

class ActivityPool extends StatefulWidget {
  final DashboardViewModel viewModel;
  final int vacationIndex;

  const ActivityPool({super.key, required this.viewModel, required this.vacationIndex});

  @override
  ActivityPoolState createState() => ActivityPoolState();
}

class ActivityPoolState extends State<ActivityPool> {
  Future<void> _selectDateTime(BuildContext context, Activity activity) async {
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
        await _selectDuration(context, selectedDate, selectedTime, activity);
      }
    }
  }

  Future<void> _selectDuration(BuildContext context, DateTime selectedDate, TimeOfDay selectedTime, Activity activity) async {
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
      setState(() {
        activity.scheduledDate = selectedDate;
        activity.scheduledTime = selectedTime;
        activity.duration = duration;
        widget.viewModel.updateActivity(activity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> activities = widget.viewModel.getActivitiesForVacation(widget.vacationIndex);
    return SingleChildScrollView(
      child: Column(
        children: activities.map((activity) {
          return ListTile(
            title: Text(activity.name),
            leading: const Icon(Icons.event),
            onTap: () => _selectDateTime(context, activity),
            trailing: activity.scheduledDate != null ? const Icon(Icons.check) : null,
          );
        }).toList(),
      ),
    );
  }
}
