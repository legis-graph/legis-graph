// Load current sponsorships
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/bills_legislators.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { thomasID: line.thomasID })
MERGE (bill)-[r:SPONSORED_BY]->(legislator)
    ON CREATE SET r.cosponsor = line.cosponsor;
