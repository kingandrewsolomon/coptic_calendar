import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:coptic_flutter_app/Calendars/CDate.dart';

class CalendarDate extends StatefulWidget {
  final CDate date;
  final bool hasEvent;
  final bool isToday;
  final Color color;
  final void Function(CDate date) dateSelected;

  CalendarDate(
      {Key key,
      this.date,
      this.hasEvent,
      this.isToday,
      this.color,
      this.dateSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarDateState();
}

class CalendarDateState extends State<CalendarDate> {
  Color color;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: () {
          widget.dateSelected(widget.date);
        },
        child: Column(
          children: <Widget>[
            Text(
              '${widget.date.day()}',
              textAlign: TextAlign.center,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: widget.hasEvent ? Colors.green : Colors.transparent,
                  shape: BoxShape.circle),
            )
          ],
        ),
      ),
      color: widget.color,
      height: 30,
    );
  }
}
