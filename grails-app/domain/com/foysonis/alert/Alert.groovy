package com.foysonis.alert

class Alert {

    int id
    String alertType
    String companyId
    String senderId
    String message
    Date createdDate = new Date();
    Date expiredDate


    static hasMany = [AlertUser]

    static constraints = {

        id(blank:false)
        alertType(blank:false)
        companyId(blank:true, nullable: true)
        senderId(blank:false)
        message(blank:false)
        createdDate(blank:false)
        expiredDate(blank:false)
    }
}
