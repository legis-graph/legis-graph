// Legis-graph LOAD CSV cypher script
// https://github.com/legis-graph/legis-graph

// Load Legislators

CREATE INDEX ON :Legislator(bioguideID);
CREATE INDEX ON :Legislator(thomasID);
CREATE INDEX ON :Legislator(lisID);
CREATE INDEX ON :Legislator(govtrackID);
CREATE INDEX ON :Legislator(opensecretsID);
CREATE INDEX ON :Legislator(votesmartID);
CREATE INDEX ON :Legislator(cspanID);
CREATE INDEX ON :Legislator(wikipediaID);
CREATE INDEX ON :Legislator(washpostID);
CREATE INDEX ON :Legislator(icpsrID);

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/legislators-current.csv' AS line
MERGE (legislator:Legislator { thomasID: line.thomasID })
    ON CREATE SET legislator = line
    ON MATCH SET legislator = line
MERGE (s:State {code: line.state})
CREATE UNIQUE (legislator)-[:REPRESENTS]->(s)
MERGE (p:Party {name: line.currentParty})
CREATE UNIQUE (legislator)-[:IS_MEMBER_OF]->(p)
MERGE (b:Body {type: line.type})
CREATE UNIQUE (legislator)-[:ELECTED_TO]->(b);

// Load Bills

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/bills.csv'
AS line
MERGE (bill:Bill { billID: line.billID })
    ON CREATE SET bill = line
    ON MATCH SET bill = line;
CREATE INDEX ON :Bill(billID);

// Load 

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/subjects.csv' AS line
MERGE (subject:Subject { title: line.title });
CREATE INDEX ON :Subject(title);

// Load Congresses

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/congresses.csv' AS line
MERGE (congress:Congress { number: line.number });

// Laod Bills Congresses

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/bill_congresses.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (congress:Congress { number: line.number })
MERGE (bill)-[r:PROPOSED_DURING]->(congress);

// Load Bills Subjects

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/bill_subjects.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (subject:Subject { title: line.title })
MERGE (bill)-[r:DEALS_WITH]->(subject);

// Load Bills Legislators

// Load current sponsorships
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/sponsors.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { thomasID: line.thomasID })
MERGE (bill)-[r:SPONSORED_BY]->(legislator)
    ON CREATE SET r.cosponsor = line.cosponsor;

// Load Votes

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/votes.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { bioguideID: line.bioguideID })
MERGE (bill)<-[r:VOTED_ON]-(legislator)
    ON CREATE SET r.vote = line.vote;

// Load Committees

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/committees-current.csv' AS line
MERGE (c:Committee {thomasID: line.thomasID})
  ON CREATE SET c = line
  ON MATCH SET c = line;

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/bill_committees.csv' AS line
MATCH (b:Bill {billID: line.billID})
MATCH (c:Committee {thomasID: line.committeeID})
CREATE UNIQUE (b)-[:REFERRED_TO]->(c);

CREATE INDEX ON :Committee(thomasID);

// Load Committee Members

LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/legis-graph/legis-graph/master/outputs/committee-members.csv' AS line
MATCH (c:Committee {thomasID: line.committeeID})
MATCH (l:Legislator {thomasID: line.legislatorID})
CREATE UNIQUE (l)-[r:SERVES_ON]->(c)
SET r.rank = line.rank;

// Create District nodes
LOAD CSV WITH HEADERS
FROM 'https://github.com/legis-graph/legis-graph/blob/master/outputs/cb_2014_districts.csv?raw=true' AS line
CREATE (d:District)
SET d.state = line.state,
    d.district = line.district,
    d.wkt = line.polygon
WITH d,line
MATCH (l:Legislator) WHERE l.state = line.state AND l.district = line.district
CREATE UNIQUE (l)-[:REPRESENTS]->(d);
