USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'http://localhost:8000/outputs/bills.csv'
AS line
MERGE (bill:Bill { billID: line.billID })
    ON CREATE SET bill = line
    ON MATCH SET bill = line;
CREATE INDEX ON :Bill(billID);
