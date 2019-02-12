package com.foysonis.alert

import grails.transaction.Transactional
import groovy.time.TimeCategory

@Transactional
class AlertService {

    def getAllAlerts(user){
        def alerts = Alert.findAll("from Alert as a where (a.companyId = ? OR a.companyId = NULL) AND expiredDate >= NOW() order by createdDate DESC ", [user.companyId])
        def alertList = []

        for (alert in alerts) {
            def alertUser = AlertUser.findByAlertAndCompanyIdAndReceiverId(alert, user.companyId, user.username)
            if ((!alertUser && alert.alertType != "USERALERT" ) || (alertUser))
                alertList.add(alert)

        }
        return alertList
    }

    def getAlerts(user, count){
        def alerts = Alert.findAll("from Alert as a where (a.companyId = ? OR a.companyId = NULL) AND expiredDate >= NOW() order by createdDate DESC ", [user.companyId])
        def alertList = []

        for (alert in alerts) {
            def alertUser = AlertUser.findByAlertAndCompanyIdAndReceiverId(alert, user.companyId, user.username)
            if ((!alertUser && alert.alertType != "USERALERT" )|| (alertUser && alertUser.isViewed == false))
                alertList.add(alert)
            if (alertList.size() == count)
                break

        }
        return alertList
    }

    def confirmAlert(receiver, alert){
        def alertUser = AlertUser.findByAlertAndCompanyIdAndReceiverId(alert, receiver.companyId, receiver.username)
        if (!alertUser){
            alertUser = new AlertUser()
            alertUser.companyId = receiver.companyId
            alertUser.receiverId = receiver.username
            alertUser.alert = alert
        }
        alertUser.isViewed = true;
        alertUser.viewedDate = new Date()
        return alertUser.save(flush: true, failOnError: true)
    }
}

