import csv
import os
import json

OUTPUT_COLUMNS = [
        'billID',
        'active',
        'enacted',
        'vetoed',
        'officialTitle',
        'popularTitle'
        ]

of = open('outputs/bills.csv', 'w')
writer = csv.DictWriter(of, OUTPUT_COLUMNS, extrasaction='ignore')
writer.writeheader()

rof = open('outputs/bills_legislators.csv', 'w')
rel_writer = csv.DictWriter(rof, ['billID', 'thomasID', 'cosponsor'], extrasaction='ignore')
rel_writer.writeheader()

srelof = open('outputs/bills_subjects.csv', 'w')
srel_writer = csv.DictWriter(srelof, ['billID', 'title'], extrasaction='ignore')
srel_writer.writeheader()

subjects = set()

for subdir in ['hr', 's', 'hjres', 'sjres']:
    bills = []
    for billdir in os.listdir('data/congress/113/bills/' + subdir):
        with open('data/congress/113/bills/' + subdir + '/' + billdir + '/data.json', 'r') as f:
            bill = json.load(f)
            record = {}

            record['billID'] = bill['bill_id']
            record['active'] = bill['history']['active']
            record['enacted'] = bill['history']['enacted']
            record['vetoed'] = bill['history']['vetoed']
            record['officialTitle'] = bill['official_title']
            record['popularTitle'] = bill['popular_title']

            writer.writerow(record)

            # Write out the sponsorships for this bill
            for cosponsor in bill['cosponsors']:
                rel = {
                        'billID': bill['bill_id'],
                        'thomasID': cosponsor['thomas_id'],
                        'cosponsor': 1
                        }
                rel_writer.writerow(rel)
            sponsor = bill['sponsor']
            srel = {
                    'billID': bill['bill_id'],
                    'thomasID': sponsor['thomas_id'],
                    'cosponsor': 0
                    }
            rel_writer.writerow(srel)

            # Add subjects to the list
            for subject in bill['subjects']:
                subjects.add(subject)
                srel_writer.writerow({
                    'billID': bill['bill_id'],
                    'title': subject
                    })

of.close()
srelof.close()

sof = open('outputs/subjects.csv', 'w')
sub_writer = csv.DictWriter(sof, ['title'], extrasaction='ignore')
sub_writer.writeheader()

for subject in subjects:
    sub_writer.writerow({'title': subject})

sof.close()
