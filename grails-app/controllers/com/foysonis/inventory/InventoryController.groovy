package com.foysonis.inventory

import com.foysonis.item.ListValue
import com.foysonis.item.ListValueService
import com.foysonis.item.ItemService
import com.foysonis.inventory.InventoryService
import com.foysonis.inventory.InventoryAdjustmentService
import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

import groovy.sql.Sql

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class InventoryController extends RestfulController<Inventory> {

    def listValueService
    def sessionFactory
    def inventoryService
    def shippedInventoryService
    def inventoryAdjustmentService
    def itemService
    def inventorySummaryService
    def springSecurityService
    def billingService
    def moveInventoryService

    static responseFormats = ['json', 'xml']

    InventoryController() {
        super(Inventory)
    }

    def index = {
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
        def pageTitle = "View Inventory ";
        [pageTitle:pageTitle]

    }

    def newInventory={
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
        def pageTitle = "Inventory Adjustment";
        [pageTitle:pageTitle]

    }

    def moveInventory = {
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
        def pageTitle = "Move Inventory";
        [pageTitle:pageTitle]

    }

    def shippedInventory = {
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
        def pageTitle = "Shipped Inventory"
        [pageTitle:pageTitle]

    }

    def dailyOperationalReport = {

        session.user = springSecurityService.currentUser
        def pageTitle = "Daily Operational Report ";
        [pageTitle:pageTitle]

    }

    def inventoryTrackingReport = {
        session.user = springSecurityService.currentUser
        def pageTitle = "Inventory Tracking Report";
        [pageTitle:pageTitle]        
    }

    def getOriginCodes = {
        respond listValueService.getOriginCodes()
    }

    def getPallets() {
        respond inventoryAdjustmentService.getPallets(session.user.companyId, params.keyword)
    }

    def getPalletsByLocationAndItem() {
        respond inventoryAdjustmentService.getPalletsByLocationAndItem(session.user.companyId, params.itemId, params.locationId)
    }    

    def validatePalletIdByLocationAndItem(){
        respond inventoryAdjustmentService.validatePalletIdByLocationAndItem(session.user.companyId, params.itemId, params.locationId, params.palletId)
    }

    def getPallets1() {
        respond inventoryAdjustmentService.getPallets1(session.user.companyId, params.locationId)
    }

    def getCases() {
        respond inventoryAdjustmentService.getCases(session.user.companyId,params.keyword)
    }

    def validateCase() {
        respond inventoryAdjustmentService.validateCase(session.user.companyId,params.caseId)
    }

    def validatePalletIdExistForCase(){
        respond inventoryAdjustmentService.validatePalletIdExistForCase(session.user.companyId,params.palletId)
    }

    def validatePallet() {
        respond inventoryAdjustmentService.validatePallet(session.user.companyId,params.palletId)
    }

    def getPalletsByLocation() {
        respond inventoryAdjustmentService.getPalletsByLocation(session.user.companyId, params.locationId)
    }

    def getCasesByLocation() {
        respond inventoryAdjustmentService.getCasesByLocation(session.user.companyId, params.locationId)
    }

    def getCasesByPallet() {
        respond inventoryAdjustmentService.getCasesByPallet(session.user.companyId, params.palletId)
    }    

    def getLocationId = {
        respond inventoryService.getLocationId(session.user.companyId, params.palletId)
    }

    def getLpnByLocation = {
        respond inventoryService.getLpnByLocation(session.user.companyId, params.locationId)
    }

    def getAllInventoryDataByLocation = {
        respond inventoryService.getAllInventoryDataByLocation(session.user.companyId, params.locationId)
    }

    def getAllInventoryItemByLocation = {
        respond inventoryService.getAllInventoryItemByLocation(session.user.companyId, params.locationId)
    }

    def getAllInventoryStatusByItemAndLocation = {
        respond inventoryService.getAllInventoryStatusByItemAndLocation(session.user.companyId, params.itemId, params.locationId, params.invStatusOpt)
    }

    def getCaseParentId = {
        respond inventoryService.getCaseParentId(session.user.companyId, params.caseId)
    }

    def search = {
        respond inventoryService.inventorySearch(session.user.companyId, params.itemId, params.location, params.lpn, params.lotCode, params.inventoryNote, params.originCode, params.inventoryStatus,params.areaId, params.itemCategory)
    }

    def shippedInventorySearch = {
        respond shippedInventoryService.shippedInventorySearch(session.user.companyId, params.itemId, params.lpn, params.shipmentId, params.orderNumber, params.customerName, params.inventoryNote, params.inventoryStatus, params.fromShipmentCompletionDate, params.toShipmentCompletionDate)
    }

    def adminSearch = {

        def sqlQuery = "SELECT lo.area_id AS grid_area_id, i.item_id, it.item_description, i.quantity, i.handling_uom, i.inventory_id, i.lot_code, lv.description as inventory_status, i.inventory_status as inventory_status_option_value,  i.expiration_date,inote.notes, CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END AS location_id, CASE WHEN iea.level = 'PALLET' THEN iea.lpn ELSE CASE WHEN ieap.level = 'PALLET' THEN ieap.lpn ELSE NULL END END AS pallet_id, CASE WHEN iea.level = 'CASE' THEN iea.lpn ELSE CASE WHEN ieap.level = 'CASE' THEN ieap.lpn ELSE NULL END END AS case_id FROM inventory as i INNER JOIN item as it ON i.item_id = it.item_id LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn LEFT JOIN inventory_notes as inote ON inote.lpn = (CASE WHEN iea.level = 'CASE' THEN iea.lpn ELSE CASE WHEN ieap.level = 'CASE' THEN ieap.lpn ELSE NULL END END) LEFT JOIN list_value as lv ON i.inventory_status = lv.option_value AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${session.user.companyId}' INNER JOIN location AS lo ON lo.company_id = '${session.user.companyId}' AND lo.location_id = (CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END) WHERE i.company_id = '${session.user.companyId}' AND it.company_id = '${session.user.companyId}' "

        sqlQuery = sqlQuery + " AND (((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${session.user.companyId}' AND loc.location_id = i.location_id) > 0) OR ((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${session.user.companyId}' AND loc.location_id = iea.location_id) > 0) OR ((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${session.user.companyId}' AND loc.location_id = ieap.location_id) > 0)) "

        if (params.location){
            sqlQuery = sqlQuery + " AND (i.location_id = '${params.location}' OR iea.location_id = '${params.location}' OR ieap.location_id = '${params.location}')"
        }

        if (params.area){
            def area = '%'+params.area+'%'
            sqlQuery = sqlQuery + " AND lo.area_id LIKE '${area}' "
        }

        if (params.lpn){
            def lpn = '%'+params.lpn+'%'
            sqlQuery = sqlQuery + " AND (i.associated_lpn LIKE '${lpn}' OR iea.lpn LIKE '${lpn}' OR iea.parent_lpn LIKE '${lpn}')"
        }

        if (params.item){
            def item = '%'+params.item+'%'
            sqlQuery = sqlQuery + " AND (i.item_id LIKE '${item}' OR it.item_description LIKE '${item}' OR it.upc_code LIKE '${item}') "
        }

        log.info("sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        respond rows
    }

    def getInventoryEntityAttributeForSearchRow = {
//        respond inventoryService.getInventoryEntityAttributeForSelectedRow(params.selectedRowPallet, session.user.companyId, params.inventoryStatus)
        respond inventoryService.getPalletInventory(params.selectedRowCase,params.selectedRowPallet, session.user.companyId, params.itemId, params.inventoryStatus, params.handlingUOM)

    }

    def movePalletToLocation = {

        if(params.palletId && params.locationId)
            inventoryService.movePalletToLocation(session.user.companyId, params.palletId, params.locationId, session.user.username)
    }

    def movePalletToBinLocation = {
        if(params.palletId && params.locationId)
           respond inventoryService.movePalletToBinLocation(session.user.companyId, params.palletId, params.locationId, session.user.username)
    }

    def checkLowestUomOfItemByLpn = {
        respond inventoryService.checkLowestUomOfItemByLpn(session.user.companyId, params.lpn)
    }

    def moveCaseToPalletOrLocation = {

        if(params.caseId && params.palletId){
            inventoryService.moveCaseToPallet(session.user.companyId, params.caseId, params.palletId, session.user.username)
        }
        else if (params.caseId && params.locationId){
            inventoryService.moveCaseToLocation(session.user.companyId, params.caseId, params.locationId, session.user.username)
        }

    }

    def moveCaseToBinLocation = {
        if (params.caseId && params.locationId) {
            inventoryService.moveCaseToBinLocation(session.user.companyId, params.caseId, params.locationId, session.user.username)
        }
        
    }

    def moveEntireLocation = {
        if (params.fromLocation && params.toLocation) {
            inventoryService.moveEntireLocation(session.user.companyId, params.fromLocation, params.toLocation, session.user.username)
        }
        
    }

    def moveEntireLocationToBinLocation = {
        if (params.fromLocation && params.toLocation) {
            inventoryService.moveEntireLocationToBinLocation(session.user.companyId, params.fromLocation, params.toLocation, session.user.username)
        }
    }

    def checkLowestUomOfItemByLocation = {
        respond inventoryService.checkLowestUomOfItemByLocation(session.user.companyId, params.locationId)
    }

    def moveEachesToLocation = {
        if (params.fromLocation && params.toLocation) {
            inventoryService.moveEachesToLocation(session.user.companyId, params.fromLocation, params.toLocation, params.itemId, params.inventoryStatus, params.moveQty, params.totalQty, session.user.username)
        }        
    }

    def findItem ={
        respond itemService.checkItemIdExist(session.user.companyId, params['itemId'])
    }

    def checkIsCaseTrackedOfItem = {
        respond inventoryAdjustmentService.checkIsCaseTrackedOfItem(session.user.companyId, params.itemId)
    }

    def checkIsLotCodeTrackedOfItem = {
        respond inventoryAdjustmentService.checkIsLotCodeTrackedOfItem(session.user.companyId, params.itemId)
    }

    def checkIsExpiredOfItem = {
        respond inventoryAdjustmentService.checkIsExpiredOfItem(session.user.companyId, params.itemId)
    }

    def checkLowestUomOfItemEach = {
        respond inventoryAdjustmentService.checkLowestUomOfItemEach(session.user.companyId, params.itemId)
    }



    def inventoryEditAndAdjustment = {
        def jsonObject = request.JSON
        if(jsonObject.expirationDate == "")
            jsonObject.expirationDate = null
        respond inventoryAdjustmentService.inventoryEditAndAdjustment(jsonObject, session.user.companyId, session.user.username )

    }

    def checkInventoryLocationForDelete = {
        respond inventoryAdjustmentService.checkInventoryLocationForDelete(session.user.companyId, params.locationId)
    }

    def deleteInventory = {

        def jsonObject = request.JSON
        respond inventoryAdjustmentService.deleteInventory(jsonObject, session.user.companyId, session.user.username)
    }



    def addReasonCode(){
        def jsonObject = request.JSON
        def listValue = new ListValue(jsonObject)
        listValue.properties = [companyId :session.user.companyId,
                                createdDate:new Date(),
                                displayOrder:0]


        def listValueExist = ListValue.find("from ListValue as l where l.companyId='${session.user.companyId}' AND l.optionGroup = '${jsonObject.optionGroup}' order by createdDate DESC")
        if (!listValueExist) {

            listValue.optionValue = 001
        }
        else{
            def intIndex = listValueExist.optionValue.toInteger()
            listValue.optionValue = intIndex + 1
        }

        respond listValue.save(flush: true, failOnError: true)
    }


    def inventorySave() {
        def jsonObject = request.JSON   
        respond inventoryAdjustmentService.inventorySave(session.user.companyId, session.user.username, jsonObject)
    }


    def getInventoryByInventoryId() {
        respond inventoryAdjustmentService.getInventoryByInventoryId(session.user.companyId, params.palletId, params.caseId)
    }

    def getInventoryStatusReport = {
        respond inventoryService.getInventoryStatusReport(session.user.companyId)
    }

    def getItemsForGivenLpn() {
        respond inventoryService.getItemsForGivenLpn(session.user.companyId, params.lpn)
    }

    def priorDayInventoryAdjusted = {
        respond inventoryAdjustmentService.priorDayInventoryAdjusted(springSecurityService.currentUser.companyId)
    }

    def inventoryAdjustedFromTo = {
        respond inventoryAdjustmentService.inventoryAdjustedFromTo(springSecurityService.currentUser.companyId, params.fromDate, params.toDate)
    }

    def inventoryMoveDataFromTo = {
        respond inventoryService.inventoryMoveDataFromTo(springSecurityService.currentUser.companyId, params.fromDate, params.toDate)
    }

    // Added for iOS development
    def validatePalletIdForMovePallet = {
        respond inventoryService.validatePalletIdForMovePallet(springSecurityService.currentUser.companyId, params.palletId)
    }

    def validateCaseIdForMoveCase = {
        respond inventoryService.validateCaseIdForMoveCase(springSecurityService.currentUser.companyId, params.caseId)
    }

    def getInventoryDataByIdAndCompany = {
        respond inventoryAdjustmentService.getInventoryDataByIdAndCompany(springSecurityService.currentUser.companyId, params.inventoryId)
    }

}
