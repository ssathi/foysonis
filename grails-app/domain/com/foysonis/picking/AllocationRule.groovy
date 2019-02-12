package com.foysonis.picking

class AllocationRule implements Serializable {

    String companyId
    String orderLineNumber
    String attributeName
    String attributeValue

    static mapping = {
        id composite: ['companyId', 'orderLineNumber']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        orderLineNumber(blank:false)
        attributeName(blank:false)
        attributeValue(blank:false)
    }    
}