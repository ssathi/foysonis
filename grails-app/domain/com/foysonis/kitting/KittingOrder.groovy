package com.foysonis.kitting

class KittingOrder implements Serializable{

    String  companyId
    String  kittingOrderNumber
    String  kittingOrderType = 'REGULAR'
    String  kittingItemId
    String  finishedProductInventoryStatus
    Integer productionQuantity
    String  productionUom
    String  kittingOrderStatus = 'OPEN'
    String  orderInfo
    Date    createdDate
    Date    updatedDate

    static mapping = {
        id composite: ['companyId', 'kittingOrderNumber']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        kittingOrderNumber(blank:false, maxSize:50)
        kittingOrderType(blank:false, maxSize:15)
        kittingItemId(blank:false, maxSize:32)
        finishedProductInventoryStatus(blank:false, maxSize:15)
        productionQuantity(nullable:true)
        productionUom(blank:false, maxSize:10)
        kittingOrderStatus(blank:false, maxSize:15)
        orderInfo(nullable:true, maxSize:32)

    }
}
