import 'package:flutter/material.dart';
import '../../models/activity.dart';
import '../../models/vacation_period.dart';
import 'activity_pool_screen.dart';
import 'activity_calendar_screen.dart';
import 'package:provider/provider.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityPlanner extends StatefulWidget {
  final int vacationIndex;

  const ActivityPlanner({Key? key, required this.vacationIndex}) : super(key: key);

  @override
  ActivityPlannerState createState() => ActivityPlannerState();
}

class ActivityPlannerState extends State<ActivityPlanner> {

  UniqueKey _calendarKey = UniqueKey();

  void refreshCalendar() {
    setState(() {
      // Générer une nouvelle clé pour forcer la reconstruction
      _calendarKey = UniqueKey();
    });
  }

  Future<void> selectActivityDateTime(BuildContext context, Activity activity, Function(Activity) onUpdate) async {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);
    VacationPeriod vacation = dashboardViewModel.vacationPeriods[widget.vacationIndex];

    // Utiliser la date programmée de l'activité si elle existe, sinon utiliser la logique actuelle
    DateTime initialSelectedDate = activity.scheduledDate ??
        (DateTime.now().isAfter(vacation.startDate) && DateTime.now().isBefore(vacation.endDate)
            ? DateTime.now() : vacation.startDate);

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialSelectedDate,
      firstDate: vacation.startDate,
      lastDate: vacation.endDate,
    );

    if (selectedDate != null && mounted) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: activity.scheduledTime ?? TimeOfDay.now(),
      );

      if (selectedTime != null && mounted) {
        Duration? duration = await showDialog<Duration>(
          context: context,
          builder: (context) {
            Duration tempDuration = activity.duration ?? const Duration(hours: 1);
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
                        max: 480,
                        divisions: 16,
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
          activity.scheduledDate = selectedDate;
          activity.scheduledTime = selectedTime;
          activity.duration = duration;
          onUpdate(activity);
          refreshCalendar();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final VacationPeriod vacation = dashboardViewModel.vacationPeriods[widget.vacationIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Planificateur d'Activités"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3, // 30% de l'espace
            child: ActivityPool(
                viewModel: dashboardViewModel,
                vacationIndex: widget.vacationIndex,
                onSelectDateTime: (context, activity, onUpdate) =>
                  selectActivityDateTime(context, activity, onUpdate).then((_) => refreshCalendar()),
            ),
          ),
          Expanded(
            flex: 7, // 70% de l'espace
            child: ActivityCalendar(
              key: _calendarKey,
              firstDay: vacation.startDate,
              lastDay: vacation.endDate,
              vacationIndex: widget.vacationIndex,
              viewModel: dashboardViewModel,
              onSelectDateTime: (context, activity, onUpdate) =>
                  selectActivityDateTime(context, activity, onUpdate).then((_) => refreshCalendar()),
            ),
          ),
        ],
      ),
    );
  }
}
