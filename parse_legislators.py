import csv
import yaml

OUTPUT_COLUMNS = [
        'thomasID',
        'govtrackID',
        'bioguideID',
        'opensecretsID',
        'lisID',
        'votesmartID',
        'fecIDs',
        'icpsrID',
        'wikipediaID',
        'cspanID',
        'washpostID',
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

            record['thomasID'] = person['id'].get('thomas', '')
            record['govtrackID'] = person['id'].get('govtrack', '')
            record['bioguideID'] = person['id'].get('bioguide', '')
            record['opensecretsID'] = person['id'].get('opensecrets', '')
            record['lisID'] = person['id'].get('lis', '')
            record['votesmartID'] = person['id'].get('votesmart', '')
            record['fecIDs'] = person['id'].get('fec', [])
            record['icpsrID'] = person['id'].get('icpsr', '')
            record['wikipediaID'] = person['id'].get('wikipedia', '')
            record['cspanID'] = person['id'].get('cspan', '')
            record['washpostID'] = person['id'].get('washington_post', '')
            record['firstName'] = person['name']['first']
            record['lastName'] = person['name']['last']
            record['fullName'] = person['name']['last'] + ', ' + person['name']['first']

            if 'bio' in person:
                record['birthday'] = person['bio'].get('birthday', '')
                record['gender'] = person['bio'].get('gender', '')
                record['religion'] = person['bio'].get('religion', '')
            
            if 'terms' in person:
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
