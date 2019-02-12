package com.foysonis.alert

class AlertUser {

    Alert alert
    String receiverId
    String companyId
    Boolean isViewed
    Date viewedDate

    static belongsTo = [Alert]

    static constraints = {
        receiverId(blank:false)
        companyId(blank:false)
        isViewed(blank:false)
        viewedDate(blank:false, nullable: true)
    }
}
