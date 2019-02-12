package com.foysonis.orders

import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController
import groovy.time.TimeCategory

@Secured(['ROLE_USER','ROLE_ADMIN'])
class CustomerController extends RestfulController<Customer> {

    def customerService
    def sessionFactory
    def listValueService
    def springSecurityService
    def billingService

    static responseFormats = ['json', 'xml']

    CustomerController() {
        super(Customer)
    }

    def index() {
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
        def pageTitle = "Customers";
        [pageTitle:pageTitle]
    }

    def customerSearch () {
        respond customerService.customerSearch(session.user.companyId, params.customerId)
    }


    def customerSave() {
        def jsonObject = request.JSON
        respond customerService.customerSave(session.user.companyId, jsonObject)
    }


    def getCustomerShippingAddress() {
        respond customerService.getCustomerShippingAddress(session.user.companyId, params['customerId'])
    }

    def getCustomerShippingAddressWithShipment() {
        respond customerService.getCustomerShippingAddressWithShipment(session.user.companyId, params['customerId'])
    }

    def getCustomerByGrid() {
        respond customerService.getCustomerByGrid(session.user.companyId)
    }


    def deleteCustomer = {
        def jsonObject = request.JSON
        respond customerService.deleteCustomer(session.user.companyId, jsonObject)
    }


    def updateCustomer = {
        def jsonObject = request.JSON
        respond customerService.updateCustomer(session.user.companyId, jsonObject)

    }

    def createCustomerShippingAddress = {
        def jsonObject = request.JSON
        CustomerAddress customerAddress = new CustomerAddress()
        customerAddress.companyId = session.user.companyId
        customerAddress.customerId = jsonObject.customerId
        customerAddress.addressType = 'shipping'
        customerAddress.streetAddress = jsonObject.streetAddress
        customerAddress.city = jsonObject.city
        customerAddress.state = jsonObject.state
        customerAddress.postCode = jsonObject.postCode
        customerAddress.country = jsonObject.country
        customerAddress.isDefault = false
        respond customerService.createCustomerShippingAddress(customerAddress)
    }

    def updateShippingAddress = {
        def jsonObject = request.JSON
        //CustomerAddress customerAddressUpdate = new CustomerAddress()
        CustomerAddress customerAddressUpdate = CustomerAddress.findByCompanyIdAndCustomerIdAndId(session.user.companyId,jsonObject.customerId,jsonObject.shippingId)
        customerAddressUpdate.companyId = session.user.companyId
        customerAddressUpdate.customerId = jsonObject.customerId
        customerAddressUpdate.streetAddress = jsonObject.streetAddress
        customerAddressUpdate.city = jsonObject.city
        customerAddressUpdate.state = jsonObject.state
        customerAddressUpdate.postCode = jsonObject.postCode
        customerAddressUpdate.country = jsonObject.country
        respond customerService.createCustomerShippingAddress(customerAddressUpdate)
    }

    def deleteShippingAddress = {
        respond customerService.deleteShippingAddress(session.user.companyId, params.customerId, params.shippingId)
    }

    def makeDefaultShippingAddress = {
        respond customerService.makeDefaultShippingAddress(session.user.companyId, params.customerId, params.addressId)
    }

    def checkIsCustomerAddressInUse = {
        respond customerService.checkIsCustomerAddressInUse(session.user.companyId, params.shippingId)
    }

    def checkOrderExistForCustomer() {
        respond customerService.checkOrderExistForCustomer(session.user.companyId,params.customerId)
    }


    def getCountries = {
        respond listValueService.getCountries();
    }


    def getCountryCodes = {
        respond listValueService.getCountryCodes();
    }
    
    def getCustomerByIdAndCompany = {
        respond customerService.getCustomerByIdAndCompany(session.user.companyId,params.customerId)
    }

}
