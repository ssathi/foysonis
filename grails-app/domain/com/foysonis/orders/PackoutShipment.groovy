package com.foysonis.orders

class PackoutShipment implements Serializable {

    String  companyId
    String  waveNumber
    String  shipmentId
    String  shipmentLineId
    String  shipmentContainerId
    Date    createdDate
    Integer confirmedQuantity


    static constraints = {
        companyId(blank:false, maxSize:32)
        waveNumber(blank:false, maxSize:50)
        shipmentId(blank:false, maxSize:32)
        shipmentLineId(blank:false)
        shipmentContainerId(blank:false)
        createdDate(blank:false)
        confirmedQuantity(blank:false)
    }
}
