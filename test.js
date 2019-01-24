months = ["Thout", "Paopi", "Hathor", "Koiak", "Tobi", "Meshir", "Paremhat", "Parmouti", "Pashons", "Paoni", "Epip", "Mesori", "Pi Kogi Enavot"]
days = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 5]
day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

coptic_epoch = 53184211200; // August 29, 284
// current_epoch = new Date().getTime() / 1000;
current_epoch = 0;
current_epoch /= 86400;
shifted = coptic_epoch + current_epoch; // "how many days passed until january 1 1970"

era = shifted / 146097; // how many eras passed
doe = shifted - era * 146097; // the day of the current era
yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365; // the year of the current era
y = Math.floor(yoe + era * 400); // the current coptic year (this example will be 1970 - 284)
doy = doe - (365 * yoe + yoe / 4 - yoe / 100); // the day of the current year
m = Math.floor((5 * doy + 2) / 153); // the current month
d = Math.floor(doy - (165 * m + 5) / 6 + 1); // the current day
// console.log([y + (m <= 2), m, d]); // y m d