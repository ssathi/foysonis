package com.foysonis.orders

class Orders implements Serializable {

    String companyId
    String orderNumber
    String customerId
    Date earlyShipDate
    Date lateShipDate
    String requestedShipSpeed
    String orderStatus
    String notes
    boolean isSubmitted = true
    Date createdDate
    String waveNumber
  
    static mapping = {
        id composite: ['companyId', 'orderNumber']
    }

    static constraints = {
    	companyId(blank:false, maxSize:32)
    	orderNumber(blank:false, maxSize:32)
    	customerId(blank:false)
    	earlyShipDate(nullable:true)
    	lateShipDate(nullable:true)
    	requestedShipSpeed(nullable:true)
    	orderStatus(blank:false)
        notes(nullable:true, maxSize:3000)
        waveNumber(nullable:true, maxSize:50)
    }
    def beforeInsert() {
        createdDate = new Date()
    }

}
