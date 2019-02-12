package com.foysonis.orders

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class WaveController extends RestfulController<Wave> {

    def springSecurityService
    def waveService

    static responseFormats = ['json', 'xml']

    WaveController() {
        super(Wave)
    }

    def waveScreen() {
        session.user = springSecurityService.currentUser
        def pageTitle = "Waving";
        [pageTitle: pageTitle]
    }

    def packOut() {
        session.user = springSecurityService.currentUser
        def pageTitle = "Pack out";
        [pageTitle: pageTitle]
    }


    def searchOrderForWave = {
        def orderSearchData = [:]
        orderSearchData.orderNumber = params.orderNumber
        orderSearchData.customerName = params.customerName
        orderSearchData.fromEarlyShipDate = params.fromEarlyShipDate
        orderSearchData.toEarlyShipDate = params.toEarlyShipDate
        orderSearchData.fromLateShipDate = params.fromLateShipDate
        orderSearchData.toLateShipDate = params.toLateShipDate
        orderSearchData.requestedShipSpeed = params.requestedShipSpeed
        orderSearchData.maxOrderNum = params.maxOrderNum

        respond waveService.searchOrderForWave(session.user.companyId, orderSearchData)

    }

    def planWave = {
        def jsonObject = request.JSON
        respond waveService.planWave(springSecurityService.currentUser.companyId, jsonObject)
    }

    def getAllWaveNumbers = {
        def waveSearchData = [:]
        waveSearchData.waveNumber = params.waveNumber
        waveSearchData.waveStatus = params.waveStatus
        respond waveService.getAllWaveNumbers(springSecurityService.currentUser.companyId, waveSearchData)
    }

    def getAllOrdersDataByWaveNumbers = {
        respond waveService.getAllOrdersDataByWaveNumbers(springSecurityService.currentUser.companyId, params.waveNum)
    }

    def getAllShipmentAndLinesCountData = {
        respond waveService.getAllShipmentAndLinesCountData(springSecurityService.currentUser.companyId, params.waveNumber)
    }

    def cancelWave = {
        respond waveService.cancelWave(springSecurityService.currentUser.companyId, params.waveNumber)
    }

    def getAllOrdersDataForViewDetails = {
        respond waveService.getAllOrdersDataForViewDetails(springSecurityService.currentUser.companyId, params.waveNumber)
    }

    def prepareWaveAllocation = {
        def jsonObject = request.JSON
        Wave wave = Wave.findByCompanyIdAndWaveNumber(springSecurityService.currentUser.companyId, jsonObject.waveNumber)
        respond waveService.prepareWaveAllocation(springSecurityService.currentUser.companyId, jsonObject.stagingLocationId, springSecurityService.currentUser.username, wave, jsonObject.maxNoOfPicks, jsonObject.pickTicketsPrintedBy)
    }

    def getPackOutShipment = {
        respond waveService.getPackOutShipment(springSecurityService.currentUser.companyId, params.packoutId)
    }

    def displayPackoutConfirm = {
        respond waveService.displayPackoutConfirm(springSecurityService.currentUser.companyId, params.shipmentLineId)
    }

    def displayPackoutUnconfirm = {
        respond waveService.displayPackoutUnconfirm(springSecurityService.currentUser.companyId, params.shipmentLineId)
    }

    def confirmShipmentLine = {
        respond waveService.confirmShipmentLine(springSecurityService.currentUser.companyId,
                springSecurityService.currentUser.username,
                params.shipmentLineId,
                params.shipmentContainerId)

    }


    def confirmAllShipmentLines = {
        respond waveService.confirmAllShipmentLines(springSecurityService.currentUser.companyId,
                springSecurityService.currentUser.username,
                params.shipmentId,
                params.shipmentContainerId)

    }

    def unConfirmShipmentLine = {
        respond waveService.unConfirmShipmentLine(springSecurityService.currentUser.companyId,
                params.shipmentLineId)

    }

    def closeoutShipment = {
        respond waveService.closeoutShipment(springSecurityService.currentUser.companyId,
                                            params.shipmentId,
                                            params.orderNumber,
                                            params.carrierCode,
                                            params.serviceLevel,
                                            params.trackingNumber)

    }

    def checkValidContainerId = {
        respond waveService.checkValidContainerId(springSecurityService.currentUser.companyId, params.shipmentContainerId, params.shipmentId)
    }

    def searchOrderForEditWave = {
        respond waveService.searchOrderForEditWave(springSecurityService.currentUser.companyId, params.waveNumber)
    }

    def removeOrderFromWave = {
        respond waveService.removeOrderFromWave(springSecurityService.currentUser.companyId, params.orderNumber)

    }

    def checkPackoutShipmentExist = {
        respond waveService.checkPackoutShipmentExist(springSecurityService.currentUser.companyId, params.shipmentId)
    }

    def changeWaveStatusForPicking = {
        respond waveService.changeWaveStatusForPicking(springSecurityService.currentUser.companyId, params.waveNumber)
    }

    def printShippingLabel = {
        String pickTicketPrintOption = null

        if(params.pickTicketPrintOption){
            pickTicketPrintOption = params.pickTicketPrintOption
        }
        else{
            pickTicketPrintOption = PickTicketPrintOption.UNIT
        }

        respond waveService.printShippingLabel(springSecurityService.currentUser.companyId, params.printerName, params.shipmentId, pickTicketPrintOption)
    }

}
