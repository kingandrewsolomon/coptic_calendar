class CopticCalendar extends BaseCalendar {

    constructor() {
        super();
        this.gregorian = new GregorianCalendar();
        this.jdEpoch = 1825029.5;
        this.daysPerMonth = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 5];
        this.minMonth = 1;
        this.firstMonth = 1;
        this.minDay = 1;
        this.monthNames = [":wout", "Paopi", "A;or", "&lt;oiak", "Twbi", "Mesir", "Paremhat", "Varmo;i", "Pasanc", "Pawni", "Epyp", "Mecwri", "Pikouji nabot"];
    }

    leapYear(year) {
        let date = this._validate(year, this.minMonth, this.minDay);
        year = date.year() + (date.year() < 0 ? 1 : 0);
        return year % 4 === 3 || year % 4 === -1;
    }

    monthsInYear() {
        return 13;
    }

    weekOfYear(year, month, day) {
        let checkDate = this.newDate(year, month, day);
        checkDate.add(-checkDate.dayOfWeek(), 'd');
        return Math.floor((checkDate.dayOfYear() - 1) / 7) + 1;
    }

    daysInMonth(year, month) {
        let date = this._validate(year, month);
        return this.daysPerMonth[date.month() - 1] + (date.month() === 13 && this.leapYear(date.year()) ? 1 : 0);
    }

    weekDay(year, month, day) {
        return (this.dayOfWeek(year, month, day) || 7) < 6;
    }

    toJD(year, month, day) {
        let date = this._validate(year, month, day);
        year = date.year();
        if (year < 0) {
            year++;
        }
        return date.day() + (date.month() - 1) * 30 + (year - 1) * 365 + Math.floor(year / 4) + this.jdEpoch - 1;
    }

    fromJD(jd) {
        let c = Math.floor(jd) + 0.5 - this.jdEpoch;
        let year = Math.floor((c - Math.floor((c + 366) / 1461)) / 365) + 1;
        if (year <= 0) {
            year--;
        }
        c = Math.floor(jd) + 0.5 - this.newDate(year, 1, 1).toJD();
        let month = Math.floor(c / 30) + 1;
        let day = c - (month - 1) * 30 + 1;
        return this.newDate(year, month, day);
    }

    fromJSDate(jsd) {
        return this.fromJD(this.gregorian.fromJSDate(jsd).toJD());
    }
}