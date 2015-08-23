LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/legislators-current.csv' AS line
MERGE (legislator:Legislator { thomasID: line.thomasID })
    ON CREATE SET legislator = line
    ON MATCH SET legislator = line
MERGE (s:State {code: line.state})
CREATE UNIQUE (legislator)-[:REPRESENTS]->(s);

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
