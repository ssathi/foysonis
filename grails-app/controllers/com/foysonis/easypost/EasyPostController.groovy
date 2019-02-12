package com.foysonis.easypost

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional
import static org.springframework.http.HttpStatus.*
import grails.rest.RestfulController

import com.foysonis.user.Company

@Secured(['ROLE_USER','ROLE_ADMIN'])
class EasyPostController extends RestfulController<Company> {

    static responseFormats = ['json', 'xml']
    
    EasyPostController() {
        super(Company)
    }   

    def easyPostService;
    def springSecurityService

    def testApiKey() {
        respond easyPostService.getTestApiKey(springSecurityService.currentUser.companyId);
    }

    def prodApiKey() {
        respond easyPostService.getProdApiKey(springSecurityService.currentUser.companyId);
    }

    def isValidProdKey = {
        respond easyPostService.validateProdKey(params.key)
    }

    def isValidTestKey = {
        respond easyPostService.validateTestKey(params.key)
    }

    def findAllCarriers = {
        respond easyPostService.findAllCarriers();
    }

    def findServiceLevel = {
        respond easyPostService.findServiceLevelByCarrier(params.carrier)
    }

    def performEasyPostCall() {
        respond easyPostService.performEasyPost(springSecurityService.currentUser.companyId,params.shippingAddressId, params.carrierCode, params.serviceLevel, params.easyPostWeight, params.shipmentId);
    }

    def easyPostRefund = {
        respond easyPostService.refund(springSecurityService.currentUser.companyId, params.easyPostShipmentId, params.systemShipmentId)
    }

}
