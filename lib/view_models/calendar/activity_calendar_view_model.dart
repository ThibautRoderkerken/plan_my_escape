import 'dart:io';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/activity.dart';
import '../../models/enum/calendar_view_type.dart';
import '../../services/calendar_export.dart';
import '../dashboard/dashboard_view_model.dart';

class ActivityCalendarViewModel extends ChangeNotifier {
  final int vacationIndex;
  late final EventController<CalendarEventData> eventController;
  CalendarViewType currentView = CalendarViewType.day;
  final DashboardViewModel dashboardViewModel;

  ActivityCalendarViewModel({required this.dashboardViewModel, required this.vacationIndex}) {
    eventController = EventController<CalendarEventData>();
    loadViewType();
    updateEvents();
  }

  void changeViewType(CalendarViewType viewType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendarViewType', viewType.index);
    currentView = viewType;
    notifyListeners();
  }

  Future<void> loadViewType() async {
    final prefs = await SharedPreferences.getInstance();
    int viewTypeIndex = prefs.getInt('calendarViewType') ?? CalendarViewType.day.index;
    currentView = CalendarViewType.values[viewTypeIndex];
    notifyListeners();
  }

  void updateEvents() {
    List<Activity> activities = dashboardViewModel.getActivitiesForVacation(vacationIndex);

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

        eventController.add(CalendarEventData(
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

  Future<void> exportCalendar() async {
    try {
      String icsString = exportToICalendarService(dashboardViewModel.getActivitiesForVacation(vacationIndex));
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_calendar.ics');
      await file.writeAsString(icsString);

      Share.shareFiles([file.path], text: 'Mon Agenda de Vacances');
    } catch (e) {
      print('Erreur lors de l\'exportation : $e');
    }
  }

  void onEventTap(BuildContext context, List<CalendarEventData> events, DateTime date, Function(BuildContext, Activity, Function(Activity)) onSelectDateTime) {
    if (events.isNotEmpty) {
      final eventData = events.first;
      // Trouver l'activité correspondante
      Activity? activity = dashboardViewModel.getActivitiesForVacation(vacationIndex).firstWhere(
            (a) => a.name == eventData.title && a.description == eventData.description,
      );

      onSelectDateTime(context, activity, (updatedActivity) {
        notifyListeners();
        updateEvents();
      });
    }
  }
}
