import 'package:coptic_flutter_app/BaseCalendar.dart';
import 'package:coptic_flutter_app/CDate.dart';

Map<String, int> months = {
  'January': 1,
  'February': 2,
  'March': 3,
  'April': 4,
  'May': 5,
  'June': 6,
  'July': 7,
  'August': 8,
  'September': 9,
  'October': 10,
  'November': 11,
  'December': 12,
};

List<int> _parse(String eventDate) {
  List<String> events = eventDate.split(' ');

  int eventYear = int.parse(events[2]);
  int eventDay = int.parse(events[1]);
  int eventMonth = months[events[0]];

  return [eventYear, eventMonth, eventDay];
}

CDate getEventDate(
    BaseCalendar calendar, Map<String, String> evt, String period) {
  List<int> t = _parse(evt[period]);
  return calendar.fromJSDate(new DateTime(t[0], t[1], t[2]));
}
