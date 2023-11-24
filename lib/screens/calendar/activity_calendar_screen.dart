import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';
import 'package:provider/provider.dart';
import '../../models/activity.dart';
import '../../models/enum/calendar_view_type.dart';
import '../../view_models/calendar/activity_calendar_view_model.dart';

class ActivityCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final int vacationIndex;
  final Function(BuildContext, Activity, Function(Activity)) onSelectDateTime;

  const ActivityCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.vacationIndex,
    required this.onSelectDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false); // On a besoin de l'instance du DashboardViewModel pour créer ActivityCalendarViewModel

    return ChangeNotifierProvider(
      create: (_) => ActivityCalendarViewModel(
        vacationIndex: vacationIndex,
        dashboardViewModel: dashboardViewModel,
      ),
      child: Consumer<ActivityCalendarViewModel>(
        builder: (context, viewModel, child) {
          return CalendarControllerProvider<CalendarEventData>(
            controller: viewModel.eventController,
            child: Column(
              children: [
                _buildToolbar(context, viewModel),
                Expanded(
                  child: _buildCalendarView(context, viewModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ActivityCalendarViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sélecteur de vue
          Expanded(
            child: DropdownButton<CalendarViewType>(
              value: viewModel.currentView,
              isExpanded: true,
              onChanged: (CalendarViewType? newValue) {
                if (newValue != null) {
                  viewModel.changeViewType(newValue);
                }
              },
              items: CalendarViewType.values.map((CalendarViewType view) {
                return DropdownMenuItem<CalendarViewType>(
                  value: view,
                  child: Row(
                    children: [
                      Icon(view == CalendarViewType.day
                          ? Icons.view_day
                          : Icons.view_week),
                      const SizedBox(width: 8),
                      Text(view == CalendarViewType.day
                          ? 'Vue Jour'
                          : 'Vue Semaine'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 20),
          // Bouton d'exportation
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => viewModel.exportCalendar(),
            tooltip: 'Exporter l\'agenda',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context, ActivityCalendarViewModel viewModel) {
    switch (viewModel.currentView) {
      case CalendarViewType.day:
        return DayView<CalendarEventData>(
          onEventTap: (events, date) => viewModel.onEventTap(context, events, date, onSelectDateTime),
          // Autres configurations du DayView
        );
      case CalendarViewType.week:
        return WeekView<CalendarEventData>(
          onEventTap: (events, date) => viewModel.onEventTap(context, events, date, onSelectDateTime),
          // Autres configurations du WeekView
        );
      default:
        return DayView<CalendarEventData>(
          onEventTap: (events, date) => viewModel.onEventTap(context, events, date, onSelectDateTime),
          // Autres configurations du DayView
        );
    }
  }
}
