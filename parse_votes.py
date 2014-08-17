import csv
import json
import os

VOTE_FIELDS = ['bioguideID', 'billID', 'vote']

votes_file = open('outputs/votes.csv', 'w')
vote_writer = csv.DictWriter(votes_file, VOTE_FIELDS, extrasaction='ignore')
vote_writer.writeheader()

congresses_dir = 'data/congress'
for congress in os.listdir(congresses_dir):
    congress_dir = os.path.join(congresses_dir, congress, 'votes')
    for year in os.listdir(congress_dir):
        year_dir = os.path.join(congress_dir, year)
        for bill in os.listdir(year_dir):
            bill_dir = os.path.join(year_dir, bill)
            vote_data_file = open(os.path.join(bill_dir, 'data.json'), 'r')
            vote_data = json.load(vote_data_file)

            # For now we only consider votes on bill passage and ignore the rest.
            if vote_data['category'] != 'passage':
                continue

            bill_id = '{}{}-{}'.format(vote_data['bill']['type'],
                    vote_data['bill']['number'], vote_data['bill']['congress'])

            for vote_type in vote_data['votes']:
                for voter in vote_data['votes'][vote_type]:
                    vote_writer.writerow({
                        'bioguideID': voter['id'],
                        'billID': bill_id,
                        'vote': vote_type
                    })

            vote_data_file.close()

votes_file.close()
