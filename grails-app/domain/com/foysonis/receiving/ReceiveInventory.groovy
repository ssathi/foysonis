package com.foysonis.receiving

class ReceiveInventory implements Serializable {

    String      companyId
    String      receiveInventoryId
    String      receiptLineId
    String      palletId
    String      caseId
    String      uom
    Integer     quantity
    String      lotCode
    Date        expirationDate
    String      inventoryStatus
    Boolean     isCompletedPutaway
    Date        createdDate
    String      locationId
    String      userId
    String      itemId
    String      itemDescription



    static mapping = {
        id composite: ['companyId', 'receiveInventoryId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        receiveInventoryId(blank:false, maxSize:40)
        receiptLineId(blank:false, maxSize:40)
        palletId(nullable:true)
        caseId(nullable:true)
        uom(blank:false, maxSize:10)
        quantity(blank:false)
        lotCode(nullable:true, maxSize:30)
        expirationDate(nullable:true)
        inventoryStatus(blank:false, maxSize:15)
        isCompletedPutaway(blank:false)
        createdDate(blank:false)
        locationId(nullable:true, maxSize:30)
        userId(nullable:true, maxSize:32)
        itemId(nullable:true, maxSize:32)
        itemDescription(nullable:true, maxSize:140)

    }
}

