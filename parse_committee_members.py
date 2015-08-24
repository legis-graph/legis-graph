import csv
import yaml

OUTPUT_COLUMNS = [
    'committeeID',
    'legislatorID',
    'rank'
]

def load_members():
    inpath = 'data/congress-legislators/committee-membership-current.yaml'
    with open(inpath, 'r') as f:
        current = yaml.load(f)

    outpath = 'outputs/committee-members.csv'
    with open(outpath, 'w') as f:
        writer = csv.DictWriter(f, OUTPUT_COLUMNS, extrasaction='ignore')
        writer.writeheader()
        for committee in current.keys():
            for member in current[committee]:
                record = {}
                record['committeeID'] = committee
                record['legislatorID'] = member.get('thomas', '')
                record['rank'] = member.get('rank', '')

                writer.writerow(record)

load_members()