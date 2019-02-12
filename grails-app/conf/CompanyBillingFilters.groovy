import groovy.time.TimeCategory
import grails.plugin.springsecurity.annotation.Secured

class CompanyBillingFilters {

    def billingService
    def springSecurityService

    def filters = {



//        loginBilling(controller:'dashboard|inventory|order|receiving|customer|shipping|picking|report|area|item|settings', action:'*') {
//            before = {
//                def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
//                if (billingData) {
//                    def trialEndDate = null
//                    use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
//                    if (billingData.isTrial == true && trialEndDate < new Date()) {
//
//                        if(springSecurityService.currentUser.adminActiveStatus == true){
//                            redirect(controller:"billing",action:"index")
//                        }
//                        else{
//                            redirect(controller:"userAccount",action:"index")
//                        }
//
//                        return false
//
//
//                    }
//                    else if(springSecurityService.currentUser.isTermAccepted != true){
//                        redirect(controller:"userAccount",action:"index")
//                    }
//                }
//                else if(springSecurityService.currentUser.isTermAccepted != true){
//                    redirect(controller:"userAccount",action:"index")
//                }
//            }
//        }
    }
}