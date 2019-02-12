package com.foysonis.orders

class Wave implements Serializable {

    String companyId
    String waveNumber
    String waveStatus
    Date createdDate
    Date allocatedDate
    Date completedDate
    Integer picksPerList
    String pickTicketPrintOption

    static mapping = {
        id composite: ['companyId', 'waveNumber']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        waveNumber(blank:false, maxSize:50)
        waveStatus(blank:false, maxSize:30)
        createdDate(blank:false)
        allocatedDate(nullable: true)
        completedDate(nullable: true)
        picksPerList(nullable:true)
        pickTicketPrintOption(nullable:true, maxSize:10)
    }
}
