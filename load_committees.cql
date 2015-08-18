LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/committees-current.csv' AS line
MERGE (c:Committee {thomasID: line.thomasID})
  ON CREATE SET c = line
  ON MATCH SET c = line;

CREATE INDEX ON :Committee(thomasID);