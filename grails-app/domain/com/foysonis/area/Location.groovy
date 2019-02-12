package com.foysonis.area

class Location implements Serializable{

    String companyId
    String areaId
    String locationId
    String locationBarcode
    Integer travelSequence
    Boolean isBlocked
    Date createdDate



    static mapping = {
        id composite: ['companyId', 'locationId']
        version false
    }

    static constraints = {
        companyId(blank:false)
        areaId(nullable:true, maxSize:15)
        locationId(blank:false, maxSize:30)
        locationBarcode(nullable:true, maxSize:30)
        travelSequence(nullable:true)
    }

    def beforeInsert() {
        createdDate = new Date()
    }
}
