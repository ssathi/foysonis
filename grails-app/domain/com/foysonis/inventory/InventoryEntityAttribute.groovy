package com.foysonis.inventory

class InventoryEntityAttribute implements Serializable {

    String companyId
    String lPN
    String level
    String locationId
    String parentLpn
    String sscc
    Date lastModifiedDate
    Date createdDate
    String lastModifiedUserId

    static constraints = {
        companyId(blank:false, maxSize:32)
        lPN(blank:false, maxSize:40)
        level(blank:false, maxSize:8)
        locationId(nullable:true, maxSize:30)
        parentLpn(nullable:true, maxSize:40)
        sscc(nullable:true, maxSize:18)
        lastModifiedDate(blank:false)
        createdDate(blank:false)
        lastModifiedUserId(blank:false, maxSize:32)
    }
}
