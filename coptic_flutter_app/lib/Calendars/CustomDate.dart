class CustomDate implements Comparable<CustomDate> {
  static const int monday = 0;
  static const int tuesday = 1;
  static const int wednesday = 2;
  static const int thursday = 3;
  static const int friday = 4;
  static const int saturday = 5;
  static const int sunday = 6;
  static const int daysPerWeek = 7;

  static const int january = 0;
  static const int february = 1;
  static const int march = 2;
  static const int april = 3;
  static const int may = 4;
  static const int june = 5;
  static const int july = 6;
  static const int august = 7;
  static const int september = 8;
  static const int october = 9;
  static const int november = 10;
  static const int december = 11;
  static const int monthsPerYear = 12;

  final int _value;

  final bool isUtc;

  static const int _maxMillisecondsSinceEpoch = 8640000000000000;

  static const List<List<int>> _DAYS_UNTIL_MONTH = const [
    const [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334],
    const [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]
  ];

  static Map<String, int> timeZones = {
    "HST": -10 * 60 * 60,
    "AKST": -9 * 60 * 60,
    "PST": -8 * 60 * 60,
    "MST": -7 * 60 * 60,
    "CST": -6 * 60 * 60,
    "EST": -5 * 60 * 60
  };

  static const _MICROSECOND_INDEX = 0;
  static const _MILLISECOND_INDEX = 1;
  static const _SECOND_INDEX = 2;
  static const _MINUTE_INDEX = 3;
  static const _HOUR_INDEX = 4;
  static const _DAY_INDEX = 5;
  static const _WEEKDAY_INDEX = 6;
  static const _MONTH_INDEX = 7;
  static const _YEAR_INDEX = 8;

  List __parts;

  get _parts {
    __parts ??= _computeUpperPart(_localDateInUtcMicros);
    return __parts;
  }

  CustomDate(int year,
      [int month = 0,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : this._internal(year, month, day, hour, minute, second, millisecond,
            microsecond, false);

  CustomDate.utc(int year,
      [int month = 0,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : this._internal(year, month, day, hour, minute, second, millisecond,
            microsecond, true);

  CustomDate.now() : this._now();

  CustomDate._internal(int year, int month, int day, int hour, int minute,
      int second, int millisecond, int microsecond, bool isUtc)
      : this.isUtc = isUtc,
        this._value = _brokenDownDateToValue(year, month, day, hour, minute,
            second, millisecond, microsecond, isUtc) {
    if (_value == null) throw new ArgumentError();
    if (isUtc == null) throw new ArgumentError();
  }

  static int _brokenDownDateToValue(int year, int month, int day, int hour,
      int minute, int second, int millisecond, int microsecond, bool isUtc) {
    if (month >= 12) {
      year += month ~/ 12;
      month = month % 12;
    } else if (month < 0) {
      int realMonth = month % 12;
      year += (month - realMonth) ~/ 12;
      month = realMonth;
    }

    int days = day;
    days += _DAYS_UNTIL_MONTH[_isLeapYear(year) ? 1 : 0][month];
    days += _dayFromYear(year);
    int microsecondsSinceEpoch = days * Duration.microsecondsPerDay +
        hour * Duration.microsecondsPerHour +
        minute * Duration.microsecondsPerMinute +
        second * Duration.microsecondsPerSecond +
        millisecond * Duration.microsecondsPerMillisecond +
        microsecond;

    if (microsecondsSinceEpoch.abs() >
        _maxMillisecondsSinceEpoch * 1000 + Duration.microsecondsPerDay) {
      return null;
    }

    if (!isUtc) {
      int adjustment =
          _localTimeZoneAdjustmentInSeconds() * Duration.microsecondsPerSecond;

      adjustment += Duration.microsecondsPerHour;
      int zoneOffset =
          _timeZoneOffsetInSeconds(microsecondsSinceEpoch - adjustment);

      microsecondsSinceEpoch -= zoneOffset * Duration.microsecondsPerSecond;
    }

    if (microsecondsSinceEpoch.abs() >
        _maxMillisecondsSinceEpoch * Duration.microsecondsPerMillisecond) {
      return null;
    }
    return microsecondsSinceEpoch;
  }

  static bool _isLeapYear(y) {
    return (y % 4 == 0) && ((y % 16 == 0) || (y % 100 != 0));
  }

  static int _flooredDivision(int a, int b) {
    return (a - (a < 0 ? b - 1 : 0)) ~/ b;
  }

  static int _dayFromYear(int year) {
    return 365 * (year - 1970) +
        _flooredDivision(year - 1969, 4) -
        _flooredDivision(year - 1901, 100) +
        _flooredDivision(year - 1691, 400);
  }

  CustomDate._now()
      : isUtc = false,
        _value = _getCurrentMicros();

  int compareTo(CustomDate other) =>
      _value.compareTo(other.microsecondsSinceEpoch);

  int get hashCode => (_value ^ (_value >> 30)) & 0x3FFFFFFF;

  bool operator ==(dynamic other) =>
      other is CustomDate &&
      _value == other.microsecondsSinceEpoch &&
      isUtc == other.isUtc;

  CustomDate toLocal() {
    if (isUtc) {
      return CustomDate._withValue(_value, isUtc: false);
    }
    return this;
  }

  CustomDate._withValue(this._value, {this.isUtc}) {
    if (millisecondsSinceEpoch.abs() > _maxMillisecondsSinceEpoch ||
        (millisecondsSinceEpoch.abs() == _maxMillisecondsSinceEpoch &&
            microsecond != 0)) {
      throw ArgumentError(
          "Custom Date is outside valid range: $millisecondsSinceEpoch");
    }
  }

  static int _getCurrentMicros() => DateTime.now().microsecondsSinceEpoch;

  static int _localTimeZoneAdjustmentInSeconds() {
    return timeZones["PST"];
  }

  static int _timeZoneOffsetInSecondsForClampedSeconds(int seconds) {
    return timeZones["PST"];
  }

  static String _timeZoneNameForClampedSeconds(int seconds) {
    return timeZones.keys
        .firstWhere((k) => timeZones[k] == seconds, orElse: () => null);
  }

  int get _localDateInUtcMicros {
    int micros = _value;
    if (isUtc) return micros;
    int offset =
        _timeZoneOffsetInSeconds(micros) * Duration.microsecondsPerSecond;
    return micros + offset;
  }

  static int _yearsFromSecondsSinceEpoch(int secondsSinceEpoch) {
    const int DAYS_IN_4_YEARS = 4 * 365 + 1;
    const int DAYS_IN_100_YEARS = 25 * DAYS_IN_4_YEARS - 1;
    const int DAYS_YEAR_2098 = DAYS_IN_100_YEARS + 6 * DAYS_IN_4_YEARS;

    int days = secondsSinceEpoch ~/ Duration.secondsPerDay;
    if (days > 0 && days < DAYS_YEAR_2098) {
      return 1970 + (4 * days + 2) ~/ DAYS_IN_4_YEARS;
    }
    int micros = secondsSinceEpoch * Duration.microsecondsPerSecond;
    return _computeUpperPart(micros)[_YEAR_INDEX];
  }

  static int _weekDay(y) {
    return (_dayFromYear(y) + 4) % 7;
  }

  static int _equivalentYear(int year) {
    int recentYear = (_isLeapYear(year) ? 1956 : 1967) + (_weekDay(year) * 12);
    return 2008 + (recentYear - 2008) % 28;
  }

  static int _equivalentSeconds(int microsecondsSinceEpoch) {
    const int CUT_OFF_SECONDS = 0x7FFFFFFF;
    int secondsSinceEpoch = _flooredDivision(
        microsecondsSinceEpoch, Duration.microsecondsPerSecond);

    if (secondsSinceEpoch.abs() > CUT_OFF_SECONDS) {
      int year = _yearsFromSecondsSinceEpoch(secondsSinceEpoch);
      int days = _dayFromYear(year);
      int equivalentYear = _equivalentYear(year);
      int equivalentDays = _dayFromYear(equivalentYear);
      int diffDays = equivalentDays - days;
      secondsSinceEpoch += diffDays * Duration.secondsPerDay;
    }
    return secondsSinceEpoch;
  }

  // Returns the time zones offset in seconds of the given seconds
  static int _timeZoneOffsetInSeconds(int microsecondsSinceEpoch) {
    int equivalentSeconds = _equivalentSeconds(microsecondsSinceEpoch);
    return _timeZoneOffsetInSecondsForClampedSeconds(equivalentSeconds);
  }

  static String _timeZoneName(int microsecondsSinceEpoch) {
    int equivalentSeconds = _equivalentSeconds(microsecondsSinceEpoch);
    return _timeZoneNameForClampedSeconds(equivalentSeconds);
  }

  static List _computeUpperPart(int localMicros) {
    const int DAYS_IN_4_YEARS = 4 * 365 + 1; // 1461
    const int DAYS_IN_100_YEARS = 25 * DAYS_IN_4_YEARS - 1; // 36524
    const int DAYS_IN_400_YEARS = 4 * DAYS_IN_100_YEARS + 1; // 146907
    const int DAYS_1970_TO_2000 = 30 * 365 + 7;
    const int DAYS_OFFSET =
        1000 * DAYS_IN_400_YEARS + 5 * DAYS_IN_400_YEARS - DAYS_1970_TO_2000;
    const int YEARS_OFFSET = 400000;

    int resultYear = 0;
    int resultMonth = 0;
    int resultDay = 0;

    final int daysSince1970 =
        _flooredDivision(localMicros, Duration.microsecondsPerDay);
    int days = daysSince1970;
    days += DAYS_OFFSET;
    resultYear = 400 * (days ~/ DAYS_IN_400_YEARS) - YEARS_OFFSET;
    days = days.remainder(DAYS_IN_400_YEARS);
    days--;
    int yd1 = days ~/ DAYS_IN_100_YEARS;
    days = days.remainder(DAYS_IN_100_YEARS);
    resultYear += 100 * yd1;
    days++;
    int yd2 = days ~/ DAYS_IN_4_YEARS;
    days = days.remainder(DAYS_IN_4_YEARS);
    resultYear += 4 * yd2;
    days--;
    int yd3 = days ~/ 365;
    days = days.remainder(365);
    resultYear += yd3;

    bool isLeap = (yd1 == 0 || yd2 != 0) && yd3 == 0;
    if (isLeap) days++;

    List<int> daysUntilMonth = _DAYS_UNTIL_MONTH[isLeap ? 1 : 0];
    for (resultMonth = 11; daysUntilMonth[resultMonth] > days; resultMonth--) {}
    resultDay = days - daysUntilMonth[resultMonth] + 1;

    int resultMicrosecond = localMicros % Duration.microsecondsPerMillisecond;
    int resultMillisecond =
        _flooredDivision(localMicros, Duration.microsecondsPerMillisecond) %
            Duration.millisecondsPerSecond;
    int resultSecond =
        _flooredDivision(localMicros, Duration.microsecondsPerSecond) %
            Duration.secondsPerMinute;

    int resultMinute =
        _flooredDivision(localMicros, Duration.microsecondsPerMinute);
    resultMinute %= Duration.minutesPerHour;

    int resultHour =
        _flooredDivision(localMicros, Duration.microsecondsPerHour);
    resultHour %= Duration.hoursPerDay;

    int resultWeekday =
        ((daysSince1970 + thursday - monday) % daysPerWeek) + monday;

    List list = new List(_YEAR_INDEX + 1);
    list[_MICROSECOND_INDEX] = resultMicrosecond;
    list[_MILLISECOND_INDEX] = resultMillisecond;
    list[_SECOND_INDEX] = resultSecond;
    list[_MINUTE_INDEX] = resultMinute;
    list[_HOUR_INDEX] = resultHour;
    list[_DAY_INDEX] = resultDay;
    list[_WEEKDAY_INDEX] = resultWeekday;
    list[_MONTH_INDEX] = resultMonth;
    list[_YEAR_INDEX] = resultYear;
    return list;
  }

  int get millisecondsSinceEpoch =>
      _value ~/ Duration.microsecondsPerMillisecond;
  int get microsecondsSinceEpoch => _value;

  int get year => _parts[_YEAR_INDEX];
  int get month => _parts[_MONTH_INDEX];
  int get weekday => _parts[_WEEKDAY_INDEX];
  int get day => _parts[_DAY_INDEX];
  int get hour => _parts[_HOUR_INDEX];
  int get minute => _parts[_MINUTE_INDEX];
  int get second => _parts[_SECOND_INDEX];
  int get millisecond => _parts[_MILLISECOND_INDEX];
  int get microsecond => _parts[_MICROSECOND_INDEX];
}
