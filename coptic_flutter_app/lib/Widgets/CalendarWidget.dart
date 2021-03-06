import 'package:coptic_flutter_app/Calendars/BaseCalendar.dart';
import 'package:coptic_flutter_app/Widgets/CalendarCellWidget.dart';
import 'package:coptic_flutter_app/ParentCalendar.dart';
import 'package:coptic_flutter_app/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:coptic_flutter_app/Calendars/CDate.dart';
import 'package:coptic_flutter_app/events.dart';

class Calendar extends StatefulWidget {
  final int month;
  final int year;

  Calendar({
    Key key,
    this.month,
    this.year,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  String month;
  int curMonth;
  int year;
  BaseCalendar calendar;
  List<TableRow> calendarRows;
  Color color;
  CDate selectedDate;

  TableCell _makeCell({color = Colors.transparent, CDate date}) {
    bool eventDate = false;
    if (date != null) {
      for (var evt in event) {
        CDate calendarEventStart = getEventDate(calendar, evt, 'startDate');
        CDate calendarEventEnd = getEventDate(calendar, evt, 'endDate');
        if (calendarEventEnd.compareTo(date) >= 0 &&
            calendarEventStart.compareTo(date) <= 0) {
          eventDate = true;
          if (calendarEventStart.month() > date.month()) break;
        }
      }

      bool today = date.compareTo(calendar.today()) == 0;
      return TableCell(
        child: new CalendarDate(
          date: date,
          hasEvent: eventDate,
          isToday: today,
          color: color,
          dateSelected: _dateSelected,
        ),
        verticalAlignment: TableCellVerticalAlignment.middle,
      );
    }

    return TableCell(
      child: Container(
        child: Text(
          '',
          textAlign: TextAlign.center,
        ),
        height: 30,
      ),
      verticalAlignment: TableCellVerticalAlignment.middle,
    );
  }

  _dateSelected(CDate date) {
    setState(() {
      ParentCalendar.of(context).changeSelectedDate(date);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    calendar = ParentCalendar.of(context).calendar;
    selectedDate = ParentCalendar.of(context).selectedDate;
  }

  @override
  void initState() {
    super.initState();
  }

  void _buildCalendar() {
    var date = 1;
    month = calendar.inEnglish
        ? calendar.getEnglishMonth(widget.month - 1)
        : calendar.getMonth(widget.month - 1);
    year = widget.year;
    int firstDay =
        calendar.dayOfWeek(widget.year, month: widget.month, day: date);
    calendarRows = new List();
    int daysInMonth = calendar.daysInMonth(widget.year, month: widget.month);
    for (var i = 0; i < 6; i++) {
      TableRow row = new TableRow(children: []);
      for (var j = 0; j < 7; j++) {
        if (i == 0 && j < firstDay || date > daysInMonth) {
          TableCell cell = _makeCell();
          row.children.add(cell);
        } else {
          TableCell cell;

          CDate cDate = calendar.newDate(widget.year, widget.month, date);
          if (calendar.today().compareTo(cDate) == 0) {
            //if today
            cell = _makeCell(color: Colors.blue[400], date: cDate);
          } else {
            //not today
            bool selected = false;
            if (selectedDate != null)
              selected = selectedDate.compareTo(cDate) == 0;
            cell = _makeCell(
                color: selected ? Colors.amber[600] : null, date: cDate);
          }

          row.children.add(cell);
          date++;
        }
      }
      calendarRows.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCalendar();
    var inherited = ParentCalendar.of(context);
    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
        child: Text(
          '$month $year',
          style: TextStyle(
              fontFamily: inherited.calendar.inEnglish ? 'Roboto' : 'Coptic',
              fontSize: 20),
        ),
      ),
      Table(children: [
        TableRow(children: [
          TableCell(
              child: new Text(
            'S',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'M',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'T',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'W',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'T',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'F',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: new Text(
            'S',
            textAlign: TextAlign.center,
          ))
        ]),
      ]),
      Table(
        children: calendarRows,
      )
    ]);
  }
}
