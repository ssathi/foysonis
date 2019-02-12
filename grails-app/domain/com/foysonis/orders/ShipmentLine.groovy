package com.foysonis.orders

class ShipmentLine implements Serializable {

    String companyId
    String shipmentId
    String shipmentLineId
    String orderNumber
    String orderLineNumber
    String itemId
    Integer shippedQuantity
    String shippedUOM
    Integer kittingOrderQuantity

    static mapping = {
        id composite: ['companyId', 'shipmentId', 'shipmentLineId', 'orderNumber', 'orderLineNumber']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        shipmentId(blank:false, maxSize:32)
        shipmentLineId(blank:false)
        orderNumber(blank:false, maxSize:32)
        orderLineNumber(blank:false)
        itemId(blank:false, maxSize:32)
        shippedQuantity(blank:false)
        shippedUOM(blank:false, maxSize:10)
        kittingOrderQuantity(nullable:true)
    }
}
