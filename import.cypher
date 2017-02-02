// Legis-graph LOAD CSV cypher script
// https://github.com/legis-graph/legis-graph

// Load Legislators


CREATE CONSTRAINT ON (l:Legislator) ASSERT l.bioguideID IS UNIQUE;
CREATE CONSTRAINT ON (s:State) ASSERT s.code IS UNIQUE;
CREATE CONSTRAINT ON (p:Party) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT ON (b:Body) ASSERT b.type IS UNIQUE;
CREATE CONSTRAINT ON (b:Bill) ASSERT b.billID IS UNIQUE;
CREATE CONSTRAINT ON (s:Subject) ASSERT s.title IS UNIQUE;
CREATE CONSTRAINT ON (c:Committee) ASSERT c.thomasID IS UNIQUE;



LOAD CSV WITH HEADERS
FROM 'file:///legislators-current.csv' AS line
MERGE (legislator:Legislator {bioguideID: line.bioguideID})
    ON CREATE SET legislator = line
MERGE (s:State {code: line.state})
MERGE (legislator)-[:REPRESENTS]->(s)
MERGE (p:Party {name: line.currentParty})
MERGE (legislator)-[:IS_MEMBER_OF]->(p)
MERGE (b:Body {type: line.type})
MERGE (legislator)-[:ELECTED_TO]->(b);

CREATE INDEX ON :Legislator(thomasID);
CREATE INDEX ON :Legislator(lisID);
CREATE INDEX ON :Legislator(govtrackID);
CREATE INDEX ON :Legislator(opensecretsID);
CREATE INDEX ON :Legislator(votesmartID);
CREATE INDEX ON :Legislator(cspanID);
CREATE INDEX ON :Legislator(wikipediaID);
CREATE INDEX ON :Legislator(washpostID);
CREATE INDEX ON :Legislator(icpsrID);


// Load Bills

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///bills.csv'
AS line
MERGE (bill:Bill { billID: line.billID })
    ON CREATE SET bill = line;

// Load 

LOAD CSV WITH HEADERS
FROM 'file:///subjects.csv' AS line
MERGE (subject:Subject { title: line.title });

// Load Congresses

LOAD CSV WITH HEADERS
FROM 'file:///congresses.csv' AS line
MERGE (congress:Congress { number: line.number });

// Laod Bills Congresses

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///bill_congresses.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (congress:Congress { number: line.number })
MERGE (bill)-[r:PROPOSED_DURING]->(congress);

// Load Bills Subjects

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///bill_subjects.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (subject:Subject { title: line.title })
MERGE (bill)-[r:DEALS_WITH]->(subject);

// Load Bills Legislators

// Load current sponsorships
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///sponsors.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { bioguideID: line.bioguideID })
MERGE (bill)-[r:SPONSORED_BY]->(legislator)
    ON CREATE SET r.cosponsor = CASE WHEN line.cosponsor = "1" THEN True ELSE False END;

// Load Votes

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///votes.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { bioguideID: line.bioguideID })
MERGE (bill)<-[r:VOTED_ON]-(legislator)
    ON CREATE SET r.vote = line.vote;

// Load Committees

LOAD CSV WITH HEADERS
FROM 'file:///committees-current.csv' AS line
MERGE (c:Committee {thomasID: line.thomasID})
  ON CREATE SET c = line;

LOAD CSV WITH HEADERS
FROM 'file:///bill_committees.csv' AS line
MATCH (b:Bill {billID: line.billID})
MATCH (c:Committee {thomasID: line.committeeID})
MERGE (b)-[:REFERRED_TO]->(c);

// Load Committee Members

LOAD CSV WITH HEADERS
FROM 'file:///committee-members.csv' AS line
MATCH (c:Committee {thomasID: line.committeeID})
MATCH (l:Legislator {bioguideID: line.legislatorID})
MERGE (l)-[r:SERVES_ON]->(c)
SET r.rank = toInt(line.rank);

// Create District nodes
LOAD CSV WITH HEADERS
FROM 'https://github.com/legis-graph/legis-graph/blob/master/outputs/cb_2014_districts.csv?raw=true' AS line
CREATE (d:District)
SET d.state = line.state,
    d.district = line.district,
    d.wkt = line.polygon
WITH d,line
MATCH (l:Legislator) WHERE l.state = line.state AND l.district = line.district
MERGE (l)-[:REPRESENTS]->(d);
