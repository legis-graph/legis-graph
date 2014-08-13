# LegisGraph Schema

## Legislator

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

## Bill

  * billID (index) - bill_id
  * active - history.active
  * enacted - history.enacted
  * vetoed - history.vetoed
  * officialTitle - official_title
  * popularTitle - popular_title
  * DEALS_WITH -> Subject
    * primarySubject [bool]
  * SPONSORED_BY -> Bill
    * cosponsor [bool]
  * CONGRESS -> Congress

## Subject

  * title

## Congress

  * number
