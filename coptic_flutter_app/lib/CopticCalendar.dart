import 'package:coptic_flutter_app/BaseCalendar.dart';
import 'package:coptic_flutter_app/CDate.dart';
import 'GregorianCalendar.dart';

class CopticCalendar extends BaseCalendar {
  var gregorian;
  double jdEpoch;
  List daysPerMonth;
  List<String> monthNames;
  List<String> englishMonthNames;

  CopticCalendar() {
    gregorian = new GregorianCalendar();
    name = 'Coptic';
    inEnglish = false;
    jdEpoch = 1825029.5;
    daysPerMonth = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 5];
    minMonth = 1;
    firstMonth = 1;
    minDay = 1;
    monthNames = [
      ":wout",
      "Paopi",
      "A;or",
      "<;oiak",
      "Twbi",
      "Mesir",
      "Paremhat",
      "Varmo;i",
      "Pasanc",
      "Pawni",
      "Epyp",
      "Mecwri",
      "Pikouji nabot"
    ];
    englishMonthNames = [
      "Thout",
      "Paopi",
      "Hathor",
      "Koiak",
      "Tobi",
      "Meshir",
      "Paremhat",
      "Parmouti",
      "Pashons",
      "Paoni",
      "Epip",
      "Mesori",
      "Pi Kogi Enavot"
    ];
  }

  leapYear(year) {
    var date = this.validate(year, this.minMonth, this.minDay);
    year = date.year() + (date.year() < 0 ? 1 : 0);
    return year % 4 == 3 || year % 4 == -1;
  }

  monthsInYear() {
    return 13;
  }

  weekOfYear(year, month, day) {
    var checkDate = this.newDate(year, month, day);
    checkDate.add(-checkDate.dayOfWeek(), 'd');
    return ((checkDate.dayOfYear() - 1) / 7).floor() + 1;
  }

  daysInMonth(year, {month}) {
    var date = this.validate(year, month, 1);
    return this.daysPerMonth[date.month()] +
        (date.month() == 13 && this.leapYear(date.year()) ? 1 : 0);
  }

  weekDay(year, month, day) {
    var wday = this.dayOfWeek(year, month: month, day: day);
    return (wday == 0 ? 7 : wday) < 6;
  }

  toJD(year, {month, day}) {
    var date = this.validate(year, month, day);
    year = date.year();
    if (year < 0) {
      year++;
    }
    return date.day() +
        (date.month()) * 30 +
        (year - 1) * 365 +
        (year / 4).floor() +
        this.jdEpoch -
        1;
  }

  CDate fromJD(jd) {
    var c = jd.floor() + 0.5 - this.jdEpoch;
    int year = ((c - ((c + 366) / 1461).floor()) / 365).floor() + 1;
    if (year <= 0) {
      year--;
    }

    c = jd.floor() + 0.5 - this.newDate(year, 1, 1).toJD();
    int month = (c / 30).floor() + 1;
    int day = (c - (month - 1) * 30).floor() + 1;
    return this.newDate(year, month, day);
  }

  CDate fromJSDate(jsd) {
    return this.fromJD(this.gregorian.fromJSDate(jsd).toJD());
  }

  String getMonth(int month) {
    return monthNames[month];
  }

  String getEnglishMonth(int month) {
    return englishMonthNames[month];
  }
}
