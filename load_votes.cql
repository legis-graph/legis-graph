// Load votes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/votes.csv'
AS line
MATCH (bill:Bill { billID: line.billID }),
      (legislator:Legislator { bioguideID: line.bioguideID })
MERGE (bill)<-[r:VOTED_ON]-(legislator)
    ON CREATE SET r.vote = line.vote;
