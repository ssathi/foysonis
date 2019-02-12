package com.foysonis.clientBilling

class Invoice implements Serializable {

	String companyId
	String invoiceNumber
	String invoiceDisplayNumber
	Date fromDate
	Date toDate
	Date createdDate

    static mapping = {
        id composite: ['companyId', 'invoiceNumber']
    }

    static constraints = {
    	companyId(blank:false)
    	invoiceNumber(blank:false)
    	invoiceDisplayNumber(blank:false)
    	fromDate(blank:false)
    	toDate(blank:false)
    	createdDate(blank:false)
    }
    def beforeInsert() {
        createdDate = new Date()
    }     
}
