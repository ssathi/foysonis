package com.foysonis.kitting

class KittingInventory implements Serializable {

    String      companyId
    String      kittingOrderNumber
    String      itemId
    String      palletId
    String      caseId
    String      uom
    Integer     quantity
    String      lotCode
    Date        expirationDate
    String      inventoryStatus
    String      locationId
    Boolean     isAllInstructionCompleted = false
    Date        createdDate


    static constraints = {
        companyId(blank:false, maxSize:32)
        kittingOrderNumber(blank:false, maxSize:50)
        itemId(blank:false, maxSize:32)
        palletId(nullable:true)
        caseId(nullable:true)
        locationId(nullable:true)
        uom(blank:false, maxSize:10)
        quantity(blank:false)
        lotCode(nullable:true, maxSize:30)
        expirationDate(nullable:true)
        inventoryStatus(nullable:true)
        locationId(nullable:true)
        isAllInstructionCompleted(blank:false)

    }
}
