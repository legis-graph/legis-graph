USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/bill_congresses.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (congress:Congress { number: line.number })
MERGE (bill)-[r:PROPOSED_DURING]->(congress);
