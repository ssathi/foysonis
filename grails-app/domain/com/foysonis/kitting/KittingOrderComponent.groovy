package com.foysonis.kitting

class KittingOrderComponent {

    String  companyId
    String  kittingOrderNumber
    String  componentItemId
    Integer componentQuantity
    String  componentUom
    String  componentInventoryStatus
    Boolean componentTracked = false

    static constraints = {
        companyId(blank:false, maxSize:32)
        kittingOrderNumber(blank:false, maxSize:50)
        componentItemId(blank:false, maxSize:32)
        componentQuantity(blank:false)
        componentUom(blank:false, maxSize:10)
        componentInventoryStatus(blank:false, maxSize:15)
    }


}
