package com.foysonis.picking

class AllocationFailedMessage implements Serializable {

    String  companyId
    String    shipmentId
    String  message
    Date    createdDate

    static constraints = {
        companyId(blank:false, maxSize:32)
        shipmentId(blank:false)
        message(blank:false)
    }
}
