package com.foysonis.jasperReport

class JasperCustomerOrder implements Serializable {

    String companyId
    String orderNumber
    String pkgs
    String weight
	Boolean palletSlip
	String additionalShipperInfo  

    static mapping = {
        id composite: ['companyId', 'orderNumber']
    }

    static constraints = {
    	companyId(blank:false)
        orderNumber(blank:false)
    	pkgs(nullable:true)
    	weight(nullable:true)
    	additionalShipperInfo(nullable:true)
    }
}
