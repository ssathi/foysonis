package com.foysonis.item

class Item implements Serializable{

    String companyId
    String itemId
    String itemDescription
    String lowestUom
    Boolean isLotTracked
    Boolean isExpired
    Boolean isCaseTracked
    String originCode
    Integer eachesPerCase
    Integer casesPerPallet
    String upcCode
    String eanCode
    String itemCategory
    Integer reorderLevelQuantity
    String imagePath


    static mapping = {
        id composite: ['companyId', 'itemId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        itemId(blank:false, maxSize:32)
        itemDescription(blank:false, maxSize:140)
        lowestUom(blank:false)
        originCode(nullable:true, maxSize:5)
        eachesPerCase(nullable:true)
        casesPerPallet(nullable:true)
        upcCode(nullable:true, maxSize:15)
        eanCode(nullable:true, maxSize:15)
        itemCategory(nullable:true, maxSize:15) // from List Value
        reorderLevelQuantity(nullable:true)
        imagePath(nullable:true)
    }
}

