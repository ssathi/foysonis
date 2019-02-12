package com.foysonis.picking

class StagingLaneShipment implements Serializable {

    String  companyId
    String  locationId
    String  shipmentId
    String  areaId

    static mapping = {
        id composite: ['companyId', 'locationId', 'shipmentId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        locationId(blank:false, maxSize:30)
        shipmentId(blank:false, maxSize:30)
        areaId(blank:false, maxSize:15)

    }
}
