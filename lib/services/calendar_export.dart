import 'package:intl/intl.dart';
import '../models/activity.dart';

String exportToICalendarService(List<Activity> vacationActivity) {
  List<String> icsEvents = [];
  String icsHeader = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN";
  String icsFooter = "END:VCALENDAR";

  for (var activity in vacationActivity) {
    if (activity.scheduledDate != null && activity.scheduledTime != null && activity.duration != null) {
      DateTime startDateTime = DateTime(
        activity.scheduledDate!.year,
        activity.scheduledDate!.month,
        activity.scheduledDate!.day,
        activity.scheduledTime!.hour,
        activity.scheduledTime!.minute,
      );
      DateTime endDateTime = startDateTime.add(activity.duration!);

      String formattedStart = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(startDateTime.toUtc());
      String formattedEnd = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(endDateTime.toUtc());

      icsEvents.add(
          "BEGIN:VEVENT\n"
              "DTSTART:$formattedStart\n"
              "DTEND:$formattedEnd\n"
              "SUMMARY:${activity.name}\n"
              "DESCRIPTION:${activity.description}\n"
              "END:VEVENT"
      );
    }
  }

  return "$icsHeader\n${icsEvents.join("\n")}\n$icsFooter";
}