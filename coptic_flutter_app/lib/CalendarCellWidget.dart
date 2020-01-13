import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CDate.dart';

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
    if (widget.hasEvent) {
      return Container(
        child: MaterialButton(
          onPressed: () {
            widget.dateSelected(widget.date);
          },
          child: Column(children: [
            Text(
              '${widget.date.day()}',
              textAlign: TextAlign.center,
            ),
            Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            )
          ]),
        ),
        color: widget.color,
        height: 30,
      );
    } else {
      return Container(
        child: MaterialButton(
          onPressed: () {
            widget.dateSelected(widget.date);
          },
          child: Text(
            '${widget.date.day()}',
            textAlign: TextAlign.center,
          ),
        ),
        color: widget.color,
        height: 30,
      );
    }
  }
}
