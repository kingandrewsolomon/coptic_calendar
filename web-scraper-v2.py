from selenium import webdriver
import os
import time
from bs4 import BeautifulSoup
import json

options = webdriver.ChromeOptions()
options.add_argument('headless')

chromedriver = "/Users/andrewsolomon/chromedriver"
os.environ["webdriver.chrome.driver"] = chromedriver
driver = webdriver.Chrome(chromedriver, options=options)

datesList = []
dateDict = {"January": 1,
            "February": 2,
            "March": 3,
            "April": 4,
            "May": 5,
            "June": 6,
            "July": 7,
            "August": 8,
            "September": 9,
            "October": 10,
            "November": 11,
            "December": 12}

for i in range(2019, 2024):
    driver.get(
        'https://suscopts.org/coptic-orthodox/fasts-and-feasts/{}/'.format(i))
    time.sleep(5)
    html = driver.page_source

    soup = BeautifulSoup(html, 'html.parser')

    data = []
    for tr in soup.find_all('tr'):
        values = [td.text for td in tr.find_all('td')]
        data.append(values)

    data = [x for x in data if x]

    for dates in data:
        datesObj = {}
        title = dates[0]
        temp = dates[1].partition('–')
        startDate = temp[0].strip() + ' {}'.format(i)

        if(len(temp[2]) > 2):
            startMonth = temp[0].split()[0]
            endMonth = temp[2].strip().split()[0]

            if (dateDict[startMonth] > dateDict[endMonth]):
                endDate = temp[2].strip() + ' {}'.format(i + 1)
            else:
                endDate = temp[2].strip() + ' {}'.format(i)

        elif (len(temp[2]) == 2 or len(temp[2]) == 1):
            endDate = startDate.split()[0] + ' ' + \
                temp[2].strip() + ' {}'.format(i)

        if len(temp[2]) == 0:
            endDate = startDate

        datesObj.setdefault('Title', title)
        datesObj.setdefault('startDate', startDate)
        datesObj.setdefault('endDate', endDate)
        datesList.append(datesObj)

print("const event =", datesList)
