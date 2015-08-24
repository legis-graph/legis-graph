LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/committee-members.csv' AS line
MATCH (c:Committee {thomasID: line.committeeID})
MATCH (l:Legislator {thomasID: line.legislatorID})
CREATE UNIQUE (l)-[r:SERVES_ON]->(c)
SET r.rank = line.rank;

