package com.foysonis.item

class EntityAttribute implements Serializable{
    String companyId
    String entityId
    String configKey
    String configGroup
    String configValue
    Integer sortSequence


    static mapping = {
        id composite: ['companyId', 'entityId', 'configKey', 'configGroup', 'configValue']
        version false
    }

    static constraints = {
        companyId(blank:false)
        entityId(blank:false, maxSize:30)
        configKey(blank:false, maxSize:50)
        configGroup(blank:false, maxSize:30)
        configValue(blank:false, maxSize:50)
        sortSequence(nullable:true)

    }
}
