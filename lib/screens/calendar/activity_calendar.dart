import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';

class ActivityCalendar extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;

  const ActivityCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
  }) : super(key: key);

  @override
  ActivityCalendarState createState() => ActivityCalendarState();
}

class ActivityCalendarState extends State<ActivityCalendar> {
  late PageController _pageController;
  late ValueNotifier<DateTime> _selectedDateNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay) {
    _selectedDateNotifier.value = selectedDay;
    // Ici, ajustez selon le besoin pour lier avec le PageView si nécessaire
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
              return TimetableView(
                // Assurez-vous de mettre à jour les événements pour le jour spécifique ici
                laneEventsList: const [],
                timetableStyle: const TimetableStyle(
                  startHour: 8,
                  endHour: 20,
                  // ... Autres styles
                ), onEmptySlotTap: (int laneIndex, TableEventTime start, TableEventTime end) {  }, onEventTap: (TableEvent event) {  },
                // ... Autres callbacks
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
