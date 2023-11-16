import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  CalendarViewType _currentView = CalendarViewType.day;

  @override
  void initState() {
    super.initState();
    _eventController = EventController<CalendarEventData>();
    _loadViewType();
    updateEvents();
  }

  Future<void> _exportCalendar() async {
    try {
      String icsString = widget.viewModel.exportToICalendar(widget.vacationIndex);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_calendar.ics');
      await file.writeAsString(icsString);

      Share.shareFiles([file.path], text: 'Mon Agenda de Vacances');
    } catch (e) {
      // Gérer les erreurs ici
      if (kDebugMode) {
        print('Erreur lors de l\'exportation : $e');
      }
    }
  }

  void _changeViewType(CalendarViewType viewType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendarViewType', viewType.index);
    setState(() {
      _currentView = viewType;
    });
  }

  Future<void> _loadViewType() async {
    final prefs = await SharedPreferences.getInstance();
    // Utilisez une valeur par défaut si rien n'est trouvé
    int viewTypeIndex = prefs.getInt('calendarViewType') ?? CalendarViewType.day.index;
    setState(() {
      _currentView = CalendarViewType.values[viewTypeIndex];
    });
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

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sélecteur de vue
          Expanded(
            child: DropdownButton<CalendarViewType>(
              value: _currentView,
              isExpanded: true,
              onChanged: (CalendarViewType? newValue) {
                if (newValue != null) {
                  _changeViewType(newValue);
                }
              },
              items: CalendarViewType.values.map((CalendarViewType view) {
                return DropdownMenuItem<CalendarViewType>(
                  value: view,
                  child: Row(
                    children: [
                      Icon(view == CalendarViewType.day ? Icons.view_day : Icons.view_week),
                      const SizedBox(width: 8),
                      Text(view == CalendarViewType.day ? 'Vue Jour' : 'Vue Semaine'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 20), // Ajouter de l'espace entre les éléments
          // Bouton d'exportation
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportCalendar,
            tooltip: 'Exporter l\'agenda',
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<CalendarEventData>(
      controller: _eventController,
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: _buildCalendarView(),
          ),
        ],
      ),
    );
  }


  Widget _buildCalendarView() {
    switch (_currentView) {
      case CalendarViewType.day:
        return DayView<CalendarEventData>(
          onEventTap: _onEventTap,
          // Autres configurations du DayView
        );
      case CalendarViewType.week:
        return WeekView<CalendarEventData>(
          onEventTap: _onEventTap,
          // Autres configurations du WeekView
        );
      default:
        return DayView<CalendarEventData>(
          onEventTap: _onEventTap,
          // Autres configurations du DayView
        );
    }
  }

}

enum CalendarViewType {
  day,
  week,
}
