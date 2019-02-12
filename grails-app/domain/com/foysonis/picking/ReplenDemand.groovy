package com.foysonis.picking

class ReplenDemand implements Serializable {

    String  companyId
    String  workReferenceNumber
    String  itemId
    String  requiredInventoryStatus
    Integer requiredQuantity
    String  requiredQuantityUom
    String  demandStatus
    Long    replenReference


    static mapping = {
        id composite: ['companyId', 'workReferenceNumber', 'itemId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        workReferenceNumber(blank:false)
        itemId(blank:false, maxSize:32)
        requiredInventoryStatus(blank:false, maxSize:15)
        requiredQuantity(blank:false)
        requiredQuantityUom(blank:false, maxSize:10)
        demandStatus(blank:false, maxSize:1)
        replenReference(blank:false)

    }
}
