package com.foysonis.clientBilling

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN'])
class ClientBillingController extends RestfulController<BillingItem> {

    def springSecurityService
    def clientBillingService
    def billingService

	static responseFormats = ['json', 'xml']

    ClientBillingController() {
        super(BillingItem)
    }

    def setupRates = {
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

        session.user = springSecurityService.currentUser
        def pageTitle = "Setup Rates";
        [pageTitle:pageTitle]
    }  

    def generateInvoice = {
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

        session.user = springSecurityService.currentUser
        def pageTitle = "Generate Invoice";
        [pageTitle:pageTitle]
    } 

    def commercialInvoice = {
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

        session.user = springSecurityService.currentUser
        def pageTitle = "Commercial Invoice";
        [pageTitle:pageTitle]
    } 

    def getAllBillingItem = {
    	def companyId = session.user.companyId
    	respond clientBillingService.getAllBillingItem(companyId)
    }  
    def getAllSubBillingItem = {
    	respond clientBillingService.getAllSubBillingItem(session.user.companyId,params.headingId)
    }

    def saveBillingItem = {
    	def companyId = session.user.companyId
    	def jsonObject = request.JSON
	 	respond clientBillingService.saveBillingItem(companyId, jsonObject)
    }

    def saveBillingInvoice = {
    	def companyId = session.user.companyId
    	def jsonObject = request.JSON
	
	 	respond clientBillingService.saveBillingInvoice(companyId, jsonObject)
    }

    def generateInvoiceNumber = {
    	def companyId = session.user.companyId
		respond clientBillingService.generateInvoiceNumber(companyId)	
    }
    def getAllCommercialBillingItem = {
        def companyId = session.user.companyId
        respond clientBillingService.getAllCommercialBillingItem(companyId)
    }  

    def saveCommercialInvoice = {
        def companyId = session.user.companyId
        def jsonObject = request.JSON
        respond clientBillingService.saveCommercialInvoice(companyId, jsonObject)
    }

    def getCommercialInvoiceData = {
        respond clientBillingService.getCommercialInvoiceData(session.user.companyId, params.commercialInvoiceNumber)
    }

    def generateInvoiceNumberForCustomReport = {
        def companyId = session.user.companyId
        respond clientBillingService.generateInvoiceNumberForCustomReport(companyId)   
    }    

}
