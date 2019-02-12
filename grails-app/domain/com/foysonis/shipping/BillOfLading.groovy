package com.foysonis.shipping

class BillOfLading implements Serializable {

    String companyId
    String serializedNumber

    static mapping = {
        id composite: ['companyId', 'serializedNumber']
    }


    static constraints = {
        companyId(blank:false, maxSize:32)
        serializedNumber(blank:false, maxSize:40)
    }

}
