// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:coptic_flutter_app/Calendars/CDate.dart';
import 'package:coptic_flutter_app/Calendars/CopticCalendar.dart';
import 'package:coptic_flutter_app/Calendars/GregorianCalendar.dart';
import 'package:coptic_flutter_app/Calendars/CustomDate.dart';
import 'package:coptic_flutter_app/synax.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Conversion of Gregorian to Coptic', () {
    CDate gDate = GregorianCalendar().today();
    CDate cDate = CopticCalendar().convert(gDate);
    int month = gDate.month();
    int day = gDate.day();
    int year = gDate.year();

    print("$month $day $year");

    month = cDate.month();
    day = cDate.day();
    year = cDate.year();

    print("$month $day $year ${cDate.toJD()}");
    expect(gDate.toJD(), cDate.toJD());
  });

  test('Conversion of Coptic to Gregorian', () {
    CDate cDate = CopticCalendar().today();
    CDate gDate = GregorianCalendar().convert(cDate);
    int month = cDate.month();
    int day = cDate.day();
    int year = cDate.year();

    print("$month $day $year");

    month = gDate.month();
    day = gDate.day();
    year = gDate.year();

    print("$month $day $year ${cDate.toJD()}");
    expect(gDate.toJD(), cDate.toJD());
  });

  test('Correct JD', () {
    CDate c = GregorianCalendar().today();
    print(c.year());
    print(GregorianCalendar().toCustomDate(c.year(), c.month(), c.day()));
    print(CopticCalendar().toCustomDate(c.year(), c.month(), c.day()));
  });

  test('mini test', () {
    var gregorian = new GregorianCalendar();
    var gdate = gregorian.fromCustomDate(new CustomDate(2020, 1, 1));

    var coptic = new CopticCalendar();
    var cdate = coptic.fromCustomDate(new CustomDate(2020, 1, 1));
    print(
        '${gdate.day()}, ${gregorian.monthNames[gdate.month() - 1]}, ${gdate.year()}');
    print(gregorian.toJD(gdate));
    print(
        '${cdate.day()}, ${coptic.monthNames[cdate.month()]}, ${cdate.year()}');
    print(coptic.toJD(cdate));
  });

  test('custom date', () {
    var custom = new CustomDate(2020, 1, 11);
    print("${custom.day} ${custom.month} ${custom.year}");
    expect(custom.day, 11);
    expect(custom.month, 1);
    expect(custom.year, 2020);

    var date = new DateTime.now();
    var today = new CustomDate.now();
    expect(today.day, date.day);
    expect(today.weekday, date.weekday - 1);
    expect(today.month, date.month - 1);
    expect(today.year, date.year);
    expect(today.hour, date.hour);
  });

  test('julian date', () {
    CopticCalendar cc = new CopticCalendar();
    GregorianCalendar gc = new GregorianCalendar();
    var date = gc.today();
    CDate firstDay = new CDate(gc, gc.today().year(), 1, 1);
    var n = (date.toJD() - firstDay.toJD()).floor();
    print(n);
    print(synax[n]);

    firstDay = new CDate(cc, cc.today().year(), 1, 1);
    n = (date.toJD() - firstDay.toJD()).floor();
    print(n);
    print(synax[n]);
  });
}
