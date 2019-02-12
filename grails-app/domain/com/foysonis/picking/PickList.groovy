package com.foysonis.picking

class PickList implements Serializable {

    String  companyId
    Long    pickListId
    String  pickListStatus
    Date    createdDate
    Date    completionDate
    Date    lastUpdateDate

    static mapping = {
        id composite: ['companyId', 'pickListId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        pickListId(blank:false)
        pickListStatus(blank:false, maxSize:1)
        completionDate(nullable:true)
    }

    def beforeInsert() {
        createdDate = new Date()
    }

    def beforeUpdate() {
        lastUpdateDate = new Date()
    }
}
