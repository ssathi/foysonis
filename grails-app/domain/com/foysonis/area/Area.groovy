package com.foysonis.area

class Area implements Serializable{
    String companyId
    String areaId
    String areaName
    Boolean isStorage
    Boolean isProcessing
    Boolean isPickable
    Boolean isPnd
    Boolean isStaging
    Date createdDate
    Integer putawayOrder
    Integer allocationOrder
    Boolean isBin
    Boolean isKitting

    static mapping = {
        id composite: ['companyId', 'areaId']
        version false
    }


    static constraints = {
        companyId(blank:false)
        areaId(blank:false, maxSize:15)
        areaName(nullable:true, maxSize:30)
        putawayOrder(nullable:true)
        allocationOrder(nullable:true)
    }

    def beforeInsert() {
        createdDate = new Date()
    }
}
