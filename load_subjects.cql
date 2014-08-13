LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/subjects.csv' AS line
MERGE (subject:Subject { title: line.title });
CREATE INDEX ON :Subject(title);
