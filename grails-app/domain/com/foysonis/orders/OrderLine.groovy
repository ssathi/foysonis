package com.foysonis.orders 

class OrderLine implements Serializable {

    String companyId
    String orderNumber
    String orderLineNumber
    String displayOrderLineNumber
    String itemId
    Integer orderedQuantity
    String orderedUOM
    String requestedInventoryStatus
    String orderLineStatus
    Boolean isCreateKittingOrder = false
    Integer kittingOrderQuantity

    static mapping = {
        id composite: ['companyId', 'orderNumber', 'orderLineNumber']
    }

    static constraints = {
    	companyId(blank:false, maxSize:32)
    	orderNumber(blank:false, maxSize:32)
    	orderLineNumber(blank:false)
    	displayOrderLineNumber(nullable:true)
    	itemId(blank:false, maxSize:32)
    	orderedQuantity(blank:false)
    	orderedUOM(blank:false, maxSize:10)
    	requestedInventoryStatus(blank:false)
    	orderLineStatus(blank:false)
        isCreateKittingOrder(nullable:true)
        kittingOrderQuantity(nullable:true)
    }
}
