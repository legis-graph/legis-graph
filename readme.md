## Update Congress Data

cd data/congress
rsync -avz --delete --delete-excluded --exclude **/text-versions/ govtrack.us::govtrackdata/congress/113 .

## Update Legislator Data

cd data
rsync -avz --delete --delete-excluded --exclude **/text-versions/ govtrack.us::govtrackdata/congress-legislators .
