import csv
import yaml

OUTPUT_COLUMNS = [
        'thomasID',
        'firstName',
        'lastName',
        'birthday',
        'gender',
        'religion',
        'party',
        'democratCount',
        'republicanCount',
        'otherCount'
        ]

with open('data/congress-legislators/legislators-current.yaml', 'r') as f:
    current = yaml.load(f)

with open('outputs/legislators-current.csv', 'w') as f:
    writer = csv.DictWriter(f, OUTPUT_COLUMNS, extrasaction='ignore')
    writer.writeheader()
    for person in current:
        record = {}

        # Don't parse anyone without a Thomas ID
        if 'thomas' not in person['id']:
            continue

        record['thomasID'] = person['id']['thomas']
        record['firstName'] = person['name']['first']
        record['lastName'] = person['name']['last']
        record['birthday'] = person['bio']['birthday']
        record['gender'] = person['bio']['gender']

        if 'religion' in person['bio']:
            record['religion'] = person['bio']['religion']
        
        demct = 0
        repct = 0
        othct = 0
        for term in person['terms']:
            if term['type'] == 'dem':
                demct += 1
            elif term['type'] == 'rep':
                repct += 1
            else:
                othct += 1

        record['democratCount'] = demct
        record['republicanCount'] = repct
        record['otherCount'] = othct

        maxct = max(demct, repct, othct)
        if demct == maxct:
            record['party'] = 'democrat'
        if repct == maxct:
            record['party'] = 'republican'
        if othct == maxct:
            record['party'] = 'other'

        writer.writerow(record)
