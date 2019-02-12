package com.foysonis.item

class ListValue implements Serializable{
    String companyId
    String optionGroup
    String optionValue
    String description
    Integer displayOrder
    Date createdDate


    static mapping = {
        id composite: ['companyId', 'optionGroup', 'optionValue']
        version false
    }


    static constraints = {
        companyId(blank:false)
        optionGroup(blank:false, maxSize:15)
        optionValue(blank:false, maxSize:21)
        description(nullable:true)
    }

}
