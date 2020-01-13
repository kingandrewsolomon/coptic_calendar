import 'package:coptic_flutter_app/BaseCalendar.dart';
import 'package:coptic_flutter_app/CopticCalendar.dart';
import 'package:flutter/cupertino.dart';

import 'CDate.dart';

class ParentCalendar extends StatefulWidget {
  final Widget child;
  final BaseCalendar calendar = new CopticCalendar();
  final CDate selectedDate = new CopticCalendar().today();

  ParentCalendar({
    Key key,
    this.child,
  }) : super(key: key);

  static ParentCalendarState of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<InheritedParentCalendar>())
        .data;
  }

  @override
  State<StatefulWidget> createState() => new ParentCalendarState();
}

class ParentCalendarState extends State<ParentCalendar> {
  BaseCalendar calendar = new CopticCalendar();
  CDate selectedDate = new CopticCalendar().today();

  changeSelectedDate(CDate newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  changeCalendar(BaseCalendar newCalendar) {
    setState(() {
      calendar = newCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedParentCalendar(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedParentCalendar extends InheritedWidget {
  final ParentCalendarState data;

  InheritedParentCalendar({
    Key key,
    this.data,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
