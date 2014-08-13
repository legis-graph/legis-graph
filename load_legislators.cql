LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/legislators-current.csv' AS line
MERGE (legislator:Legislator { thomasID: line.thomasID })
    ON CREATE SET legislator = line
    ON MATCH SET legislator = line;
CREATE INDEX ON :Legislator(thomasID);
