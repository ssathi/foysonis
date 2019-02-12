package com.foysonis.jasperReport

class JasperCarrierInformation implements Serializable {

    String companyId
    String shipmentId
    String carrierId
    Integer handlingUnitQty
    String handlingUnitType
    Integer packageQty
    String packageType
    String weight
    String hm
    String commodityDescription
    String ltlNmfc
    String ltlClass

    static mapping = {
        id composite: ['companyId', 'shipmentId','carrierId']
    }    

    static constraints = {
    	companyId(blank:false)
    	shipmentId(blank:false)
    	carrierId(blank:false)
    	handlingUnitQty(nullable:true)
    	handlingUnitType(nullable:true)
    	packageQty(nullable:true)
    	packageType(nullable:true)
    	weight(nullable:true)
    	hm(nullable:true)
    	commodityDescription(nullable:true)
    	ltlNmfc(nullable:true)
    	ltlClass(nullable:true)
    }
}
