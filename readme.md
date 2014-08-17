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

Find the number of bills proposed during each congress in the database.

```
MATCH (c:Congress)<-[:PROPOSED_DURING]-(b:Bill)
RETURN c.number AS congress, count(b) as numProposed
```

Find the number of bills enacted in each congress in the database and the
average number of sponsors bills had during that congress.

```
MATCH (c:Congress)<-[:PROPOSED_DURING]-(b:Bill)-[:SPONSORED_BY]->(l:Legislator)
WHERE b.enacted = 'True'
WITH c, b, count(l) AS numSponsors
RETURN c.number AS congress, count(b) AS numPassed, avg(numSponsors) AS avgSponsors
```

Find the subject most frequently associated with bills sponsored by 10 members
of congress across all congresses in which they participated.

```
```
