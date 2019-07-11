import requests
from bs4 import BeautifulSoup

data = requests.get(
    "http://www.copticchurch.net/classes/coptic.holidays.php?year=2019")

soup = BeautifulSoup(data.text, 'html.parser')

data = []
for tr in soup.find_all('tr'):
    values = [td.text for td in tr.find_all(
        'td', {'class': ['TextColumn', 'LabelColumn']})]

    data.append(values)

data = [x for x in data if x]
print(data)
