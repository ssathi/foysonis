package com.foysonis.inventory

class InventoryAdjustment {

    String adjustmentId
    String itemId
    String companyId
    Integer prevQty
    Integer qty
    String uom
    String locationId
    String palletId
    String caseId
    String reasonCode
    String adjustmentDescription
    String userId
    Date createdDate
    String previousInventoryStatus
    String inventoryStatus
    String previousLotCode
    String lotCode
    Date previousExpirationDate
    Date expirationDate
    String action
    String itemDescription

    static mapping = {
        id generator:'assigned'
        id name: 'adjustmentId'
    }

    static constraints = {

        adjustmentId(blank:false, maxSize:40)
        itemId(nullable:true, maxSize:32)
        companyId(blank:false, maxSize:32)
        prevQty(nullable:true)
        qty(nullable:true)
        uom(nullable:true, maxSize:10)
        locationId(nullable:true, maxSize:30)
        palletId(nullable:true, maxSize:40)
        caseId(nullable:true, maxSize:40)
        reasonCode(nullable:true, maxSize:5)
        adjustmentDescription(nullable:true, maxSize:100)
        userId(nullable:true, maxSize:32)
        createdDate(nullable:true)
        previousInventoryStatus(nullable:true, maxSize:15)
        inventoryStatus(nullable:true, maxSize:15)
        previousLotCode(nullable:true, maxSize:30)
        lotCode(nullable:true, maxSize:30)
        previousExpirationDate(nullable:true)
        expirationDate(nullable:true)
        action(blank:false, maxSize:10)
        itemDescription(nullable:true, maxSize:140)

    }
}

