package com.foysonis.item

class EntityLastRecord implements Serializable{

    String companyId
    String entityId
    Integer lastRecordId


    static mapping = {
        id composite: ['companyId', 'entityId']
        version false
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        entityId(blank:false, maxSize:50)
        lastRecordId(blank:false)
    }
}
