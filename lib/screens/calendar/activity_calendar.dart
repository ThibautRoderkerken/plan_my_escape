import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';

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
  late PageController _pageController;
  late ValueNotifier<DateTime> _selectedDateNotifier;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<TableEvent> _getEventsForDay(DateTime day) {
    final activities = widget.viewModel.getActivitiesForVacation(widget.vacationIndex);

    List<TableEvent> events = activities.where((activity) {
      // Vérifier si l'activité est planifiée pour le jour en question
      bool isSameDay = activity.scheduledDate != null && _isSameDay(activity.scheduledDate!, day);
      return isSameDay;
    }).map((activity) {
      // Transformer chaque activité en un TableEvent
      return TableEvent(
        title: activity.name,
        startTime: TableEventTime(hour: activity.scheduledTime!.hour, minute: activity.scheduledTime!.minute),
        endTime: TableEventTime(
          hour: activity.scheduledTime!.hour + activity.duration!.inHours,
          minute: (activity.scheduledTime!.minute + activity.duration!.inMinutes) % 60,
        ), eventId: 0, laneIndex: 0,
      );
    }).toList();

    return events;
  }



  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _selectedDateNotifier = ValueNotifier<DateTime>(widget.firstDay);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay) {
    _selectedDateNotifier.value = selectedDay;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ValueListenableBuilder<DateTime>(
          valueListenable: _selectedDateNotifier,
          builder: (context, value, _) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${value.day}/${value.month}/${value.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          },
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.lastDay.difference(widget.firstDay).inDays + 1,
            itemBuilder: (context, index) {
              DateTime day = widget.firstDay.add(Duration(days: index));
              List<TableEvent> events = _getEventsForDay(day);
              return TimetableView(
                laneEventsList: [LaneEvents(lane: Lane(name: 'Activités', laneIndex: 1), events: events)], // Ajout de [
                timetableStyle: const TimetableStyle(
                  startHour: 8,
                  endHour: 20,
                ), onEmptySlotTap: (int laneIndex, TableEventTime start, TableEventTime end) {  }, onEventTap: (TableEvent event) {  },
              );
            },
            onPageChanged: (index) {
              DateTime selectedDay = widget.firstDay.add(Duration(days: index));
              _onDaySelected(selectedDay);
            },
          ),
        ),
        // Boutons pour changer de jour
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
