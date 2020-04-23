from selenium import webdriver
import os
import time
from bs4 import BeautifulSoup
import json
import re

options = webdriver.ChromeOptions()
options.add_argument('headless')

chromedriver = "/Users/123ad30/chromedriver"
os.environ["webdriver.chrome.driver"] = chromedriver
driver = webdriver.Chrome(chromedriver, options=options)

data = []
for i in range(1, 367):
    # for i in range(14, 30):
    driver.get('http://www.copticchurch.net/classes/synex.php?id={}'.format(i))
    time.sleep(5)
    html = driver.page_source

    soup = BeautifulSoup(html, 'html.parser')

    items = []
    # for h3 in soup.find_all('h3'):
    #     t = h3.text + '.' if h3.text[-1] != '.' else h3.text
    #     v = re.match('^[1-9].[\s\w.,()-].*(?=\.)', t)
    #     if(v):
    #         items.append(v.group(0))

    # if (len(items) == 0):
    for ahref in soup.find_all('a'):
        t = ahref.text
        if (len(t.split(' ')) > 4):
            items.append(ahref.text)
            # print(ahref.text)

    data.append(items)

print("const synax =", data, ';')
