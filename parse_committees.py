import csv
import yaml

OUTPUT_COLUMNS = [
    'type',
    'name',
    'url',
    'thomas_id',
    'jurisdiction',

]


def load_committees(kind):
    if kind not in ['current', 'historical']:
        raise Exception('Committe type must be either current or historical')

    inpath = 'data/congress-legislators/committees-{}.yaml'.format(kind)
    with open(inpath, 'r') as f:
        current = yaml.load(f)

    outpath = 'outputs/committees-{}.csv'.format(kind)
    with open(outpath, 'w') as f:
        writer = csv.DictWriter(f, OUTPUT_COLUMNS, extrasaction='ignore')
        writer.writeheader()
        for committee in current:
            record = {}
            record['type'] = committee.get('type', '')
            record['name'] = committee.get('name', '')
            record['url'] = committee.get('url', '')
            record['thomas_id'] = committee.get('thomas_id', '')
            record['jurisdiction'] = committee.get('jurisdiction', '')

            writer.writerow(record)

load_committees('current')
