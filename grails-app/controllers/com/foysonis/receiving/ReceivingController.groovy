package com.foysonis.receiving

import com.foysonis.inventory.InventoryService
import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_USER','ROLE_ADMIN'])
class ReceivingController extends RestfulController<Receipt> {

    def receivingService
    def inventoryService
    def locationService
    def sessionFactory
    def springSecurityService
    def billingService
    def listValueService

    static responseFormats = ['json', 'xml']

    ReceivingController() {
        super(Receipt)
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
        def pageTitle = "Receiving";
        [pageTitle:pageTitle]
    }

    def searchResults () {

        def currentPageNum = null
        def totalRetrieveAmt = null
        if (params.currentPageNum) {
            currentPageNum = params.currentPageNum
        }
        else{
            currentPageNum = 1
        }

        if (params.totalRetrieveAmt) {
            totalRetrieveAmt = params.totalRetrieveAmt
        }
        else{
            totalRetrieveAmt = 50
        }


        def searchResult = receivingService.searchResults(session.user.companyId, params.receiptId, params.receiptDate, params.toReceiptDate, params.status, params.receiptType, currentPageNum, totalRetrieveAmt, false)
        def totalResultCount = receivingService.searchResults(session.user.companyId, params.receiptId, params.receiptDate, params.toReceiptDate, params.status, params.receiptType, currentPageNum, totalRetrieveAmt, true)
        def resultObj = [:]
        resultObj.receiptSet = searchResult
        resultObj.totalResultCount = totalResultCount[0].totalReceiptDataCount
        respond resultObj
    }


    def getReceiptLineNumberForSearchRow() {
        respond receivingService.getReceiptLineNumberForSearchRow(session.user.companyId, params.selectedRowReceipt)
    }

    def getReceiveInventoryForSearchRow = {
        respond receivingService.getReceiveInventoryForSearchRow(session.user.companyId, params.selectedRowReceiptLine)
    }

    def getPendingPutawayInventory = {
        respond receivingService.getPendingPutawayInventory(session.user.companyId)
    }

    def checkReceiptIdExist = {
        respond receivingService.checkReceiptIdExist(session.user.companyId, params['receiptId'])
    }

    def checkReceiptLineNumExist = {
        respond receivingService.checkReceiptLineNumExist(session.user.companyId, params['receiptLineNumber'], params['receiptId'])
    }

    def getReceiptLineNumbers = {
        respond receivingService.getReceiptLineNumbers(session.user.companyId, params['selectedReceiptId'])
    }

    def checkIsReceiptCompleted = {
        respond receivingService.checkIsReceiptCompleted(session.user.companyId, params['selectedReceiptId'])
    }

    def checkLocationIdExist = {
        respond receivingService.checkLocationIdExist(session.user.companyId, params['locationId'])
    }

    def saveReceipt = {
        def jsonObject = request.JSON
        respond receivingService.saveReceipt(jsonObject, session.user.username, session.user.companyId)
    }


    def updateReceipt = {
        def jsonObject = request.JSON
        respond receivingService.updateReceipt(jsonObject, session.user.username, session.user.companyId)

    }

    def completeReceipt = {
        def jsonObject = request.JSON
        respond receivingService.completeReceipt(session.user.companyId,jsonObject)
    }

    def reOpenReceipt = {
        def jsonObject = request.JSON
        respond receivingService.reOpenReceipt(session.user.companyId,jsonObject)
    }

    def deleteReceipt = {
        def jsonObject = request.JSON
        respond receivingService.deleteReceipt(session.user.companyId, jsonObject)
    }

    def  saveReceiveInventory() {
        respond receivingService.saveReceiveInventory(session.user.companyId, params['receiptLineId'], params['palletId'], params['caseId'], params['uom'], params['quantity'].toInteger(), params['lotCode'], params['expirationDate'], params['inventoryStatus'], session.user.username, params['itemId'], params['itemNote'], session.user.username)
    } 

    def getNotesByCaseId = {
        respond receivingService.getNotesByCaseId(session.user.companyId, params['caseId'])
    }

    def savePutaway(){
        receivingService.savePutaway(session.user.companyId, params['lpn'], params['caseId'], params['locationId'], params['receiveInventoryId'])

    }

    def checkIsInventoryExistForReceiptLine = {
        respond receivingService.checkIsInventoryExistForReceiptLine(session.user.companyId, params['selectedReceiptLineId'])
    }

    def checkInventoryExistForReceipt = {

        def sqlQuery = "SELECT * FROM receipt_line as rl INNER JOIN receive_inventory as ri ON rl.receipt_line_id = ri.receipt_line_id WHERE ri.company_id = '${session.user.companyId}' AND rl.receipt_id = '${params.receiptId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        respond rows
    }

    def getInappropriateQuantityReceiptLine(){
        respond receivingService.getInappropriateQuantityReceiptLine(session.user.companyId, params.receiptId)
    }

    def validateQuantityWithReceiptLine(){
        respond receivingService.validateQuantityWithReceiptLine(params.expectedQuantity, params.receiptLineId, session.user.companyId)
    }

    def validatePalletIdForReceiving = {
        respond receivingService.validatePalletIdForReceiving(session.user.companyId, params.palletId, params.receiptLineId, 'PALLET')
    }

    //Added for iOS development
    def validatePalletIdForPutaway = {
        respond receivingService.validatePalletIdForPutaway(session.user.companyId, params.palletId)
    }

    def checkCaseIdExist = {
        respond inventoryService.checkPalletIdAndCaseExist(session.user.companyId, params.lpn, 'CASE')
    }
    def suggestLocationForPutAway = {
        respond receivingService.suggestLocationForPutAway(session.user.companyId, params['itemId'], params['expirationDate'])
    }
    def getCaseReceiveInventory = {
        def caseOfPallets =  receivingService.getCaseReceiveInventory(session.user.companyId, params['palletId'], params['receiptLineId'])

        if(caseOfPallets.size() > 1)
            respond caseOfPallets
        else
            respond null
    }

    def getCaseReceivePendingPutawayInventory = {
        def caseOfPallets =  receivingService.getCaseReceivePendingPutawayInventory(session.user.companyId, params['palletId'], params['receiptLineId'])

        if(caseOfPallets.size() > 1)
            respond caseOfPallets
        else
            respond null
    }

    def getReceiptsForGoogleData = {
        respond receivingService.getReceiptsForGoogleData(session.user.companyId, params["receiptDuration"])
    }

    def getReceivedOpenedLinesCount = {
        respond receivingService.getReceivedOpenedLinesCount(session.user.companyId)
    }

    //dashboard
    def getPendingPallets = {
        respond receivingService.getPendingPallets(session.user.companyId)
    }

    def getPendingCases = {
        respond receivingService.getPendingCases(session.user.companyId)
    }

    def getPendingCasesTotalCount = {
        respond receivingService.getPendingCasesTotalCount(session.user.companyId)
    }

    def getPendingEachesTotalCount = {
        respond receivingService.getPendingEachesTotalCount(session.user.companyId)
    }

    def getExpectedReceiveQuantityInCase = {
        respond receivingService.getExpectedReceiveQuantityInCase(session.user.companyId)
    }

    def getReceiptLineCaseQuantity = {
        respond receivingService.getReceiptLineCaseQuantity(session.user.companyId)
    }

    def calculateReceivedInventoryQty = {
        respond receivingService.calculateReceivedInventoryQty(session.user.companyId, params.selectedRowReceiptLine, params.itemId)
    }

    def checkPndLocationByLocationAndCompany = {
        respond locationService.checkPndLocationByLocationAndCompany(session.user.companyId, params.locationId)
    }

    def isCaseByLPN = {
        respond receivingService.isCaseByLPN(session.user.companyId, params.lpn)
    }

    def priorDayInventoryReceived = {
        respond receivingService.priorDayInventoryReceived(springSecurityService.currentUser.companyId)
    }

    def getReceiptTypes = {
        respond listValueService.getReceiptTypes();
    }


    def inventoryReceivedFromTo = {
        respond receivingService.inventoryReceivedFromTo(springSecurityService.currentUser.companyId, params.fromDate, params.toDate)
    }

    def testDateFunc = {
        def convertedExpirationDate = Date.parse("dd/MM/yyyy", "28/2/2018")
        println convertedExpirationDate
        println "hello"
    }
}

