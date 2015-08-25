# LegisGraph Schema

## Nodes

### Legislator

  * thomasID (index) - id.thomas
  * firstName - name.first
  * lastName - name.last
  * birthday - bio.birthday
  * gender - bio.gender
  * religion - bio.religion
  * party {republican|democrat}
  * democratCount - terms[].type
  * republicanCount - terms[].type
  * otherCount - terms[].type

### Bill

  * billID (index) - bill_id
  * active - history.active
  * enacted - history.enacted
  * vetoed - history.vetoed
  * officialTitle - official_title
  * popularTitle - popular_title

### Subject

  * title

### Congress

  * number
  
### State

  * code
  
### Committee
  * thomasID
  * jurisdiction
  * name
  * url
  * type
  
  
## Relationships

### (Bill)-[:PROPOSED_DURING]->(Congress)

### (Bill)-[:DEALS_WITH]->(Subject)

### (Bill)-[:REFERRED_TO]->(Committee)

### (Bill)-[:SPONSORED_BY]->(Legislator)

  * cosponsor - 1 if cosponsor, 0 if sponsor

### (Legislator)-[:VOTED_ON]->(Bill)
  
  * vote

### (Legislator)-[:SERVES_ON]->(Committee)

  * rank

### (Legislator)-[:REPRESENTS]->(State)
