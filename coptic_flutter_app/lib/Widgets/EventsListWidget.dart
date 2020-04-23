import 'package:coptic_flutter_app/Calendars/BaseCalendar.dart';
import 'package:coptic_flutter_app/ParentCalendar.dart';
import 'package:coptic_flutter_app/events.dart';
import 'package:coptic_flutter_app/helper.dart';
import 'package:coptic_flutter_app/synax.dart';
import 'package:flutter/material.dart';

import 'package:coptic_flutter_app/Calendars/CDate.dart';

import 'EventWidget.dart';

class EventsList extends StatefulWidget {
  EventsList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventsListState();
}

class EventsListState extends State<EventsList> {
  List<Widget> events = new List();
  CDate date;
  BaseCalendar calendar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    calendar = ParentCalendar.of(context).calendar;
    date = ParentCalendar.of(context).selectedDate;
  }

  @override
  void initState() {
    super.initState();
  }

  List buildLists(CDate date) {
    int c = 0;
    int e = 0;
    events = new List();
    // Adding Feasts/Fasts Events
    for (var evt in event) {
      CDate calendarEventStart = getEventDate(calendar, evt, 'startDate');
      CDate calendarEventEnd = getEventDate(calendar, evt, 'endDate');
      if (calendarEventEnd.compareTo(date) >= 0 &&
          calendarEventStart.compareTo(date) <= 0) {
        c++;
        e++;
        events.add(new Container(
          child: Text(evt['Title']),
        ));
      }
    }

    // Adding Synaxarium Events
    List<String> synaxEvent =
        synax[calendar.dayOfYear(date.year(), date.month(), date.day())];
    for (String evt in synaxEvent) {
      c++;
      // events.add(new Container(
      //   child: Text(evt),
      // ));
      events.add(new Event(
        title: evt,
        description: "Enter Description Here",
      ));
    }
    return [c, e];
  }

  pop() {
    print('pop');
  }

  @override
  Widget build(BuildContext context) {
    var pcalendar = ParentCalendar.of(context);
    var date = pcalendar.selectedDate;
    List count = buildLists(date);
    // BouncingScrollPhysics bounce = new BouncingScrollPhysics();

    return Container(
      constraints: BoxConstraints(maxHeight: 340),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: count[0],
        itemBuilder: (context, index) {
          if (index < count[1]) {
            return Card(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.grey[50],
                    onPressed: pop,
                    child: ListTile(
                      title: events[index],
                    ),
                  )),
              color: Colors.green,
            );
          } else {
            return Card(
                child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    onPressed: pop,
                    child: ListTile(
                      title: events[index],
                    )));
          }
        },
        shrinkWrap: true,
        padding: const EdgeInsets.all(1.0),
      ),
    );
  }
}
