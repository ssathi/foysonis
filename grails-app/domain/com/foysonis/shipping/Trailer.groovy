package com.foysonis.shipping

class Trailer {
    String companyId
    String trailerNumber
    String status
    Date dispatchedDate


    static constraints = {
        companyId(blank:false, maxSize:32)
        trailerNumber(blank:false, maxSize:32)
        status(blank:false)
        dispatchedDate(nullable:true)
    }

}
