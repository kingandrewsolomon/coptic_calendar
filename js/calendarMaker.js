let coptic = new CopticCalendar();
today = coptic.today();
currentMonth = today.month();
currentYear = today.year();
let isHidden = false;

monthAndYear = document.getElementById("monthAndYear");
showCalendar(currentMonth, currentYear);

displayTime();
setInterval(displayTime, 100);

var modal = document.getElementById('myModal');
modal.addEventListener('click', function () {
    let title = document.getElementById("events");
    title.innerHTML = '';
});

function displayTime() {
    let time = document.getElementById("Time");
    let currentTime = new Date();
    let hr = currentTime.getHours();
    let min = currentTime.getMinutes();
    let sec = currentTime.getSeconds();
    // let ampm = hr.hour < 12 ? "am" : "pm";
    hr = hr < 10 ? "0" + hr : hr;
    min = min < 10 ? "0" + min : min;
    sec = sec < 10 ? "0" + sec : sec;
    time.innerHTML = hr + ":" + min + ":" + sec;
}

function next() {
    currentYear = (currentMonth === 13) ? currentYear + 1 : currentYear;
    currentMonth = currentMonth + 1 == 14 ? 1 : currentMonth + 1;
    showCalendar(currentMonth, currentYear);
}

function toToday() {
    today = coptic.today();
    currentMonth = today.month();
    currentYear = today.year();
    showCalendar(currentMonth, currentYear);
}

function previous() {
    currentYear = (currentMonth === 1) ? currentYear - 1 : currentYear;
    currentMonth = (currentMonth === 1) ? 13 : currentMonth - 1;
    showCalendar(currentMonth, currentYear);
}

function showCalendar(month, year) {

    let firstDay = coptic.dayOfWeek(year, month, 1);

    tbl = document.getElementById("calendar-body"); // body of the calendar

    // clearing all previous cells
    tbl.innerHTML = "";

    // filing data about month and in the page via DOM.
    monthAndYear.innerHTML = coptic.monthNames[month - 1] + " " + year;

    // creating all cells
    let date = 1;
    for (let i = 0; i < 6; i++) {
        // creates a table row
        let row = document.createElement("tr");

        //creating individual cells, filing them up with data.
        for (let j = 0; j < 7; j++) {
            if (i === 0 && j < firstDay) {
                // creating the blank cells
                cell = document.createElement("td");
                cellText = document.createTextNode("");
                cell.appendChild(cellText);
                row.appendChild(cell);
            } else if (date > coptic.daysInMonth(year, month)) {
                break;
            } else {
                // creating the days
                cell = document.createElement("td");
                cellText = document.createTextNode(date);
                let cdate = coptic.newDate(year, month, date);

                if (coptic.today().compareTo(cdate) === 0) {
                    cell.classList.add("bg-info");
                } // color today's date

                cell.appendChild(cellText);
                let addedEvent = false;

                for (let evt of event) {
                    let copticEventStart = coptic.fromJSDate(new Date(evt.startDate));
                    let copticEventEnd = coptic.fromJSDate(new Date(evt.endDate));
                    let cdate = coptic.newDate(year, month, date);
                    if (copticEventEnd.compareTo(cdate) >= 0 && copticEventStart.compareTo(cdate) <= 0) {
                        if (!addedEvent) {
                            dot = document.createElement('span');
                            dot.classList.add('dot');
                            cell.appendChild(dot);
                            // cell.setAttribute("data-toggle", "modal");
                            // cell.setAttribute("data-target", "#myModal");
                        }
                        cell.addEventListener('click', function (event) {
                            $(this).closest('tr')
                                .siblings()
                                .children('td')
                                .animate({
                                    padding: 0
                                })
                                .wrapInner("<div/>")
                                .children()
                                .slideUp(function () {
                                    $(this).closest('tr').hide();
                                });
                            let title = document.getElementById("events");
                            formatted = `${evt.Title}: ${evt.startDate} - ${evt.endDate} <br>`;
                            title.innerHTML += formatted;
                            event.stopPropagation();
                            return false;
                        });
                        addedEvent = true;
                    }
                }

                cell.classList.add('date');
                row.appendChild(cell);
                date++;
            }
        }
        tbl.appendChild(row); // appending each row into calendar body.
    }
}

document.getElementById('table-container').addEventListener('click', function (event) {
    $('table')
        .children()
        .children('tr')
        .slideDown(function () {
            $(this).show();
        })
        .children()
        .children('div')
        .show()
        .children()
        .unwrap()
        .parent()
        .animate({
            padding: '.75em'
        });
    isHidden = false;
    event.stopPropagation();
    return false;
});