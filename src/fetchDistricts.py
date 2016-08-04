'''
Fetch simplified WKT boundaries for 2014 congressional districts and
save in CSV format:
    state,district,polygon

'''
import requests
import csv

BASE_URL = "https://gis.govtrack.us"
CD_2014_URL = "/boundaries/cd-2014/?limit=500"


# get meta boundary
r = requests.get(BASE_URL + CD_2014_URL)
j = r.json()

boundaries = j['objects']

with open('cb_2014_districts.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['state', 'district', 'polygon'])

    for b in boundaries:
        p = str.split(b['name'], '-')
        r = requests.get(BASE_URL + b['url'] + 'simple_shape?format=wkt')
        wkt = r.text
        writer.writerow([p[0], p[1], wkt])

