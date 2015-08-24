LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/committees-current.csv' AS line
MERGE (c:Committee {thomasID: line.thomasID})
  ON CREATE SET c = line
  ON MATCH SET c = line;

LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/bill_committees.csv' AS line
MATCH (b:Bill {billID: line.billID})
MATCH (c:Committee {thomasID: line.committeeID})
CREATE UNIQUE (b)-[:REFERRED_TO]->(c);

CREATE INDEX ON :Committee(thomasID);