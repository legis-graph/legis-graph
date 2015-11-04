LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/114_districts_state.csv' AS line
MERGE (d:District {state: line.state, district: toInt(line.district)})
SET d.wkt = line.polygon;

LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/legislators-current.csv' AS line
MERGE (legislator:Legislator { thomasID: line.thomasID })
    ON CREATE SET legislator = line
    ON MATCH SET legislator = line
MERGE (s:State {code: line.state})
CREATE UNIQUE (legislator)-[:REPRESENTS]->(s)
MERGE (p:Party {name: line.currentParty})
CREATE UNIQUE (legislator)-[:IS_MEMBER_OF]->(p)
MERGE (b:Body {type: line.type})
CREATE UNIQUE (legislator)-[:ELECTED_TO]->(b)
WITH line, legislator
MATCH (d:District) WHERE d.state=line.state AND d.district=toInt(line.district)
CREATE UNIQUE (legislator)-[:REPRESENTS]->(d);

LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/legislators-historical.csv' AS line
MERGE (legislator:Legislator { thomasID: line.thomasID })
    ON CREATE SET legislator = line
    ON MATCH SET legislator = line
MERGE (s:State {code: line.state})
CREATE UNIQUE (legislator)-[:REPRESENTS]->(s);


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
