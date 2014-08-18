# Legislative Graph

A set of scripts to easily download and import US legislative data into a Neo4j
database. This is a work-in-progress but it is already quite useful if you are
interested in such a database.

## Download / update data

Sync a particular congress by its number (so, for instance, for the 112th
congress, replace `<num>` with `112`.

```
./sync.sh <num>
```

## Parse data

Use the parse scripts to parse the raw data into CSV files that can be easily
loaded into Neo4j.

```
$ python parse_legislators.py
...
$ python parse_bills.py
...
$ python parse_votes.py
...
```

The scripts require Python 3.

## Load data

Use the `*.cql` scripts to load the data into Neo4j. You need to have the data
files available over HTTP, so before you do this step, in another terminal
window, just run `$ python -m http.server` in the repository root.

```
$ neo4j-shell < load_legislators.cql
...
$ neo4j-shell < load_bills.cql
...
$ neo4j-shell < load_subjects.cql
...
$ neo4j-shell < load_congresses.cql
...
$ neo4j-shell < load_bills_congresses.cql
...
$ neo4j-shell < load_bills_subjects.cql
...
$ neo4j-shell < load_bills_legislators.cql
...
$ neo4j-shell < load_votes.cql
...
```

## Sample queries

See the [GitHub wiki](https://github.com/glesica/legis-graph/wiki) for some
sample queries you can run against the completed database.
