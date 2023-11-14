import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import '../../view_models/dashboard_view_model.dart';

class ActivityCalendar extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final int vacationIndex;
  final DashboardViewModel viewModel;
  final Function(BuildContext, Activity, Function(Activity)) onSelectDateTime;

  const ActivityCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.vacationIndex,
    required this.viewModel,
    required this.onSelectDateTime,
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
        DateTime endDateTime = startDateTime.add(activity.duration ?? const Duration(hours: 1));

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

  void _onEventTap(List<CalendarEventData> events, DateTime date) {
    if (events.isNotEmpty) {
      final eventData = events.first;
      // Trouver l'activité correspondante
      Activity? activity = widget.viewModel.getActivitiesForVacation(widget.vacationIndex)
          .firstWhere(
              (a) => a.name == eventData.title && a.description == eventData.description,
      );

      widget.onSelectDateTime(context, activity, (updatedActivity) {
        setState(() {
          widget.viewModel.updateActivity(updatedActivity);
          updateEvents(); // Mettre à jour les événements après la modification
        });
      });
        }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<CalendarEventData>(
      controller: _eventController,
      child: DayView<CalendarEventData>(
        onEventTap: _onEventTap,
        // Autres configurations du DayView
      ),
    );
  }
}
