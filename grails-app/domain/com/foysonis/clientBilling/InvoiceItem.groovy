package com.foysonis.clientBilling

class InvoiceItem implements Serializable {

	String companyId
	String invoiceNumber
	String billingItemName
	BigDecimal amount
	Boolean isCustom
	Date createdDate

    static mapping = {
        id composite: ['companyId', 'invoiceNumber', 'billingItemName']
    }

    static constraints = {
    	companyId(blank:false)
    	invoiceNumber(blank:false)
    	billingItemName(blank:false)
    	amount(blank:false)
    	isCustom(nullable:true)
    	createdDate(blank:false)
    }
    def beforeInsert() {
        createdDate = new Date()
    } 
}
