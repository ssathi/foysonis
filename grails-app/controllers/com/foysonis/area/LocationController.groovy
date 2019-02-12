package com.foysonis.area

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import com.foysonis.billing.CompanyBilling

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class LocationController extends RestfulController<Location> {
    def locationService
    def areaService

    static responseFormats = ['json', 'xml']

    LocationController() {
        super(Location)
    }

    def getAllLocationsByArea = {
        respond locationService.getAllLocationsByArea(session.user.companyId, params['areaId'])

    }


    def checkLocationBarcodeExist = {
        respond locationService.checkLocationIdAndLocationBarcodeExist(session.user.companyId, params['locationBarcode'], params['locationId'])
    }

    def checkLocationIdExist = {
        respond locationService.checkLocationIdExist(session.user.companyId, params['locationId'])
    }

    def getCompanyActiveLocations = {
        respond locationService.getCompanyActiveLocations(session.user.companyId)
    }

    def getCompanyAllLocations = {
        respond locationService.getCompanyAllLocations(session.user.companyId, params.keyword)
    }

    def getCompanyAllUnblockedLocations = {
        respond locationService.getCompanyAllUnblockedLocations(session.user.companyId, params.keyword)
    }

    def adminAreaList() {
        def area = areaService.getAllAreas(session.user.companyId)
        render(view:"adminAreaList", model:[area:area])
    }

    def save() {
        def jsonObject = request.JSON
        def location = new Location(jsonObject)
        location.properties = [companyId  : session.user.companyId,
                               createdDate : new Date()]

        if (jsonObject.isBlocked == "") {

            location.isBlocked = false
        }

        if(jsonObject.areaId == 'DEFAULT') {
            location.areaId = null
        }

        def responseMsg = [:]
        def companyBillData = CompanyBilling.findByCompanyId(session.user.companyId)
        def totalLocationCount = Location.countByCompanyId(session.user.companyId)
        int locationMaxLimitFromApp = grailsApplication.config.getProperty('company.paymentPlan.individual.locationMaxLimit').toInteger()
        if (companyBillData && companyBillData.currentPlanDetail == 'Individual' && totalLocationCount >=locationMaxLimitFromApp) {
            responseMsg.status = 'error'
            responseMsg.message = message(code: "company.paymentPlan.locationMaxLimit.message", args: [locationMaxLimitFromApp])
            respond responseMsg
        }        
        else{
            location.save(flush: true, failOnError: true)
            responseMsg.status = 'success'
            responseMsg.data = location
            respond responseMsg
        }
        
    }

    def deleteLocation(){
        def jsonObject = request.JSON
        locationService.deleteLocation(jsonObject.companyId, jsonObject.locationId)
    }
//
    def blockLocation = {
        def jsonObject = request.JSON
        respond locationService.blockLocation(session.user.companyId,jsonObject)
    }

    def unBlockLocation = {
        def jsonObject = request.JSON
        respond locationService.unBlockLocation(session.user.companyId,jsonObject)
    }

    def checkInventoryForLocation = {
        respond locationService.checkInventoryForLocation(session.user.companyId, params.locationId)
    }

    //

    def importLocation() {
        def jsonObject = request.JSON

        def responseMsg = [:]
        def companyBillData = CompanyBilling.findByCompanyId(session.user.companyId)
        def totalLocationCount = Location.countByCompanyId(session.user.companyId)
        if (companyBillData && companyBillData.currentPlanDetail == 'Individual') {
            int locationMaxLimitFromApp = grailsApplication.config.getProperty('company.paymentPlan.individual.locationMaxLimit').toInteger()
                if (jsonObject.size()>=locationMaxLimitFromApp) {
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.locationMaxLimit.message", args: [locationMaxLimitFromApp])
                    respond responseMsg                    
                }
                else if (totalLocationCount >=locationMaxLimitFromApp) {                   
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.locationMaxLimit.message", args: [locationMaxLimitFromApp])
                    respond responseMsg                    
                }
                
                else if ((totalLocationCount + jsonObject.size()) >=locationMaxLimitFromApp) {    
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.locationMaxLimit.message", args: [locationMaxLimitFromApp])
                    respond responseMsg
                }
                else{
                    for (jsonObject1 in jsonObject) {
                        def location = new Location()
                        location.companyId = session.user.companyId
                        location.locationId = jsonObject1[0]
                        location.areaId = jsonObject1[1]
                        location.locationBarcode = jsonObject1[2]
                        location.travelSequence = jsonObject1[3].toInteger()
                        location.isBlocked = jsonObject1[4].toBoolean()
                        location.createdDate = new Date()

                        if (jsonObject1[4] == "") {
                            location.isBlocked = false
                        }

                        if(jsonObject1[1] == 'DEFAULT') {
                            location.areaId = null
                        }
                        location.save(flush: true, failOnError: true)                        
                    }
                    responseMsg.status = 'success'
                    respond responseMsg                    
                }
        }
        else{
            for (jsonObject1 in jsonObject) {
                def location = new Location()
                location.companyId = session.user.companyId
                location.locationId = jsonObject1[0]
                location.areaId = jsonObject1[1]
                location.locationBarcode = jsonObject1[2]
                location.travelSequence = jsonObject1[3].toInteger()
                location.isBlocked = jsonObject1[4].toBoolean()
                location.createdDate = new Date()

                if (jsonObject1[4] == "") {
                    location.isBlocked = false
                }

                if(jsonObject1[1] == 'DEFAULT') {
                    location.areaId = null
                }

                location.save(flush: true, failOnError: true)
            }
            responseMsg.status = 'success'
            respond responseMsg
        }

   }

    // Added for iOS development
    def validateLocationForMovePallet = {
        respond locationService.validateLocationForMovePallet(springSecurityService.currentUser.companyId, params.locationId)
    }

    def downloadLocationCsvFile = {
        def reportPath = servletContext.getRealPath('/sampleCSV/')
        def file = new File(reportPath+"/"+"LocationSampleCsv.csv")

        if (file.exists()) {
           response.setContentType("application/octet-stream")
           response.setHeader("Content-disposition", "filename=${file.name}")
           response.outputStream << file.bytes
           return
        }        
    }

}

