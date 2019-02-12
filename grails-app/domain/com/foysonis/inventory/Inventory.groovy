package com.foysonis.inventory

class Inventory implements Serializable{

    String companyId
    String inventoryId
    String itemId
    String associatedLpn
    String locationId
    Integer quantity
    String handlingUom
    String lotCode
    Date expirationDate
    String inventoryStatus
    String workReferenceNumber
    String pickedInventoryNotes


    static mapping = {
        id composite: ['companyId', 'inventoryId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        inventoryId(blank:false, maxSize:40)
        itemId(blank:false, maxSize:32)
        associatedLpn(nullable:true, maxSize:40)
        locationId(nullable:true, maxSize:30)
        quantity(blank:false)
        handlingUom(nullable:true, maxSize:10)
        lotCode(nullable:true, maxSize:30)
        expirationDate(nullable:true)
        inventoryStatus(blank:false, maxSize:15) // from List Value
        workReferenceNumber(nullable:true)
        pickedInventoryNotes(nullable:true, maxSize:3000)

    }
}

