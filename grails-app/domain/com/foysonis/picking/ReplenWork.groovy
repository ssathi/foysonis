package com.foysonis.picking

class ReplenWork implements Serializable {

    String  companyId
    Long    replenReference
    String  itemId
    String  replenInventoryStatus
    Integer replenQuantity
    String  replenQuantityUom
    String  sourceLocationId
    String  destinationLocationId
    String  lpn
    String replenWorkStatus
    String assigningUserId
    String replenWorkLevel


    static mapping = {
        id composite: ['companyId', 'replenReference', 'itemId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        replenReference(blank:false)
        itemId(blank:false, maxSize:32)
        replenInventoryStatus(blank:false, maxSize:15)
        replenQuantity(blank:false)
        replenQuantityUom(blank:false, maxSize:10)
        sourceLocationId(blank:false, maxSize:30)
        destinationLocationId(blank:false, maxSize:30)
        lpn(nullable:true, maxSize:40)
        assigningUserId(nullable:true, maxSize:32)
        replenWorkLevel(nullable:true, maxSize:15)

    }
}
