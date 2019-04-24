class BaseCalendar {

    newDate(year, month, day) {
        if (typeof year === 'undefined' || year === null)
            return this.today();
        if (year.year) {
            day = year.day();
            month = year.month();
            year = year.year();
        }
        return new CDate(this, year, month, day);
    }

    today() {
        return this.fromJSDate(new Date());
    }

    epoch(year) {
        let date = this._validate(year, this.minMonth, this.minDay);
        return (date.year() < 0 ? this.local.epochs[0] : this.local.epochs[1]);
    }

    formatYear(year) {
        let date = this._validate(year, this.minMonth, this.minDay);
        return (date.year() < 0 ? '-' : '') + Math.abs(date.year());
    }

    monthsInYear() {
        return 12;
    }

    monthOfYear(year, month) {
        let date = this._validate(year, month, this.minDay);
        return (date.month() + this.monthsInYear(date) - this.firstMonth) % this.monthsInYear(date) + this.minMonth;
    }

    fromMonthOfYear(year, ord) {
        let m = (ord + this.firstMonth - 2 * this.minMonth) % this.monthsInYear(year) + this.minMonth;
        return m;
    }

    daysInYear(year) {
        let date = this._validate(year, this.minMonth, this.minDay);
        return (this.leapYar(date) ? 366 : 365);
    }

    dayOfYear(year, month, day) {
        let date = this._validate(year, month, day);
        return date.toJD() - this.newDate(date.year(), this.fromMonthOfYear(date.year(), this.minMonth), this.minDay).toJD() + 1;
    }

    daysInWeek() {
        return 7;
    }

    dayOfWeek(year, month, day) {
        let date = this._validate(year, month, day);
        return (Math.floor(this.toJD(date)) + 2) % this.daysInWeek();
    }

    add(date, offset, period) {
        return this._correctAdd(date, this._add(date, offset, period), offset, period);
    }

    _add(date, offset, period) {
        let d;
        if (period == 'd' || period == 'w') {
            let jd = date.toJD() + offset * (period == 'w' ? this.daysInWeek() : 1);
            d = date.calendar().fromJD(jd);
            return [d.year(), d.month(), d.day()];
        }
        try {
            let y = date.year() + (period == 'y' ? offset : 0);
            let m = date.monthOfYear() + (period == 'm' ? offset : 0);
            d = date.day();

            let resyncYearMonth = function (calendar) {
                while (m < calendar.minMonth) {
                    y--;
                    m += calendar.monthsInYear(y);
                }
                let yearMonths = calendar.monthsInYear(y);
                while (m > yearMonths - 1 + calendar.minMonth) {
                    y++;
                    m -= yearMonths;
                    yearMonths = calendar.monthsInYear(y);
                }
            };
            if (period === 'y') {
                if (date.month() != this.fromMonthOfYear(y, m)) {
                    m = this.newDate(y, date.month(), this.minDay).monthOfYear();
                }
                m = Math.min(m, this.monthsInYear(y));
                d = Math.min(d, this.daysInMonth(y, this.fromMonthOfYear(y, m)));
            } else if (period == 'm') {
                resyncYearMonth(this);
                d = Math.min(d, this.daysInMonth(y, this.fromMonthOfYear(y, m)));
            }
            let ymd = [y, this.fromMonthOfYear(y, m), d];
            return ymd;
        } catch (e) {
            throw e;
        }
    }

    _correctAdd(date, ymd, offset, period) {
        if (period == 'y' || period == 'm') {
            if (ymd[0] == 0 || (date.year() > 0) != (ymd[0] > 0)) {
                let adj = {
                    y: [1, 1, 'y'],
                    m: [1, this.monthsInYear(-1), 'm'],
                    w: [this.daysInWeek(), this.daysInYear(-1), 'd'],
                    d: [1, this.daysInYear(-1), 'd']
                } [period];
                let dir = (offset < 0 ? -1 : +1);
                ymd = this._add(date, offset * adj[0] + dir * adj[1], adj[2]);
            }
        }
        return date.date(ymd[0], ymd[1], ymd[2]);
    }

    set(date, value, period) {
        let y = (period == 'y' ? value : date.year());
        let m = (period == 'm' ? value : date.month());
        let d = (period == 'd' ? value : date.day());
        if (period == 'y' || period == 'm') {
            d = Math.min(d, this.daysInMonth(y, m));
        }
        return date.date(y, m, d);
    }

    isValid(year, month, day) {
        let valid = year !== 0;
        if (valid) {
            let date = this.newDate(year, month, this.minDay);
            valid = (month >= this.minMonth && month - this.minMonth < this.monthsInYear(date)) && (day >= this.minDay && day - this.minDay < this.daysInMonth(date));
        }
        return valid;
    }

    toJSDate(year, month, day) {
        let date = this._validate(year, month, day);
        return CopticCalendar.fromJD(this.toJD(date)).toJSDate();
    }

    _validate(year, month, day) {
        if (year.year) {
            return year;
        }
        let date = this.newDate(year, month, day);
        return date;
    }
}