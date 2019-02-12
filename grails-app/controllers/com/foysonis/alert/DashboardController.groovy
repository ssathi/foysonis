package com.foysonis.alert


import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory
import com.foysonis.util.FoysonisLogger


@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class DashboardController {

    def alertService
    def springSecurityService
    def billingService
    FoysonisLogger logger = FoysonisLogger.getLogger(DashboardController.class);

    def index() {

        logger.info("Loading dashboard.." )

        def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
        if (billingData) {
            def trialEndDate = null
            use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
            if (billingData.isTrial == true && trialEndDate < new Date()) {

                if(springSecurityService.currentUser.adminActiveStatus == true){
                    redirect(controller:"userAccount",action:"index")
                    return
                }
                else{
                    redirect(controller:"userAccount",action:"index")
                    return
                }


            }
            else if(springSecurityService.currentUser.isTermAccepted != true){
                redirect(controller:"userAccount",action:"index")
                return
            }
        }
        else if(springSecurityService.currentUser.isTermAccepted != true){
            redirect(controller:"userAccount",action:"index")
            return
        }



        def pageTitle = "Dashboard";

        session.user = springSecurityService.currentUser
        [alerts: alertService.getAlerts(session.user, 5), pageTitle:pageTitle]
    }


}

