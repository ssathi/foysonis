package com.foysonis.inventory

class InventorySummary implements Serializable{

    String companyId
    String itemId
    String inventoryStatus
    Integer committedQuantity
    Integer totalQuantity
    String uom


    static mapping = {
        id composite: ['companyId', 'itemId', 'inventoryStatus']

    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        itemId(blank:false, maxSize:32)
        inventoryStatus(blank:false)
        committedQuantity(blank:false)
        totalQuantity(blank:false)
        uom(maxSize:10, blank:false)


    }
}
