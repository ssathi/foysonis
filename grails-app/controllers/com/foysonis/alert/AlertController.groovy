package com.foysonis.alert


import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class AlertController extends RestfulController<Alert> {

    def alertService
    def userService

    static responseFormats = ['json', 'xml']

    AlertController() {
        super(Alert)
    }

    def index() {}
    def newAlert(){ }

    def confirmAlert(){
        def alert = Alert.findById(params.alertId)
        if (alertService.confirmAlert(session.user, alert))
            redirect(controller: 'dashboard', action: 'index')
    }

    def getAlerts = {
        respond alertService.getAllAlerts(session.user)
    }

//create alert
    def send(){
        def alert = new Alert(params)
        alert.properties = [alertType: 'USERALERT',
                            companyId: session.user.companyId,
                            senderId: session.user.username,
                            expiredDate: new Date()+10]
        alert.save(flush: true, failOnError: true)


        Set<String> items = Arrays.asList(params.username.split("\\s*,\\s*"));

        if(items.contains('all users')){

            alert.alertType ='COMPANYALERT'
            alert.save(flush: true, failOnError: true)

        }
        else{

            for (item in items)
            {
                def user = User.findByCompanyIdAndUsername(session.user.companyId, item)
                def alertUser = new AlertUser()
                alertUser.companyId = user.companyId
                alertUser.receiverId = user.username
                alertUser.alert = alert
                alertUser.isViewed = false;
                alertUser.save(flush: true, failOnError: true)

            }
        }

        flash.success = message(code: "alertSend.success.message")
        //render view: 'newAlert.gsp'
        redirect(controller: 'dashboard', action: 'index')
    }


}


