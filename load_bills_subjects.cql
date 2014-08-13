USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/bills_subjects.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (subject:Subject { title: line.title })
MERGE (bill)-[r:DEALS_WITH]->(subject);
