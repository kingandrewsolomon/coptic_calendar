today = get_timestamp();
currentMonth = today.month;
currentYear = today.year;
selectYear = document.getElementById("year");
selectMonth = document.getElementById("month");

months = ["ⲑⲱⲩⲧ", "ⲡⲁⲟⲡⲓ", "ⲁⲑⲱⲣ", "ⲭⲟⲓⲁⲭ", "ⲧⲱⲃⲓ", "ⲙⲉϣⲓⲣ", "ⲡⲁⲣⲉⲙⲝⲁⲧ", "ⲡⲁⲣⲙⲟⲩⲑⲓ", "ⲡⲁϣⲟⲛⲥ", "ⲡⲁⲟⲛⲓ", "ⲉⲡⲓⲡ", "ⲙⲉⲥⲱⲣⲓ", "ⲡⲓⲕⲟⲯϫⲓ ⲛ̀ⲁ̀ⲃⲟⲧ"];
days_in_month = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 6];

monthAndYear = document.getElementById("monthAndYear");
showCalendar(currentMonth, currentYear);

displayTime();
setInterval(displayTime, 1000);

function displayTime() {
    let time = document.getElementById("Time");
    let timestamp = get_timestamp();
    let hr = ((timestamp.hour % 12) + 1);
    let ampm = timestamp.hour < 12 ? "am" : "pm";
    hr = hr < 10 ? "0" + hr : hr;
    let min = timestamp.min < 10 ? "0" + timestamp.min : timestamp.min;
    let sec = timestamp.sec < 10 ? "0" + timestamp.sec : timestamp.sec;
    time.innerHTML = hr + ":" + min + ":" + sec + " " + ampm;
}

function next() {
    currentYear = (currentMonth === 12) ? currentYear + 1 : currentYear;
    currentMonth = (currentMonth + 1) % 13;
    showCalendar(currentMonth, currentYear);
}

function previous() {
    currentYear = (currentMonth === 0) ? currentYear - 1 : currentYear;
    currentMonth = (currentMonth === 0) ? 12 : currentMonth - 1;
    showCalendar(currentMonth, currentYear);
}

function jump() {
    currentYear = parseInt(selectYear.value);
    currentMonth = parseInt(selectMonth.value);
    showCalendar(currentMonth, currentYear);
}

function showCalendar(month, year) {

    let firstDay = get_timestamp(year * month * 1000).wday;

    tbl = document.getElementById("calendar-body"); // body of the calendar

    // clearing all previous cells
    tbl.innerHTML = "";

    // filing data about month and in the page via DOM.
    monthAndYear.innerHTML = months[month] + " " + year;
    console.log(months[month], year);
    selectYear.value = year;
    selectMonth.value = month;

    // creating all cells
    let date = 1;
    for (let i = 0; i < 6; i++) {
        // creates a table row
        let row = document.createElement("tr");

        //creating individual cells, filing them up with data.
        for (let j = 0; j < 7; j++) {
            if (i === 0 && j < firstDay) {
                cell = document.createElement("td");
                cellText = document.createTextNode("");
                cell.appendChild(cellText);
                row.appendChild(cell);
            } else if (date > daysInMonth(month, year)) {
                break;
            } else {
                cell = document.createElement("td");
                cellText = document.createTextNode(date);
                if (date === today.mday && year === today.year && month === today.month) {
                    cell.classList.add("bg-info");
                } // color today's date
                cell.appendChild(cellText);
                row.appendChild(cell);
                date++;
            }


        }

        tbl.appendChild(row); // appending each row into calendar body.
    }

}

function daysInMonth(iMonth, iYear) {
    if (iMonth == 12)
        if (is_leap_year(iYear))
            return 6;
        else
            return 5;
    return 30;
}