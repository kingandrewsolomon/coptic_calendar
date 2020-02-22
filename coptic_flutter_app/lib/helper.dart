import 'package:coptic_flutter_app/BaseCalendar.dart';
import 'package:coptic_flutter_app/CDate.dart';
import 'package:coptic_flutter_app/CustomDate.dart';

Map<String, int> months = {
  'January': 0,
  'February': 1,
  'March': 2,
  'April': 3,
  'May': 4,
  'June': 5,
  'July': 6,
  'August': 7,
  'September': 8,
  'October': 9,
  'November': 10,
  'December': 11,
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
  return calendar.fromCustomDate(new CustomDate(t[0], t[1], t[2]));
}
