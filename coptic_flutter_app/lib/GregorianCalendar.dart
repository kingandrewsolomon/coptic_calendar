import 'package:coptic_flutter_app/BaseCalendar.dart';
import 'CDate.dart';
import 'dart:core';

class GregorianCalendar extends BaseCalendar {
  double jdEpoch;
  List daysPerMonth;
  List<String> monthNames;

  GregorianCalendar() {
    name = 'Gregorian';
    inEnglish = true;
    jdEpoch = 1721425.5;
    daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    minMonth = 1;
    firstMonth = 1;
    minDay = 1;
    monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  leapYear(year) {
    var date = this.validate(year, this.minMonth, this.minDay);
    year = date.year() + (date.year() < 0 ? 1 : 0);
    return year % 4 == 0 && (year % 100 != 0 && year % 400 == 0);
  }

  weekOfYear(year, month, day) {
    var checkDate = this.newDate(year, month, day);
    checkDate.add(
        4 - (checkDate.dayOfWeek() == 0 ? 7 : checkDate.dayOfWeek()), 'd');
    return ((checkDate.dayOfYear() - 1) / 7).floor() + 1;
  }

  daysInMonth(year, {month}) {
    var date = this.validate(year, month, this.minDay);
    return this.daysPerMonth[date.month()] +
        (date.month() == 2 && this.leapYear(date.year()) ? 1 : 0);
  }

  weekDay(year, month, day) {
    var wday = this.dayOfWeek(year, month: month, day: day);
    return (wday == 0 ? 7 : wday) < 6;
  }

  toJD(year, {month, day}) {
    var date = this.validate(year, month, day);
    year = date.year();
    month = date.month();
    day = date.day();
    if (year < 0) {
      year++;
    }
    if (month < 3) {
      month += 12;
      year--;
    }
    var a = (year / 100).floor();
    var b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;
  }

  fromJD(jd) {
    var z = (jd + 0.5).floor();
    var a = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + a - (a / 4).floor();
    var b = a + 1524;
    var c = ((b - 122.1) / 365.25).floor();
    var d = (365.25 * c).floor();
    var e = ((b - d) / 30.6001).floor();
    var day = b - d - (e * 30.6001).floor();
    var month = e - (e > 13.5 ? 13 : 1);
    var year = c - (month > 2.5 ? 4716 : 4715);
    if (year <= 0) {
      year--;
    }
    return this.newDate(year, month, day);
  }

  DateTime toJSDate(year, month, day) {
    var date = this.validate(year, month, day);
    print(date.month());
    var jsd =
        new DateTime(date.year(), date.month(), date.day(), 0, 0, 0, 0, 0);
    return jsd;
  }

  CDate fromJSDate(jsd) {
    return this.newDate(jsd.year, jsd.month, jsd.day);
  }

  getEnglishMonth(int month) {
    return getMonth(month);
  }
}
