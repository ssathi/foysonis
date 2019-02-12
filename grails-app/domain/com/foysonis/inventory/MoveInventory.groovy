package com.foysonis.inventory

class MoveInventory implements Serializable{

    String  companyId
    String  moveType
    String  fromLocationId
    String  lPN
    String  itemId
    String  inventoryStatus
    Integer quantity
    String  toPalletId
    String  toLocationId
    Date    createdDate
    String  userId
    String  itemDescription

    static constraints = {
        companyId(blank:false, maxSize:32)
        moveType(blank:false, maxSize:15)
        fromLocationId(blank:false, maxSize:30)
        lPN(nullable: true, maxSize:40)
        itemId(nullable: true, maxSize:32)
        inventoryStatus(nullable: true, maxSize:15)
        quantity(nullable:true)
        toPalletId(nullable: true, maxSize:40)
        toLocationId(nullable: true, maxSize:30)
        createdDate(blank:false)
        userId(nullable:true, maxSize:32)
        itemDescription(nullable:true, maxSize:140)
    }
}
