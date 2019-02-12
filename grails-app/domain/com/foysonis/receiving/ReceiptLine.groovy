package com.foysonis.receiving

class ReceiptLine implements Serializable {

    String  companyId
    String  receiptLineNumber // User entered value
    String  receiptLineId // System generated value <company name>0000000001
    String  receiptId
    String  itemId
    Integer expectedQuantity
    String  uom
    String  expectedLotCode
    Date    expectedExpirationDate

    static mapping = {
        id composite: ['companyId', 'receiptLineId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        receiptLineNumber(blank:false, maxSize:40)
        receiptLineId(blank:false, maxSize:40)
        receiptId(blank:false, maxSize:40)
        itemId(blank:false, maxSize:32)
        expectedQuantity(blank:false)
        uom(blank:false, maxSize:10)
        expectedLotCode(nullable:true, maxSize:30)
        expectedExpirationDate(nullable:true)
    }
}

