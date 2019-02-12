package com.foysonis.area

import com.foysonis.item.EntityAttributeService
import com.foysonis.item.ListValue
import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

import com.foysonis.inventory.InventoryEntityAttribute

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class AreaController extends RestfulController<Area>  {

    def areaService
    def entityAttributeService
    def springSecurityService
    def billingService

    static responseFormats = ['json', 'xml']

    AreaController() {
        super(Area)
    }


    def adminAreaList = {
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
        def area = Area.list()
        def pageTitle = "Locations & Areas";
        [areaList:area, pageTitle:pageTitle]
    }

    def getAllAreas = {
        respond areaService.getAllAreas(session.user.companyId)
    }

    def checkAreaIdExist = {
        respond areaService.checkAreaIdExist(session.user.companyId, params['areaId'])
    }

    def  saveArea() {
        def jsonObject = request.JSON
        def area = new Area(jsonObject)
        area.companyId = session.user.companyId
        areaService.saveArea(area, request.JSON)
    }

    def  updateArea() {
        def jsonObject = request.JSON
        def area = areaService.getArea(jsonObject.companyId, jsonObject.areaId)
        area.areaName = jsonObject.areaName
        area.isStorage =  jsonObject.isStorage
        area.isPickable =  jsonObject.isPickable
        area.isProcessing =  jsonObject.isProcessing
        area.isKitting = jsonObject.isKitting
        area.isStaging =  jsonObject.isStaging
        area.isPnd =  jsonObject.isPnd
        area.isBin =  jsonObject.isBin
        areaService.updateArea(area, request.JSON)
    }

    def updateBinArea(){
        def jsonObject = request.JSON
        def area = areaService.getArea(jsonObject.companyId, jsonObject.areaId)
        area.areaName = jsonObject.areaName
        area.isStorage =  jsonObject.isStorage
        area.isPickable =  jsonObject.isPickable
        area.isProcessing =  jsonObject.isProcessing
        area.isStaging =  jsonObject.isStaging
        area.isPnd =  jsonObject.isPnd
        area.isBin =  jsonObject.isBin
        areaService.updateBinArea(area, request.JSON)        
    }

    def checkPalletAndCaseExistForArea = {
        respond areaService.checkPalletAndCaseExistForArea(session.user.companyId, params['areaId'])
    }

    def checkLowestUOMCaseExistForArea = {
        respond areaService.checkLowestUOMCaseExistForArea(session.user.companyId, params['areaId'])
    }

    def getProcessingAreas = {
        respond areaService.getProcessingAreas(session.user.companyId)
    }

    def getReplenishmentAreaIds = {
        respond areaService.getReplenishmentAreaIds(session.user.companyId, params['pickedLevels'])
    }

    def getArea ={
        respond areaService.getArea(session.user.companyId, params['areaId'])
    }

    def getEntityAttributesByAreaId = {
        respond entityAttributeService.getEntityAttributesByConfigKey(session.user.companyId, params['areaId'])
    }

    def deleteArea() {
        def jsonObject = request.JSON
        def area = areaService.getArea(jsonObject.companyId, jsonObject.areaId)
        areaService.deleteArea(area)
    }

    def addAttributeValue(){

        def jsonObject = request.JSON
        def listValue = new ListValue(jsonObject)
        listValue.properties = [companyId :session.user.companyId,
                                createdDate:new Date(),
                                displayOrder:0 ]

        respond listValue.save(flush: true, failOnError: true)
    }

    def searchArea = {
        respond areaService.searchArea(session.user.companyId, params.areaId, params.locationId)
    }

}
