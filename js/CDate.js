class CDate {
    constructor(calendar, year, month, day) {
        this._calendar = calendar;
        this._year = year;
        this._month = month;
        this._day = day;
    }

    newDate(year, month, day) {
        return this._calendar.newDate((typeof year === 'undefined' || year === null ? this : year), month, day);
    }

    year(year) {
        return (arguments.length === 0 ? this._year : this.set(year, 'y'));
    }

    month(month) {
        return (arguments.length === 0 ? this._month : this.set(month, 'm'));
    }

    day(day) {
        return (arguments.length === 0 ? this._day : this.set(day, 'd'));
    }

    date(year, month, day) {
        if (!this._calendar.isValid(year, month, day)) {
            this._year = year;
            this.month = month;
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
        if (this._calendar.name !== date._calendar.name) {
            throw "Invalid comparison";
        }

        let c = (this._year !== date._year ? this._year - date._year :
            this._month !== date._month ? this.monthOfYear() - date.monthOfYear() :
            this._day - date._day);
        return (c === 0 ? 0 : (c < 0 ? -1 : 1));
    }

    calendar() {
        return this._calendar;
    }

    toJD() {
        return this._calendar.toJD(this);
    }

    fromJD() {
        return this._calendar.fromJD(jd);
    }

    toJSDate() {
        return this._calendar.toJSDate(this);
    }

    fromJSDate(jsd) {
        return this._calendar.fromJSDate(jsd);
    }
}