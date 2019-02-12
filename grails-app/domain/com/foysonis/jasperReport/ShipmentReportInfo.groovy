package com.foysonis.jasperReport

class ShipmentReportInfo implements Serializable {

    String companyId
    String shipmentId
    String serializedNumber
    String bolNumber
    String scac
    Boolean prepaid
    Boolean collect
    Boolean thirdParty
    String sealNumber
    String driver
    String driverLic
    String tempLow
    String tempHigh
    String loadedAt

    static mapping = {
        id composite: ['companyId', 'shipmentId']
    }   

    static constraints = {
    	companyId(blank:false, maxSize:32)
    	shipmentId(blank:false)
    	serializedNumber(blank:false, maxSize:40)
    	bolNumber(nullable:true)
    	scac(nullable:true)
    	sealNumber(nullable:true)
        driver(nullable:true)
        driverLic(nullable:true)
        tempLow(nullable:true)
        tempHigh(nullable:true)
        loadedAt(nullable:true)


    }
}
