import 'package:coptic_flutter_app/Widgets/CalendarWidget.dart';
import 'package:coptic_flutter_app/Widgets/EventsListWidget.dart';

import 'package:coptic_flutter_app/Calendars/BaseCalendar.dart';
import 'package:coptic_flutter_app/Calendars/CopticCalendar.dart';
import 'package:coptic_flutter_app/Calendars/GregorianCalendar.dart';
import 'package:coptic_flutter_app/ParentCalendar.dart';
import 'package:coptic_flutter_app/Calendars/CDate.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ParentCalendar(
        child: MyHomePage(title: 'Coptic Calendar'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  BaseCalendar calendar;
  CDate selectedDate;
  CopticCalendar coptic;
  GregorianCalendar gregorian;
  bool calendarState;
  Calendar calendarWidget;
  int year;
  int currentMonth;
  List<Widget> eventsList;

  previous(BaseCalendar calendar) {
    setState(() {
      if (calendar == CopticCalendar()) {
        year = (currentMonth == 1) ? year - 1 : year;
        currentMonth = (currentMonth == 1) ? 13 : currentMonth - 1;
      } else {
        year = (currentMonth == 1) ? year - 1 : year;
        currentMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
      }
    });
  }

  toToday() {
    setState(() {
      CDate today = ParentCalendar.of(context).calendar.today();
      currentMonth = today.month();
      year = today.year();

      ParentCalendar.of(context).changeSelectedDate(today);
    });
  }

  next(BaseCalendar calendar) {
    setState(() {
      if (calendar == CopticCalendar()) {
        year = (currentMonth == 13) ? year + 1 : year;
        currentMonth = currentMonth + 1 == 14 ? 1 : currentMonth + 1;
      } else {
        year = (currentMonth == 12) ? year + 1 : year;
        currentMonth = currentMonth + 1 == 13 ? 1 : currentMonth + 1;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calendar = ParentCalendar.of(context).calendar;
    selectedDate = ParentCalendar.of(context).selectedDate;

    currentMonth = selectedDate.month();
    year = selectedDate.year();
  }

  @override
  void initState() {
    super.initState();
    calendarState = true;
    coptic = new CopticCalendar();
    gregorian = new GregorianCalendar();
  }

  String gregorianDate() {
    CDate sD = ParentCalendar.of(context).selectedDate ?? calendar.today();
    CDate gDate = gregorian.convert(sD);
    String month = gregorian.getMonth(gDate.month() - 1);
    int day = gDate.day();
    int year = gDate.year();
    return '$month $day, $year';
  }

  String copticDate() {
    CDate sD = ParentCalendar.of(context).selectedDate;
    CDate cDate = coptic.convert(sD);
    String month = coptic.getEnglishMonth(cDate.month() - 1);
    int day = cDate.day();
    int year = cDate.year();
    return '$month $day, $year';
  }

  @override
  Widget build(BuildContext context) {
    var inherited = ParentCalendar.of(context);
    selectedDate = inherited.selectedDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Calendar(
                  month: currentMonth,
                  year: year,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        child: Text('<'),
                        onPressed: () => previous(inherited.calendar),
                      ),
                      MaterialButton(
                        child: Text('Today'),
                        onPressed: toToday,
                      ),
                      MaterialButton(
                        child: Text('>'),
                        onPressed: () => next(inherited.calendar),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  margin: EdgeInsets.only(bottom: 1),
                ),
                Text(inherited.calendar == CopticCalendar()
                    ? gregorianDate()
                    : copticDate()),
                EventsList(),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                title: Text("Calendar Language"),
                trailing: inherited.calendar.inEnglish
                    ? Text("English")
                    : Text("Coptic"),
              ),
              onTap: () {
                setState(() {
                  if (inherited.calendar.inEnglish)
                    inherited.calendar.inEnglish = false;
                  else
                    inherited.calendar.inEnglish = true;
                });

                // Logic for changing calendar: Works pretty well //
                /*if (inherited.calendar == CopticCalendar()) {
                  inherited.changeCalendar(gregorian);
                  inherited.changeSelectedDate(gregorian.today());
                } else {
                  inherited.changeCalendar(coptic);
                  inherited.changeSelectedDate(coptic.today());
                }*/
                ////////////////////////////////////////////////////
              },
            ),
            GestureDetector(
              child: ListTile(
                  title: Text("Calendar Type"),
                  trailing: Icon(Icons.arrow_forward_ios)),
              onTap: () {
                var alert = AlertDialog(
                    title: Text('Change Calendar Type'),
                    content: Container(
                      width: double.maxFinite,
                      height: 150,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Coptic'),
                            trailing: Visibility(
                              child: Icon(Icons.check),
                              visible: inherited.calendar == CopticCalendar(),
                            ),
                            onTap: () {
                              inherited.changeCalendar(coptic);
                              inherited.changeSelectedDate(
                                  coptic.convert(selectedDate));
                            },
                          ),
                          ListTile(
                            title: Text('Gregorian'),
                            trailing: Visibility(
                              child: Icon(Icons.check),
                              visible:
                                  inherited.calendar == GregorianCalendar(),
                            ),
                            onTap: () {
                              inherited.changeCalendar(gregorian);
                              inherited.changeSelectedDate(
                                  gregorian.convert(selectedDate));
                            },
                          ),
                        ],
                      ),
                    ));
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
