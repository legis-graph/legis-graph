LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/congresses.csv' AS line
MERGE (congress:Congress { number: line.number });
