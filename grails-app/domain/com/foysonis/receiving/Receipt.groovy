package com.foysonis.receiving

class Receipt implements Serializable {

    String  receiptId
    String  companyId
    Date    receiptDate
    Date    completeDate
    String  userId
    String  inboundTruckId
    String  inboundProNumber
    String  receiptType
    String  customerId

    static mapping = {
        id composite: ['companyId', 'receiptId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        receiptId(blank:false, maxSize:40)
        userId(blank:false, maxSize:32)
        receiptDate(blank:false)
        completeDate(nullable:true)
        inboundTruckId(nullable:true)
        inboundProNumber(nullable:true)
        receiptType(nullable:true, maxSize: 20)
        customerId(nullable:true, maxSize:50)
    }
}
