package com.foysonis.picking

class PickMove implements Serializable {

    String  companyId
    Long    workReferenceNumber
    Integer moveSequenceNumber
    String  destinationAreaId
    String  destinationLocationId
    Integer arrivedQuantity
    String  arrivedQuantityUom

    static mapping = {
        id composite: ['companyId', 'workReferenceNumber', 'moveSequenceNumber']
    }


    static constraints = {
        companyId(blank:false, maxSize:32)
        workReferenceNumber(blank:false)
        moveSequenceNumber(blank:false)
        destinationAreaId(blank:false, maxSize:15)
        destinationLocationId(nullable:true, maxSize:30)
        arrivedQuantity(blank:false)
        arrivedQuantityUom(blank:false, maxSize:10)

    }
}
