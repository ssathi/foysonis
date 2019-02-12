package com.foysonis.kitting

class BillMaterial{

    String  companyId
    String  itemId
    String  finishedProductDefaultStatus
    Integer defaultProductionQuantity
    String  productionUom
    Date    createdDate
    Date    updatedDate

    static constraints = {
        companyId(blank:false, maxSize:32)
        itemId(blank:false, maxSize:32)
        finishedProductDefaultStatus(blank:false, maxSize:15)
        defaultProductionQuantity(nullable:true)
        productionUom(blank:false, maxSize:10)

    }


}
