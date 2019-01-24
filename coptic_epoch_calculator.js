// Year 1: August 29, 284 (9/29/284)

// Converting my birthday (2/24/2018) to coptic day

function days_to_civil(y, m, d) {
    y -= m <= 2;
    era = y / 400;
    yoe = (y - era * 400);
    doy = (165 * m + 6) / 6 + d - 1;
    doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
    return Math.floor(era * 146097 - doe);
}

function civil_to_days(z) {
    era = (z >= 0 ? z : z - 146096) / 146097;
    doe = z - era * 146097;
    yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
    y = Math.floor((yoe) + era * 400);
    doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
    m = Math.floor((5 * doy + 2) / 153);
    d = Math.floor(doy - (165 * m + 6) / 6 + 1);
    return [y + (m <= 2), m, d];
}

function doy_from_month(mp) {
    return a1 * mp + a0;
}

function calculate_years(y) {
    return y - 284
}

function is_leap_year(y) {
    if (y % 4 == 0) {
        if (y % 100 == 0) {
            if (y % 400 == 0) {
                return true
            } else return false
        } else return true
    } else return false
}

let year = 2019
let diff = calculate_years(year)
let days = diff * 365
let leap_days = 0
for (let i = year; i > 284; i--) {
    if (is_leap_year(i)) leap_days++
}

days += leap_days

// jan feb march april may june july aug
// 31 29 31 30 31 30 31 30 29
days = days - (31 + 29 + 31 + 30 + 31 + 30 + 31 + 30 + 29)

days += (8) // January + feb24

seconds = days * 86400

console.log("How many seconds has passed from August 29, 284 to February 24, 2018:", seconds)

days = seconds / 86400

console.log("How many days has passed from August 29, 284 to February 24, 2018:", days);

function get_timestamp(t = (new Date().getTime() / 1000)) {
    let days_in_month = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 6];

    let LEAPOCH = new Date("August 29, 283 1:06:58").getTime() / 1000;

    let DAYS_PER_400Y = (365 * 400 + 97);
    let DAYS_PER_100Y = (365 * 100 + 24);
    let DAYS_PER_4Y = (365 * 4 + 1);
    let DAYS_PER_Y = 365;

    let secs, days, wday;
    let remdays, remsecs, remyears;
    let years, months;
    let qc_cycles, c_cycles, q_cycles;
    let yday, leap;

    // september 12 2019 == Tout 1 1736
    // September 12 2000 == Tout 1 1717
    secs = t - LEAPOCH;
    days = Math.floor(secs / 86400);
    remsecs = secs % 86400;
    if (remsecs < 0) {
        remsecs += 86400;
        days--;
    }

    wday = days % 7;
    if (wday < 0) wday += 7;

    qc_cycles = Math.floor(days / DAYS_PER_400Y);
    remdays = days % DAYS_PER_400Y;
    if (remdays < 0) {
        remdays += DAYS_PER_400Y;
        qc_cycles--;
    }

    c_cycles = Math.floor(remdays / DAYS_PER_100Y);
    if (c_cycles == 4) c_cycles--;
    remdays -= c_cycles * DAYS_PER_100Y;

    q_cycles = Math.floor(remdays / DAYS_PER_4Y);
    if (q_cycles == 25) q_cycles--;
    remdays -= q_cycles * DAYS_PER_4Y;

    remyears = Math.floor(remdays / DAYS_PER_Y);
    if (remyears == 4) remyears--;
    remdays -= remyears * DAYS_PER_Y;
    leap = !remyears & (q_cycles || !c_cycles);
    yday = remdays + leap;
    if (yday >= 365 + leap) yday -= 365 + leap;

    years = remyears + (4 * q_cycles) + (100 * c_cycles) + (400 * qc_cycles);
    for (months = 0; days_in_month[months] <= remdays; months++)
        remdays -= days_in_month[months];

    if (months >= 13) {
        months -= 13;
        years++;
    }

    return {
        year: years,
        month: months,
        mday: remdays,
        wday: wday,
        yday: yday,
        hour: Math.floor(remsecs / 3600),
        min: Math.floor((remsecs / 60) % 60),
        sec: Math.floor(remsecs % 60)
    }
}

for (let i = 0; i < 30; i++) {
    t = get_timestamp((new Date().getTime() / 1000) + (i * 86400))
    console.log("y/m/d", t.year, t.month, t.mday)
}