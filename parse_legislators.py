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

def load_legistors(kind):
    if kind not in ['current', 'historical']:
        raise Exception('Legislator kind must be either "current" or "historical"')

    inpath = 'data/congress-legislators/legislators-{}.yaml'.format(kind)
    with open(inpath, 'r') as f:
        current = yaml.load(f)

    outpath = 'outputs/legislators-{}.csv'.format(kind)
    with open(outpath, 'w') as f:
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

            if 'birthday' in person['bio']:
                record['birthday'] = person['bio']['birthday']

            if 'gender' in person['bio']:
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

load_legistors('current')
load_legistors('historical')
