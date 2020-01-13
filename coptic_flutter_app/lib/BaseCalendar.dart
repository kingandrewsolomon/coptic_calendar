import 'CDate.dart';
import 'dart:math';

abstract class BaseCalendar {
  var firstMonth;
  var minMonth;
  var minDay;
  var local;
  var inEnglish;
  List<String> monthNames;
  String name;

  newDate(year, month, day) {
    if (year == null) return this.today();
    if (year is CDate) {
      day = year.day();
      month = year.month();
      year = year.year();
    }
    return new CDate(this, year, month, day);
  }

  CDate today() {
    return this.fromJSDate(new DateTime.now());
  }

  fromJSDate(DateTime date);

  epoch(year) {
    var date = this.validate(year, this.minMonth, this.minDay);
    return (date.year() < 0 ? this.local.epochs[0] : this.local.epochs[1]);
  }

  formatYear(year) {
    var date = this.validate(year, this.minMonth, this.minDay);
    return (date.year() < 0 ? '-' : '') + date.year().abs();
  }

  num monthsInYear() {
    return 12;
  }

  monthOfYear(year, {month}) {
    var date = this.validate(year, month, this.minDay);
    return (date.month() + this.monthsInYear() - this.firstMonth) %
            this.monthsInYear() +
        this.minMonth;
  }

  fromMonthOfYear(year, ord) {
    var m = (ord + this.firstMonth - 2 * this.minMonth) % this.monthsInYear() +
        this.minMonth;
    return m;
  }

  daysInYear(year) {
    var date = this.validate(year, this.minMonth, this.minDay);
    return (this.leapYear(date) ? 366 : 365);
  }

  leapYear(year);

  dayOfYear(year, month, day) {
    var date = this.validate(year, month, day);
    return (date.toJD() - this.newDate(date.year(), 0, 1).toJD()).floor();
  }

  daysInWeek() {
    return 7;
  }

  int dayOfWeek(year, {month, day}) {
    var date = this.validate(year, month, day);
    return ((this.toJD(date)) + 2).floor() % this.daysInWeek();
  }

  toJD(year, {month, day});

  add(date, offset, period) {
    return this
        ._correctAdd(date, this._add(date, offset, period), offset, period);
  }

  _add(date, offset, period) {
    var d;
    if (period == 'd' || period == 'w') {
      var jd = date.toJD() + offset * (period == 'w' ? this.daysInWeek() : 1);
      d = date.calendar().fromJD(jd);
      return [d.year(), d.month(), d.day()];
    }
    try {
      var y = date.year() + (period == 'y' ? offset : 0);
      num m = date.monthOfYear() + (period == 'm' ? offset : 0);
      num d = date.day();

      resyncYearMonth(calendar) {
        while (m < calendar.minMonth) {
          y--;
          m += calendar.monthsInYear();
        }
        var yearMonths = calendar.monthsInYear();
        while (m > yearMonths - 1 + calendar.minMonth) {
          y++;
          m -= yearMonths;
          yearMonths = calendar.monthsInYear();
        }
      }

      if (period == 'y') {
        if (date.month() != this.fromMonthOfYear(y, m)) {
          m = this.newDate(y, date.month(), this.minDay).monthOfYear();
        }
        m = min(m, this.monthsInYear());
        d = min(d, this.daysInMonth(y, month: this.fromMonthOfYear(y, m)));
      } else if (period == 'm') {
        resyncYearMonth(this);
        d = min(d, this.daysInMonth(y, month: this.fromMonthOfYear(y, m)));
      }
      var ymd = [y, this.fromMonthOfYear(y, m), d];
      return ymd;
    } catch (e) {
      throw e;
    }
  }

  num daysInMonth(year, {month});

  _correctAdd(date, ymd, offset, period) {
    if (period == 'y' || period == 'm') {
      if (ymd[0] == 0 || (date.year() > 0) != (ymd[0] > 0)) {
        var adj = {
          'y': [1, 1, 'y'],
          'm': [1, this.monthsInYear(), 'm'],
          'w': [this.daysInWeek(), this.daysInYear(-1), 'd'],
          'd': [1, this.daysInYear(-1), 'd']
        }[period];
        var dir = (offset < 0 ? -1 : 1);
        ymd = this._add(date, offset * adj[0] + dir * adj[1], adj[2]);
      }
    }
    return date.date(ymd[0], ymd[1], ymd[2]);
  }

  set(date, value, period) {
    num y = (period == 'y' ? value : date.year());
    num m = (period == 'm' ? value : date.month());
    num d = (period == 'd' ? value : date.day());
    if (period == 'y' || period == 'm') {
      d = min(d, this.daysInMonth(y, month: m));
    }
    return date.date(y, m, d);
  }

  isValid(year, month, day) {
    var valid = year != 0;
    if (valid) {
      var date = this.newDate(year, month, this.minDay);
      valid = (month >= this.minMonth &&
              month - this.minMonth < this.monthsInYear()) &&
          (day >= this.minDay && day - this.minDay < this.daysInMonth(date));
    }
    return valid;
  }

  toJSDate(year, month, day) {
    var date = this.validate(year, month, day);
    return this.fromJD(this.toJD(date)).toJSDate();
  }

  fromJD(j);

  validate(year, month, day) {
    if (year is CDate) {
      return year;
    }
    var date = this.newDate(year, month, day);
    return date;
  }

  getMonth(int month) {
    return monthNames[month];
  }

  getEnglishMonth(int month);

  bool operator ==(o) => this.name == o.name;
  int get hashCode => this.name.codeUnitAt(0);
}
