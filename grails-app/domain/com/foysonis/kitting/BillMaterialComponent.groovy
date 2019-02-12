package com.foysonis.kitting

class BillMaterialComponent{

    String  companyId
    Integer bomId
    String  componentItemId
    Integer componentQuantity
    String  componentUom
    String  componentInventoryStatus
    Boolean componentTracked = false

    static constraints = {
        companyId(blank:false, maxSize:32)
        bomId(blank:false)
        componentItemId(blank:false, maxSize:32)
        componentQuantity(blank:false)
        componentUom(blank:false, maxSize:10)
        componentInventoryStatus(blank:false, maxSize:15)
    }


}
