package com.foysonis.orders

class Shipment implements Serializable {

    String companyId
    String shipmentId
    String carrierCode
    Boolean isParcel
    String serviceLevel
    String trackingNo
    String shipmentStatus
    String truckNumber
    Date creationDate
    Date completedDate
    Integer truckInstanceId
    Integer shippingAddressId
    String contactName
    String shipmentNotes
    Integer noOfLabels
    String easyPostLabel
    Boolean easyPostManifested
    String easyPostShipmentId
    String stagingLocationId
    BigDecimal actualWeight
    String waveNumber


    static mapping = {
        id composite: ['companyId', 'shipmentId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        shipmentId(blank:false, maxSize:32)
        carrierCode(nullable:true)
        serviceLevel(nullable:true)
        trackingNo(nullable:true, maxSize:100)
        shipmentStatus(blank:false)
        truckNumber(nullable:true, maxSize:50)
        completedDate(nullable:true)
        truckInstanceId(nullable:true)
        shippingAddressId(blank:false)
        contactName(blank:true, maxSize:500)
        shipmentNotes(nullable:true, maxSize:3000)
        noOfLabels(nullable:true)
        easyPostLabel(nullable:true)
        easyPostManifested(nullable:true)
        easyPostShipmentId(nullable:true)
        stagingLocationId(nullable:true, maxSize:30)
        actualWeight(nullable:true)
        waveNumber(nullable:true, maxSize:50)

    }

    def beforeInsert() {
        creationDate = new Date()
    }

}
