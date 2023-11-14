import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityCalendar extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final int vacationIndex;
  final DashboardViewModel viewModel;

  const ActivityCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.vacationIndex,
    required this.viewModel,
  }) : super(key: key);

  @override
  ActivityCalendarState createState() => ActivityCalendarState();
}

class ActivityCalendarState extends State<ActivityCalendar> {
  late final EventController<CalendarEventData> _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = EventController<CalendarEventData>();
    updateEvents();
  }

  void updateEvents() {
    final activities = widget.viewModel.getActivitiesForVacation(widget.vacationIndex);

    for (var activity in activities) {
      if (activity.scheduledDate != null && activity.scheduledTime != null) {
        DateTime startDateTime = DateTime(
          activity.scheduledDate!.year,
          activity.scheduledDate!.month,
          activity.scheduledDate!.day,
          activity.scheduledTime!.hour,
          activity.scheduledTime!.minute,
        );
        DateTime endDateTime = startDateTime.add(activity.duration ?? const Duration(hours: 1)); // Valeur par défaut si 'duration' est null

        // Imprimer pour le débogage
        if (kDebugMode) {
          print("Activité: ${activity.name}, Début: $startDateTime, Fin: $endDateTime");
        }

        _eventController.add(CalendarEventData(
          date: startDateTime,
          endDate: endDateTime,
          startTime: startDateTime,
          endTime: endDateTime,
          title: activity.name,
          description: activity.description,
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<CalendarEventData>(
      controller: _eventController,
      child: const DayView<CalendarEventData>(
        // Configurez le DayView ici
        // ...
      ),
    );
  }
}
