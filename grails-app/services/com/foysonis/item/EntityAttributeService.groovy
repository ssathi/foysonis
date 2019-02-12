package com.foysonis.item


import grails.transaction.Transactional

@Transactional
class EntityAttributeService {

    def getEntityAttributesByConfigKey(comapanyId, configKey){
        return EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKey(comapanyId, "AREAS", configKey)
    }

    // def getEntityAttributesByConfigKey(comapanyId, configKey){
    // return EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKey(comapanyId, "ITEM", configKey)
    //}

    def save(companyId, entityId, configKey, configGroup, configValue, sortSequence){
        def entity = new EntityAttribute()
        entity.companyId = companyId
        entity.entityId = entityId
        entity.configKey = configKey
        entity.configGroup = configGroup
        entity.configValue = configValue
        entity.sortSequence = sortSequence
        entity.save(flush: true, failOnError: true)
    }

    def removeEntityAttributesByConfigKey(companyId, configKey){
        def entityAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKey(companyId, "AREAS", configKey)

        for (entity in entityAttributes){
            entity.delete(flush: true, failOnError: true)
        }


    }
}

