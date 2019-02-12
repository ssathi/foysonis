package com.foysonis.picking

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql
import com.foysonis.orders.Shipment
import com.foysonis.inventory.InventoryEntityAttribute

import com.foysonis.orders.ShipmentLine
import com.foysonis.orders.Orders
import com.foysonis.orders.OrderLine

@Secured(['ROLE_USER','ROLE_ADMIN'])
class PickingController extends RestfulController<PickWork> {
    def sessionFactory
    def allocationService
    def pickingService
    def billingService

    def springSecurityService

    static responseFormats = ['json', 'xml']

    PickingController() {
        super(PickWork)
    }

    def palletPick = {
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
        def pageTitle = "Pallet Picks & Replenishment"
        [pageTitle:pageTitle]
    }

    def pickingStatus(){
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
        def pageTitle = "Allocation & Pick Status"
        [pageTitle:pageTitle]
    }

    def index(){
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
        def pageTitle = "List Picking"
        [pageTitle:pageTitle]
    }

    def getAllPalletPicksByShipment = {
        respond allocationService.getAllPalletPicksByShipment(session.user.companyId, params.shipmentId)
    }

    def getAllPickListDataByShipment = {

        respond allocationService.getAllPickListDataByShipment(session.user.companyId, params.shipmentId)

    }

    def getPickWorkData = {

        respond allocationService.getPickWorkData(session.user.companyId, params.pickListId)

    }

    def getReplenishmentWorkDataByShipment() {

        def shipmentId = params.shipmentId
        def companyId = session.user.companyId

        respond allocationService.getReplenishmentWorkDataByShipment(shipmentId, companyId)
    } 

    def getPickWorkDataByReplenWork() {

        def replenReference = params.replenReference
        def companyId = session.user.companyId

        respond allocationService.getPickWorkDataByReplenWork(replenReference, companyId)
    }     


    def searchShipment = {

        def searchData = [:]        

        searchData.companyId = session.user.companyId
        searchData.shipmentId = params.shipmentId
        searchData.orderNumber = params.orderNumber
        searchData.allocationStatus = params.allocationStatus
        searchData.pickStatus = params.pickStatus
        searchData.completedShipment = params.completedShipment
        searchData.fromShipmentCreation = params.fromShipmentCreation
        searchData.toShipmentCreation = params.toShipmentCreation

        respond allocationService.searchShipment(searchData)
        //respond searchData

    }



    def getAllShipmentLinesByShipmentId= {
        respond allocationService.getAllShipmentLinesByShipmentId(session.user.companyId, params.shipmentId)

    }

    def getSelectedShipmentDataByShipmentId = {
        respond allocationService.getSelectedShipmentDataByShipmentId(session.user.companyId, params.shipmentId)
    }   

    def checkCompletedPicks = {
        respond allocationService.checkCompletedPicks(session.user.companyId,  params.shipmentId)
    }

    def cancelAllocation = {
        respond allocationService.cancelAllocation(session.user.companyId, params.shipmentId, params.orderNum)
    }



//(pallet pick & Replens)
    def findPalletPick(){
        respond pickingService.findPalletPick(session.user.companyId)
    }

    def findCompletedPalletPick(){
        respond pickingService.findCompletedPalletPick(session.user.companyId)
    }

    def confirmPalletLpnForPalletPick(){
        respond pickingService.confirmPalletLpnForPalletPick(session.user.companyId, session.user.username, params.workReferenceNumber, params.lpn,
                params.level, params.locationId, params.itemId, params.inventoryStatus, params.quantity, params.handlingUom)
    }

    def confirmDestinationLocationForPalletPick() {
        respond pickingService.confirmDestinationLocationForPalletPick(session.user.companyId, params.workReferenceNumber, params.lpn, params.destinationLocationId, params.shipmentId)
    }

    def findPickWorkStatus(){
        respond pickingService.findPickWorkStatus(session.user.companyId, params.workReferenceNumber)
    }


    def findActiveAndInProcessReplenishment(){
        respond pickingService.findActiveAndInProcessReplenishment(session.user.companyId)
    }

    def findCompletedAndExpiredReplenishment(){
        respond pickingService.findCompletedAndExpiredReplenishment(session.user.companyId)
    }

    def findCompletedReplenishment(){
        respond pickingService.findCompletedReplenishment(session.user.companyId)
    }

    def findExpiredReplenishment(){
        respond pickingService.findExpiredReplenishment(session.user.companyId)
    }

    def findPickWorks(){
        respond pickingService.findPickWorks(session.user.companyId, params.selectedRowPick)
    }

    def getInventoryByLocation(){
        respond pickingService.getInventoryByLocation(session.user.companyId, params.selectedLocation)
    }

    def getLpnByLocation(){
        respond pickingService.getLpnByLocation(session.user.companyId, params.selectedSourceLocation)
    }


    def confirmPalletLpn(){
        respond pickingService.confirmLpn(session.user.companyId, session.user.username, params.replenReference, params.lpn)
    }


    def confirmDestinationLocation() {
        respond pickingService.confirmDestinationLocation(session.user.companyId, params.replenReference, params.destinationLocationId, params.lpn, params.workReferenceNumber)
    }


    def findReplenishment(){
        respond pickingService.findReplenishment(session.user.companyId, params.replenReference)
    }


    def findItem(){
        respond pickingService.findItem(session.user.companyId, params.selectedItem)
    }


    def confirmCaseLpn(){
        respond pickingService.confirmCaseLpn(session.user.companyId, params.selectedLocation, params.selectedLpn)
    }


    def confirmCaseLpnForCase(){
        respond pickingService.confirmCaseLpnForCase(session.user.companyId, params.selectedLocation)
    }


    def getLpnByLocationForCase() {
        respond pickingService.getLpnByLocationForCase(session.user.companyId, params.selectedSourceLocation)
    }


    def findPickWorksByReplensWork() {
        respond pickingService.findPickWorksByReplensWork(session.user.companyId, params.selectedPickWork)
    }


    //get inventories
    def getInventoryByLpn(){
        respond pickingService.getInventoryByLpn(session.user.companyId, params.selectedLpn)
    }

    def getInventoryByAssociateLpn(){
        respond pickingService.getInventoryByAssociateLpn(session.user.companyId, params.selectedAssociateLpn)
    }

    def getInventoryByPalletLpn(){
        respond pickingService.getInventoryByPalletLpn(session.user.companyId, params.selectedWorkReference)
    }

    //

    //


    def getAllPickWorkByPickList = {

        def startTime = System.currentTimeMillis()
        log.info(" startTime : " + startTime)

        respond pickingService.getAllPickWorkByPickList(session.user.companyId, params.pickListId)



        def endTime = System.currentTimeMillis()

        log.info(" endTime : " + endTime)
        log.info(" duration : " + (endTime-startTime))
    }

    def getPickWorkByPickList = {
        respond pickingService.getPickWorkByPickList(session.user.companyId, params.pickListId)
    }

    def checkAllPickLevelEach = {


        def pickListId = params.pickListId
        def companyId = session.user.companyId
        respond pickingService.checkAllPickLevelEach(companyId, pickListId, 'E')
    }


    def searchPickList = {
        respond pickingService.searchPickList(session.user.companyId, params.pickListStatus, params.pickListId, params.customerName)
    }    

    def checkPalletIdExist = {
        respond pickingService.checkPalletIdAndCaseExist(session.user.companyId, params.palletId)
    }

    def checkCaseIdExist = {
        respond pickingService.checkPalletIdAndCaseExist(session.user.companyId, params.caseId)
    }    

    def startPalletListPicking = {

        println("start picking json request." + request)
        println("start picking json request JSON" + request.JSON)

        def companyId = session.user.companyId
        def userId = session.user.username
        def jsonObject = request.JSON

        pickingService.startPalletListPicking(companyId, userId,  jsonObject)

    }

    def startPalletListPickingIOS = {

        def companyId = session.user.companyId
        def userId = session.user.username

        def jsonObject = request.JSON
        jsonObject.palletId = params.palletId
        pickingService.startPalletListPicking(companyId, userId,  jsonObject)

    }

    def startCaseListPicking = {

        def companyId = session.user.companyId
        def userId = session.user.username
        def jsonObject = request.JSON

        pickingService.startCaseListPicking(companyId, userId,  jsonObject)

    }

    def confirmPickWork = {

        def startTime = System.currentTimeMillis()

        def jsonObject = request.JSON
        respond pickingService.confirmPickWork(session.user.companyId, session.user.username, jsonObject)

        def endTime = System.currentTimeMillis()
        def duration = endTime - startTime

        log.info(" startTime : " + startTime)
        log.info(" endTime : " + endTime)
        log.info(" duration : " + duration)
    }

    def updateSkippedPickWork = {
        def jsonObject = request.JSON
        respond pickingService.updateSkippedPickWork(session.user.companyId, jsonObject.workReferenceNumber)
    }

    def cancelPickWork = {
        respond pickingService.cancelPickWork(session.user.companyId, params.workReferenceNumber, params.reAllocate, params.cancelPickReason)
    }

    def prepareAllocation = {

        def startTime = new Date()
        println("ShipmentId : " + params.shipmentId + " - Start Time : "+ startTime.getTime())

        respond allocationService.prepareAllocation(session.user.companyId, params.shipmentId, params.destinationLocation, session.user.username, null)

        def endTime = new Date()
        println("ShipmentId : " + params.shipmentId + " - End Time : "+ endTime.getTime())
        println("ShipmentId : " + params.shipmentId + " - Duration Time : "+ (endTime.getTime()-startTime.getTime()))
    }

    def prepareKittingAllocation = {
        def startTime = new Date()
        println("kittingOrderNumber : " + params.kittingOrderNumber + " - Start Time : "+ startTime.getTime())

        respond allocationService.prepareKittingAllocation(session.user.companyId, params.kittingOrderNumber, params.destinationLocation, session.user.username)

        def endTime = new Date()
        println("kittingOrderNumber : " + params.kittingOrderNumber + " - End Time : "+ endTime.getTime())
        println("kittingOrderNumber : " + params.kittingOrderNumber + " - Duration Time : "+ (endTime.getTime()-startTime.getTime()))

    }

    def checkPalletIdMatchesPicking = {
        respond pickingService.checkPalletIdMatchesPicking(session.user.companyId, params.orderLineNumber, params.locationId, params.palletId, params.pickType)
    }

    def checkCaseIdMatchesPicking = {
        respond pickingService.checkCaseIdMatchesPicking(session.user.companyId, params.orderLineNumber, params.locationId, params.caseId, params.pickType)
    }

    def getPalletIdQtyForValidation = {
        respond pickingService.getPalletIdQtyForValidation(session.user.companyId, params.locationId, params.palletId)
    }

    def getCaseIdQtyForValidation = {
        respond pickingService.getCaseIdQtyForValidation(session.user.companyId, params.locationId, params.caseId)
    }

    def getLocationForValidation = {
        String companyId = springSecurityService.currentUser.companyId
        respond pickingService.getLocationForValidation(session.user.companyId, params.locationId, params.itemId, params.invStatus)
    }

    def getPalletDataForValidation = {
        String companyId = springSecurityService.currentUser.companyId
        respond pickingService.getPalletDataForValidation(session.user.companyId, params.locationId, params.itemId, params.invStatus)
    }

    def checkItemCaseTracked = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.checkItemCaseTracked(companyId, params.workReferenceNumber)
    }

    def depositePicks = {
        def jsonObject = request.JSON
        respond pickingService.depositePicks(session.user.companyId, session.user.username, jsonObject)
    }

    def validateDestinationLocation = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.validateDestinationLocation(companyId, params.destinationLocation)
    }

    def getAllPickListByPickListId = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getAllPickListByPickListId(companyId, params.pickListId)
    }

    def getItemAndStatusByOrderLine = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getItemAndStatusByOrderLine(companyId, params.workReferenceNumber)
    }

    def getPickStatusCount = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getPickStatusCount(companyId)
    }

    def getTodayPerformedPicks = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getTodayPerformedPicks(companyId)
    }

    def getUserPicks = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getUserPicks(companyId, params["userPicksDuration"])
    }

    //pnd location
    def getPNDLocationByArea = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getPNDLocationByArea(companyId)
    }


    def getPickListByKittingOrderNumber = {
        String companyId  = springSecurityService.currentUser.companyId
        respond pickingService.getPickListByKittingOrderNumber(companyId, params.orderNumber)
    }


    def searchPickListForIOS = {
        String companyId = springSecurityService.currentUser.companyId
        String keyword = params.keyword
        respond pickingService.searchPickListForIOS(companyId, keyword)
    }

    def priorDayInventoryPicked = {
        respond pickingService.priorDayInventoryPicked(springSecurityService.currentUser.companyId)
    }

    def getTotalDepositedPickCountByPickList = {
        respond pickingService.getTotalDepositedPickCountByPickList(springSecurityService.currentUser.companyId, params.pickListId) 
    }

    def getWavePickWorks(){
        respond pickingService.getWavePickWorks(session.user.companyId, params.waveNumber)
    }

}
