package com.foysonis.clientBilling

class CommercialInvoiceItem {

	String companyId
    String customerId
	String commercialInvoiceNumber
	String billingItemName
    Integer qty
    BigDecimal priceEach
	BigDecimal totalAmount
    Date fromDate
    Date toDate
	Date createdDate

    // static mapping = {
    //     id composite: ['companyId', 'commercialInvoiceNumber', 'billingItemName']
    // }

    static constraints = {
    	companyId(blank:false)
        customerId(nullable:true)
    	commercialInvoiceNumber(blank:false)
    	billingItemName(blank:false)
    	totalAmount(blank:false)
        priceEach(blank:false)
        fromDate(blank:false)
        toDate(blank:false)
    	createdDate(blank:false)
    }
    def beforeInsert() {
        createdDate = new Date()
    } 
}
