package com.foysonis.clientBilling

class BillingItemAmount implements Serializable {

	String companyId
	Integer billingItemId
	BigDecimal amount
    BigDecimal minRate
	Date createdDate

    static mapping = {
        id composite: ['companyId', 'billingItemId']
    }

    static constraints = {
    	companyId(blank:false)
    	billingItemId(blank:false)
    	amount(nullable:true)
        minRate(nullable:true)
    }
    def beforeInsert() {
        createdDate = new Date()
    }    
}
