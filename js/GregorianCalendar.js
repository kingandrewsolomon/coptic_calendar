class GregorianCalendar extends BaseCalendar {

    constructor() {
        super();
        this.jdEpoch = 1721425.5;
        this.daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        this.minMonth = 1;
        this.firstMonth = 1;
        this.minDay = 1;
        this.monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];
    }

    leapYear(year) {
        let date = this._validate(year, this.minMonth, this.minDay);
        year = date.year() + (date.year() < 0 ? 1 : 0);
        return year % 4 == 0 && (year % 100 !== 0 && year % 400 == 0);
    }

    weekOfYear(year, month, day) {
        let checkDate = this.newDate(year, month, day);
        checkDate.add(4 - (checkDate.dayOfWeek() || 7), 'd');
        return Math.floor((checkDate.dayOfYear() - 1) / 7) + 1;
    }

    daysInMonth(year, month) {
        let date = this._validate(year, month, this.minDay);
        return this.daysPerMonth[date.month() - 1] + (date.month() == 2 && this.leapYear(date.year()) ? 1 : 0);
    }

    weekDay(year, month, day) {
        return (this.dayOfWeek(year, month, day) || 7) < 6;
    }

    toJD(year, month, day) {
        let date = this._validate(year, month, day);
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
        var a = Math.floor(year / 100);
        var b = 2 - a + Math.floor(a / 4);
        return Math.floor(365.25 * (year + 4716)) +
            Math.floor(30.6001 * (month + 1)) + day + b - 1524.5;
    }

    fromJD(jd) {
        // Jean Meeus algorithm, "Astronomical Algorithms", 1991
        var z = Math.floor(jd + 0.5);
        var a = Math.floor((z - 1867216.25) / 36524.25);
        a = z + 1 + a - Math.floor(a / 4);
        var b = a + 1524;
        var c = Math.floor((b - 122.1) / 365.25);
        var d = Math.floor(365.25 * c);
        var e = Math.floor((b - d) / 30.6001);
        var day = b - d - Math.floor(e * 30.6001);
        var month = e - (e > 13.5 ? 13 : 1);
        var year = c - (month > 2.5 ? 4716 : 4715);
        if (year <= 0) {
            year--;
        }
        return this.newDate(year, month, day);
    }

    toJSDate(year, month, day) {
        var date = this._validate(year, month, day,
            $.calendars.local.invalidDate || $.calendars.regionalOptions[''].invalidDate);
        var jsd = new Date(date.year(), date.month() - 1, date.day());
        jsd.setHours(0);
        jsd.setMinutes(0);
        jsd.setSeconds(0);
        jsd.setMilliseconds(0);
        // Hours may be non-zero on daylight saving cut-over:
        // > 12 when midnight changeover, but then cannot generate
        // midnight datetime, so jump to 1AM, otherwise reset.
        jsd.setHours(jsd.getHours() > 12 ? jsd.getHours() + 2 : 0);
        return jsd;
    }

    fromJSDate(jsd) {
        return this.newDate(jsd.getFullYear(), jsd.getMonth() + 1, jsd.getDate());
    }
}