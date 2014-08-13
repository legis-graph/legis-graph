#! /usr/bin/env bash

# Script to rsync data from GovTrack. Invoke with the congress you wish to
# fetch (for instance, 113). Always syncs the legislator data.
# Ex: $ ./sync.sh 113

cd data/congress
rsync -avz --delete --delete-excluded --exclude **/text-versions/ \
govtrack.us::govtrackdata/congress/${1} .
