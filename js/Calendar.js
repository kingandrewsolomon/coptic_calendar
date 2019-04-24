class Calendars {

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
}