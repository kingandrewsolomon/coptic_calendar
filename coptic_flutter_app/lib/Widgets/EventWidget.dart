import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  final String title;
  final String description;

  Event({Key key, this.title, this.description}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventState();
}

class EventState extends State<Event> {
  Duration _duration = new Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    Container container = new Container(
      child: Column(children: [Text(widget.title), Text(widget.description)]),
      height: 300,
    );
    return AnimatedContainer(
      duration: _duration,
      child: container,
    );
  }
}
