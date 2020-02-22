import 'CustomDate.dart';

class CDate {
  var _calendar;
  int _year;
  int _month;
  int _day;

  CDate(calendar, year, month, day) {
    _calendar = calendar;
    _year = year;
    _month = month;
    _day = day;
  }

  newDate(year, month, day) {
    return _calendar.newDate((year == null ? this : year), month, day);
  }

  int year() {
    return this._year;
  }

  int month() {
    return this._month;
  }

  int day() {
    return this._day;
  }

  date(year, month, day) {
    if (!this._calendar.isValid(year, month, day)) {
      this._year = year;
      this._month = month;
      this._day = day;
      return this;
    }
  }

  leapYear() {
    return this._calendar.leapYear(this);
  }

  epoch() {
    return this._calendar.epoch(this);
  }

  monthOfYear() {
    return this._calendar.monthOfYear(this);
  }

  weekOfYear() {
    return this._calendar.weekOfYear(this);
  }

  daysInYear() {
    return this._calendar.daysInYear(this);
  }

  dayOfYear() {
    return this._calendar.dayOfYear(this);
  }

  daysInMonth() {
    return this._calendar.daysInMonth(this);
  }

  dayOfWeek() {
    return this._calendar.dayOfWeek(this);
  }

  weekDay() {
    return this._calendar.weekDay(this);
  }

  add(offset, period) {
    return this._calendar.add(this, offset, period);
  }

  set(value, period) {
    return this._calendar.set(this, value, period);
  }

  compareTo(date) {
    if (this.calendar != date.calendar) {
      throw "Invalid comparison";
    }

    var c = (this._year != date._year
        ? this._year - date._year
        : this._month != date._month
            ? this.monthOfYear() - date.monthOfYear()
            : this._day - date._day);
    return (c == 0 ? 0 : (c < 0 ? -1 : 1));
  }

  get calendar => _calendar;

  toJD() {
    return this._calendar.toJD(this);
  }

  fromJD(jd) {
    return this._calendar.fromJD(jd);
  }

  toCustomDate() {
    return this._calendar.toCustomDate(this);
  }

  fromCustomDate(CustomDate cd) {
    return this._calendar.fromCustomDate(cd);
  }
}
