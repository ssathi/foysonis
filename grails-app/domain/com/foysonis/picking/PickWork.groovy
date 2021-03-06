package com.foysonis.picking

class PickWork implements Serializable {

    String  companyId
    String    workReferenceNumber
    String    shipmentId
    String    shipmentLineId
    String    orderNumber
    String    orderLineNumber
    Integer pickQuantity
    String  pickQuantityUom
    Integer completedQuantity
    String  pickStatus
    String  sourceLocationId
    String  destinationLocationId
    String  destinationAreaId
    Date    pickCreationDate
    Date    lastUpdateDate
    String  lastUpdateUsername
    Long    pickListId
    Integer pickSequence
    String  palletLpn
    String  pickLevel
    Boolean isSkipped
    String  pickType
    String itemId
    String waveNumber

    static mapping = {
        id composite: ['companyId', 'workReferenceNumber']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        workReferenceNumber(blank:false)
        shipmentId(blank:false)
        shipmentLineId(blank:false)
        orderNumber(blank:false)
        orderLineNumber(blank:false)
        pickQuantity(blank:false)
        pickQuantityUom(blank:false, maxSize:10)
        completedQuantity(blank:false)
        pickStatus(blank:false)
        sourceLocationId(blank:false, maxSize:30)
        destinationLocationId(nullable:true, maxSize:30)
        destinationAreaId(nullable:true, maxSize:15)
        lastUpdateUsername(nullable:true, maxSize:32)
        pickListId(nullable:true)
        pickSequence(nullable:true)
        palletLpn(nullable:true, maxSize:40)
        pickLevel(blank:false, maxSize:1)
        isSkipped(nullable:true)
        itemId(blank:false, maxSize:32)
        waveNumber(nullable:true, maxSize:50)
    }

    def beforeInsert() {
        pickCreationDate = new Date()
    }

    def beforeUpdate() {
        lastUpdateDate = new Date()
    }
}
