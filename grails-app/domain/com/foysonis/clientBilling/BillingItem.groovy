package com.foysonis.clientBilling

class BillingItem {

	String name
	Integer headingId
	String functionName
	Date createdDate

    static constraints = {
    	name(blank:false)
    	headingId(nullable:true)
    	functionName(nullable:true)
    }

    def beforeInsert() {
        createdDate = new Date()
    }
}
