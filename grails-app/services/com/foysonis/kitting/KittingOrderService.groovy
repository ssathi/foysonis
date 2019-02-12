package com.foysonis.kitting

import com.foysonis.area.Location
import com.foysonis.area.LocationService
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.item.Item
import com.foysonis.orders.Shipment
import com.foysonis.orders.ShipmentLine
import com.foysonis.orders.ShipmentService
import com.foysonis.orders.ShipmentStatus
import com.foysonis.picking.PickWork
import com.foysonis.receiving.InventoryNotes
import com.foysonis.receiving.ReceiveInventory
import grails.transaction.Transactional
import groovy.sql.Sql

import com.foysonis.area.Area

@Transactional
class KittingOrderService {
	def sessionFactory
    def inventoryService
    def inventorySummaryService


    def searchKittingOrderByCompanyIdAndItemId(String companyId, String itemId, String kittingOrderNumber, String kittingOrderStatus, String orderNumber, searchData){


        def sqlQuery = null
        if (searchData.kittingSearchForCount == true ) {
            sqlQuery = "SELECT COUNT(Distinct  ko.kitting_order_number) as total_Kitting_orders, ko.*, it.item_description AS itemDescription, lv.description AS finishedProductInventoryStatusDesc, ol.order_number as salesOrderNumber  "
            sqlQuery += "FROM kitting_order AS ko "
            sqlQuery += "INNER JOIN item AS it ON it.item_id = ko.kitting_item_id AND it.company_id='${companyId}' "
            sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = ko.finished_product_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
            sqlQuery += "LEFT JOIN order_line AS ol ON ol.order_line_number = ko.order_info AND ol.company_id='${companyId}'  "

            sqlQuery += "WHERE ko.company_id='${companyId}' "            
        }
        else{
            sqlQuery = "SELECT ko.*, it.item_description AS itemDescription, lv.description AS finishedProductInventoryStatusDesc, ol.order_number as salesOrderNumber  "
            sqlQuery += "FROM kitting_order AS ko "
            sqlQuery += "INNER JOIN item AS it ON it.item_id = ko.kitting_item_id AND it.company_id='${companyId}' "
            sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = ko.finished_product_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
            sqlQuery += "LEFT JOIN order_line AS ol ON ol.order_line_number = ko.order_info AND ol.company_id='${companyId}'  "

            sqlQuery += "WHERE ko.company_id='${companyId}' "
        }

        // def sqlQuery = "SELECT ko.*, it.item_description AS itemDescription, lv.description AS finishedProductInventoryStatusDesc, ol.order_number as salesOrderNumber  "
        // sqlQuery += "FROM kitting_order AS ko "
        // sqlQuery += "INNER JOIN item AS it ON it.item_id = ko.kitting_item_id AND it.company_id='${companyId}' "
        // sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = ko.finished_product_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        // sqlQuery += "LEFT JOIN order_line AS ol ON ol.order_line_number = ko.order_info AND ol.company_id='${companyId}'  "

        // sqlQuery += "WHERE ko.company_id='${companyId}' "

        if(itemId){
            itemId = '%'+itemId+'%'
            sqlQuery += "AND (it.item_id LIKE '${itemId}' OR it.item_description LIKE '${itemId}') "
        }

        if(kittingOrderNumber){
            kittingOrderNumber = '%'+kittingOrderNumber+'%'
            sqlQuery += "AND (ko.kitting_order_number LIKE '${kittingOrderNumber}') "
        }

        if(kittingOrderStatus){
            sqlQuery += "AND (ko.kitting_order_status = '${kittingOrderStatus}') "
        }

        if(orderNumber){
            orderNumber = '%'+orderNumber+'%'
            sqlQuery += "AND ol.order_number LIKE '${orderNumber}' "
        }

        // sqlQuery += "ORDER BY ko.created_date DESC ;"

        if (searchData.kittingSearchForCount == true ) {
            sqlQuery = sqlQuery + " ORDER BY ko.created_date DESC ; "
        }

        else{
            sqlQuery = sqlQuery + " GROUP BY ko.kitting_order_number ORDER BY ko.created_date DESC "

            if (searchData.currentPageNum ) {
                def currentPageNumber = 0
                if (searchData.currentPageNum.toInteger() > 0) {
                    currentPageNumber = (searchData.currentPageNum.toInteger() - 1) * 20
                }
                else{
                    currentPageNumber = 0
                }
                sqlQuery = sqlQuery + " LIMIT ${currentPageNumber}, 20"
                
            }
            else{
                sqlQuery = sqlQuery + " LIMIT 0, 20"
            }

        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def saveKittingOrder(KittingOrder kittingOrder){
        kittingOrder.createdDate = new Date()
        kittingOrder.updatedDate = new Date()
        return kittingOrder.save(flush: true, failOnError: true)
    }

    def getAllKittingOrderWithItemDetailsByCompanyId(String companyId){
        def sqlQuery = "SELECT ko.*, it.item_description AS itemDescription, lv.description AS finishedProductInventoryStatusDesc, ol.order_number as salesOrderNumber "
        sqlQuery += "FROM kitting_order AS ko "
        sqlQuery += "INNER JOIN item AS it ON it.item_id = ko.kitting_item_id AND it.company_id='${companyId}' "
        sqlQuery += "LEFT JOIN order_line AS ol ON ol.order_line_number = ko.order_info AND ol.company_id='${companyId}' "
        sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = ko.finished_product_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        sqlQuery += "WHERE ko.company_id='${companyId}' "
        sqlQuery += "ORDER BY ko.created_date DESC "
        sqlQuery += " LIMIT 0, 20 "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }    

    def updateKittingOrder(KittingOrder kittingOrder){

        kittingOrder.updatedDate = new Date()
        return kittingOrder.save(flush: true, failOnError: true)

    }

    def deleteKittingOrder(String companyId, KittingOrder kittingOrder){
        def kittingOrderComponent = KittingOrderComponent.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrder.kittingOrderNumber)
        def kittingOrderInstruction = KittingOrderInstruction.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrder.kittingOrderNumber)
        if (kittingOrderComponent.size() > 0) {
            for(koComponentData in kittingOrderComponent) {
                koComponentData.delete(flush: true, failOnError: true)
            }
        }

        if (kittingOrderInstruction.size() > 0) {
            for(koInstructionData in kittingOrderInstruction) {
                koInstructionData.delete(flush: true, failOnError: true)
            }
        }
        kittingOrder.delete(flush: true, failOnError: true)
        return [status:"success"]
    }        

    def saveKittingOrderComponent(KittingOrderComponent kittingOrderComponent){
        return kittingOrderComponent.save(flush: true, failOnError: true)
    }

    def updateKittingOrderComponent(KittingOrderComponent kittingOrderComponent){
        return kittingOrderComponent.save(flush: true, failOnError: true)
    }

    def deleteKittingOrderComponent(KittingOrderComponent kittingOrderComponent){
        kittingOrderComponent.delete(flush: true, failOnError: true)
        return [status:"success"]
    }   
     
    def getAllKOComponentDataByCompanyIdAndOrdNum(companyId,kittingOrdNum){
        def sqlQuery = "SELECT koCom.*, lv.description AS componentInventoryStatusDesc "
        sqlQuery += "FROM kitting_order_component AS koCom "
        sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = koCom.component_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS'"
        sqlQuery += "WHERE koCom.company_id='${companyId}' AND koCom.kitting_order_number = '${kittingOrdNum}'"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)        
    }

    def saveKittingOrderInstruction(KittingOrderInstruction kittingOrderInstruction){
        return kittingOrderInstruction.save(flush: true, failOnError: true)
    }

    def updateKittingOrderInstruction(KittingOrderInstruction kittingOrderInstruction){
        return kittingOrderInstruction.save(flush: true, failOnError: true)
    }    

    def deleteKittingOrderInstruction(KittingOrderInstruction kittingOrderInstruction){
        kittingOrderInstruction.delete(flush: true, failOnError: true)
        return [status:"success"]
    }

    def getAllKittingOrderInstructionDataByCompanyIdAndBomId(companyId,kittingOrdNum){
        def sqlQuery = "SELECT koIns.*, lv.description AS inventoryStatusDesc "
        sqlQuery += "FROM kitting_order_instruction AS koIns "
        sqlQuery += "LEFT JOIN list_value AS lv ON lv.option_value = koIns.inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        sqlQuery += "WHERE koIns.company_id='${companyId}' AND koIns.kitting_order_number = '${kittingOrdNum}'"
        sqlQuery += "ORDER BY koIns.display_order_number"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)        
    }

    def getAllKittingOrderInventoryDataByKittingOrderNumber(companyId,kittingOrdNum){
        def sqlQuery = "SELECT kInv.*, inote.notes AS inventoryNotes, lv.description AS kittingInventoryStatusDesc "
        sqlQuery += "FROM kitting_inventory AS kInv "
        sqlQuery += "LEFT JOIN list_value AS lv ON lv.option_value = kInv.inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        sqlQuery += "LEFT JOIN inventory_notes as inote ON inote.lpn = kInv.case_id AND inote.company_id = '${companyId}' "
        sqlQuery += "WHERE kInv.company_id='${companyId}' AND kInv.kitting_order_number = '${kittingOrdNum}'"

        def sql = new Sql(sessionFactory.currentSession.connection())


        return sql.rows(sqlQuery)
    }    

    def copyBOMDataToKittingOrder(companyId, BillMaterial billMaterial, kittingOrderNumber){

    	def billMaterialComponent = BillMaterialComponent.findAllByCompanyIdAndBomId(companyId,billMaterial.id)
    	def billMaterialInstruction = BillMaterialInstruction.findAllByCompanyIdAndBomId(companyId,billMaterial.id)

    	if (billMaterialComponent.size() > 0) {
    		for(bomComponent in billMaterialComponent) {
    			KittingOrderComponent kittingOrderComponent = new KittingOrderComponent()
    			kittingOrderComponent.properties = [companyId:companyId,
    												kittingOrderNumber:kittingOrderNumber, 
    												componentItemId:bomComponent.componentItemId,
    												componentQuantity:bomComponent.componentQuantity,
    												componentUom:bomComponent.componentUom,
    												componentInventoryStatus:bomComponent.componentInventoryStatus]

    			kittingOrderComponent.save(flush: true, failOnError: true)
    		}
    		
    	}

    	if (billMaterialInstruction.size() > 0) {
    		for(bomInstruction in billMaterialInstruction) {
    			KittingOrderInstruction kittingOrderInstruction = new KittingOrderInstruction()
    			kittingOrderInstruction.properties = [companyId:companyId,
    												  kittingOrderNumber:kittingOrderNumber, 
    												  displayOrderNumber:bomInstruction.displayOrderNumber,
    												  instructionId:bomInstruction.instructionId,
    												  instruction:bomInstruction.instruction,
    												  instructionType:bomInstruction.instructionType,
    												  inventoryStatus:bomInstruction.inventoryStatus]
    												
    			kittingOrderInstruction.save(flush: true, failOnError: true)
    		}
    		
    	}

    	KittingOrder kittingOrder = new KittingOrder()
    	kittingOrder.properties = [companyId:companyId,
    								kittingOrderNumber:kittingOrderNumber,
    								kittingItemId:billMaterial.itemId,
    								finishedProductInventoryStatus:billMaterial.finishedProductDefaultStatus,
    								productionQuantity:billMaterial.defaultProductionQuantity,
    								productionUom:billMaterial.productionUom,
    								createdDate:new Date(),
    								updatedDate:new Date(),]

   		kittingOrder.save(flush: true, failOnError: true)
   		return kittingOrder

    }

    def getSelectedKittingOrderByKittingOrderNumber(companyId, kittingOrderNumber){
    	return KittingOrder.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
    }

    def getKittingLocationsByArea(companyId, keyword) {
        def kittingArea = Area.findAllByCompanyIdAndIsKitting(companyId, true)
        def keyLocationId = '%'+keyword+'%'
        def sqlQuery = null

        if(kittingArea.size()>1){
            sqlQuery = "SELECT l.location_id, CONCAT(l.location_id,' - ', a.area_id) as locationId FROM area as a INNER JOIN location as l ON a.area_id = l.area_id WHERE l.company_id = '${companyId}' AND a.company_id = '${companyId}' AND a.is_kitting = true AND l.location_id LIKE '${keyLocationId}' AND l.is_blocked =false;"
        }

        else{
            sqlQuery = "SELECT l.location_id, l.location_id as locationId FROM area as a INNER JOIN location as l ON a.area_id = l.area_id WHERE l.company_id = '${companyId}' AND a.company_id = '${companyId}' AND a.is_kitting =true AND l.location_id LIKE '${keyLocationId}' AND l.is_blocked =false;"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def moveUpKittingOrderInstruction(companyId, kittingOrderNumber, kittingOrderInstructionId){

        KittingOrderInstruction kittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumberAndId(companyId, kittingOrderNumber, kittingOrderInstructionId)
        KittingOrderInstruction nextKittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumberAndDisplayOrderNumberLessThan(companyId, kittingOrderNumber, kittingOrderInstruction.displayOrderNumber, [sort: "displayOrderNumber", order: "desc"])

        Integer displayOrderNumber = kittingOrderInstruction.displayOrderNumber
        kittingOrderInstruction.displayOrderNumber = nextKittingOrderInstruction.displayOrderNumber

        nextKittingOrderInstruction.displayOrderNumber = displayOrderNumber
        nextKittingOrderInstruction.save(flush: true, failOnError: true)

        return kittingOrderInstruction.save(flush: true, failOnError: true)
    }

    def moveDownKittingOrderInstruction(companyId, kittingOrderNumber, kittingOrderInstructionId){

        KittingOrderInstruction kittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumberAndId(companyId, kittingOrderNumber, kittingOrderInstructionId)
        KittingOrderInstruction nextKittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumberAndDisplayOrderNumberGreaterThan(companyId, kittingOrderNumber, kittingOrderInstruction.displayOrderNumber, [sort: "displayOrderNumber", order: "asc"])

        Integer displayOrderNumber = kittingOrderInstruction.displayOrderNumber
        kittingOrderInstruction.displayOrderNumber = nextKittingOrderInstruction.displayOrderNumber

        nextKittingOrderInstruction.displayOrderNumber = displayOrderNumber
        nextKittingOrderInstruction.save(flush: true, failOnError: true)

        return kittingOrderInstruction.save(flush: true, failOnError: true)
    }


//    START KITTING INVENTORY
    def validatePalletIdForKitting(companyId, palletId, kittingOrderNumber){

        def palletExistData = InventoryEntityAttribute.findAll("FROM InventoryEntityAttribute WHERE companyId = '${companyId}' AND (lPN = '${palletId}' OR parentLpn = '${palletId}') ")

        if (palletExistData.size() > 0) {
            if (palletExistData[0].locationId == 'KITTINGTEMPLOCATION') {
                def kittingOrderCompare = KittingInventory.findAllByCompanyIdAndPalletIdAndKittingOrderNumberAndLocationId(companyId, palletId, kittingOrderNumber, null)
                if (kittingOrderCompare.size() > 0) {
                    return [kittingOrderNumber: kittingOrderCompare[0].kittingOrderNumber, palletId: palletId, allowToReceive: true]
                }
                else{
                    return [palletId: palletId, allowToReceive: false]
                }
            }
            else{
                return [palletId: palletId, allowToReceive: false]
            }
            return [palletId: palletId, allowToReceive: false]
        }
        else{
            return [palletId: palletId, allowToReceive: true]
        }

    }

    def validateCaseIdForKitting(companyId, caseId, kittingOrderNumber){

        def caseExistData = InventoryEntityAttribute.findAll("FROM InventoryEntityAttribute WHERE companyId = '${companyId}' AND (lPN = '${caseId}') ")

        if (caseExistData.size() > 0) {

            def pickWorkReferences = PickWork.findAll("from PickWork as pw where pw.companyId = '${companyId}' and pw.orderNumber = '${kittingOrderNumber}' order by pw.workReferenceNumber")

            Inventory inventory = Inventory.find("from Inventory as inv where inv.companyId = '${companyId}' and inv.associatedLpn = '${caseId}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') ")

            if(inventory){
                return [allowToReceive: true]
            }
            else {
                return [allowToReceive: false]
            }
        }
        else{

            return [allowToReceive: true]

        }

    }

    def getReceivedKittingInventoryTotalQuantity(companyId, kittingOrderNumber){
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
        Item kittingItem = Item.findByCompanyIdAndItemId(companyId, kittingOrder.kittingItemId)

        def kittingInventories = KittingInventory.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)

        Integer receivedTotalQuantity = 0
        for(kittingInventory in kittingInventories){
            if(kittingInventory.uom == "CASE" && kittingItem.lowestUom == "EACH"){
                receivedTotalQuantity += kittingInventory.quantity * kittingItem.eachesPerCase
            }
            else{
                receivedTotalQuantity += kittingInventory.quantity
            }
        }

        return [receivedTotalQuantity: receivedTotalQuantity]
    }

    def getCompletedKittingInventoryTotalQuantity(companyId, kittingOrderNumber){
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
        Item kittingItem = Item.findByCompanyIdAndItemId(companyId, kittingOrder.kittingItemId)

        def kittingInventories = KittingInventory.findAllByCompanyIdAndKittingOrderNumberAndIsAllInstructionCompleted(companyId, kittingOrderNumber, true)

        Integer completedTotalQuantity = 0
        for(kittingInventory in kittingInventories){
            if(kittingInventory.uom == "CASE" && kittingItem.lowestUom == "EACH"){
                completedTotalQuantity += kittingInventory.quantity * kittingItem.eachesPerCase
            }
            else{
                completedTotalQuantity += kittingInventory.quantity
            }
        }

        return [completedTotalQuantity: completedTotalQuantity]
    }


    def saveKittingInventory(companyId, kittingOrderNumber, palletId, caseId, uom, quantity, lotCode, expirationDate, inventoryStatus,lastModifiedUserId, itemId, itemNotes){

        Item inventoryItem = Item.findByCompanyIdAndItemId(companyId, itemId)
        if(caseId && caseId != '' && uom == "EACH"){


            if(inventoryItem && inventoryItem.eachesPerCase && inventoryItem.eachesPerCase.toInteger() == quantity.toInteger()){
                uom = "CASE"
                quantity = 1
            }
        }

        def kittingInventory = new KittingInventory()

        kittingInventory.companyId = companyId
        kittingInventory.kittingOrderNumber = kittingOrderNumber
        kittingInventory.itemId = itemId
        kittingInventory.palletId = palletId == "" ? null : palletId

        kittingInventory.caseId = caseId
        kittingInventory.uom = uom
        kittingInventory.quantity = quantity
        kittingInventory.lotCode = lotCode
        kittingInventory.createdDate = new Date()
        if (expirationDate == null) {
            kittingInventory.expirationDate = null
        }
        else{
            def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", expirationDate)
            kittingInventory.expirationDate = convertedExpirationDate
        }
        kittingInventory.inventoryStatus = inventoryStatus

        KittingInventory kittingInventoryExists = null

        if(palletId !=null && caseId !=null ){
            kittingInventoryExists = KittingInventory.findByCompanyIdAndKittingOrderNumberAndPalletIdAndCaseId(companyId, kittingOrderNumber, palletId,caseId)
        }
        else if(palletId != null){
            kittingInventoryExists = KittingInventory.findByCompanyIdAndKittingOrderNumberAndPalletId(companyId, kittingOrderNumber, palletId)
        }
        else if(caseId != null){
            kittingInventoryExists = KittingInventory.findByCompanyIdAndKittingOrderNumberAndCaseId(companyId, kittingOrderNumber, caseId)
        }

        if(!kittingInventoryExists){
            KittingOrderInstruction kittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
            if(kittingOrderInstruction){
                kittingInventory.isAllInstructionCompleted = false
            }
            else{
                kittingInventory.isAllInstructionCompleted = true
            }

            kittingInventory.save(flush: true, failOnError: true)


            KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
            if(kittingOrder.kittingOrderStatus == KittingOrderStatus.COMPONENT_READY){
                kittingOrder.kittingOrderStatus = KittingOrderStatus.PROCESSING
                kittingOrder.save(flush: true, failOnError: true)
            }

            Integer koQuantity = quantity

            if(kittingOrder.productionUom == 'EACH' && uom == 'CASE'){
                koQuantity = koQuantity * inventoryItem.eachesPerCase.toInteger()
            }

            def kittingOrderComponents = KittingOrderComponent.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)

            for(kittingOrderComponent in kittingOrderComponents){
                reduceComponentItems(companyId, kittingOrderNumber, kittingOrderComponent.componentItemId, kittingOrderComponent.componentInventoryStatus, kittingOrderComponent.componentQuantity * koQuantity, kittingOrderComponent.componentUom, caseId )
            }

        }


        if (itemNotes) {
            def inventoryNotes = InventoryNotes.findByCompanyIdAndLPN(companyId,caseId)
            if (inventoryNotes) {
                inventoryNotes.notes = itemNotes
            }
            else{
                inventoryNotes = new InventoryNotes()
                inventoryNotes.companyId = companyId
                inventoryNotes.lPN = caseId
                inventoryNotes.notes = itemNotes
            }
            inventoryNotes.save(flush: true, failOnError: true)
        }

        return kittingInventory

    }

    def saveKittingPutaway(companyId, lpn, caseId, locationId, kittingInventoryId){

        log.info("lpn : " + lpn)
        log.info("caseId : " + caseId)
        log.info("locationId : " + locationId)

        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)

        if(!location){
            location = Location.findByCompanyIdAndLocationBarcode(companyId, locationId)
            locationId = location.locationId
        }

        def inventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${lpn}' ")

        if(inventoryEntityAttribute){

            def area = Area.findByCompanyIdAndAreaId(companyId, location.areaId)

            if (area.isBin) {
                def inventoryByAssociatedLpn = null
                if (!caseId) {
                    inventoryByAssociatedLpn = Inventory.findByCompanyIdAndAssociatedLpn(companyId, lpn)
                }
                if (inventoryByAssociatedLpn) {
                    def calculatedQty = 0
                    def itemData = Item.findByCompanyIdAndItemId(companyId, inventoryByAssociatedLpn.itemId)
                    if (inventoryByAssociatedLpn.handlingUom == 'CASE' && itemData.lowestUom == 'EACH') {
                        calculatedQty = inventoryByAssociatedLpn.quantity.toInteger() * itemData.eachesPerCase.toInteger()
                    }
                    else if (inventoryByAssociatedLpn.handlingUom == 'EACH' && itemData.lowestUom == 'EACH') {
                        calculatedQty = inventoryByAssociatedLpn.quantity
                    }
                    inventoryByAssociatedLpn.handlingUom = 'EACH'
                    inventoryByAssociatedLpn.quantity = calculatedQty
                    inventoryByAssociatedLpn.associatedLpn = null
                    inventoryByAssociatedLpn.locationId = locationId
                    inventoryByAssociatedLpn.save(flush: true, failOnError: true)
                }
            }
            else{

                inventoryEntityAttribute.locationId = locationId
                if(inventoryEntityAttribute.parentLpn){
                    def parentInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.parentLpn ='${inventoryEntityAttribute.parentLpn}' and iea.lPN != '${lpn}' ")
                    if(!parentInventoryEntityAttribute){
                        def invalidInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${inventoryEntityAttribute.parentLpn}' and iea.locationId = 'KITTINGTEMPLOCATION' ")
                        if (invalidInventoryEntityAttribute)
                            invalidInventoryEntityAttribute.delete(flush:true, failOnError:true)
                    }

                }
                inventoryEntityAttribute.parentLpn = null
                inventoryEntityAttribute.save(flush: true, failOnError: true)

            }

            //Update Inventory Summary
            KittingInventory kittingInventory = KittingInventory.findByCompanyIdAndId(companyId, kittingInventoryId)
            if (area.isStorage){

                inventorySummaryService.updateIncreasedInventory(companyId, kittingInventory.itemId, kittingInventory.inventoryStatus, kittingInventory.quantity, kittingInventory.uom)

            }

            kittingInventory.locationId = locationId
            kittingInventory.save(flush: true, failOnError: true)

            //Find Any Other Kitting Inventory to Putaway
            KittingInventory pendingPutawayKittingInventory = KittingInventory.findByCompanyIdAndKittingOrderNumberAndLocationIdIsNull(companyId, kittingInventory.kittingOrderNumber)
            if(!pendingPutawayKittingInventory){
                KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingInventory.kittingOrderNumber)
                if(kittingOrder.kittingOrderStatus == KittingOrderStatus.COMPLETED){
                    kittingOrder.kittingOrderStatus = KittingOrderStatus.CLOSED
                    kittingOrder.save(flush: true, failOnError: true)
                }
            }

            if (area.isBin && !caseId) {
                def inventoryByLpn =  Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, lpn)
                if (inventoryByLpn.size() == 0) {
                    def lpnRowData = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
                    if (lpnRowData) {
                        lpnRowData.delete(flush: true, failOnError: true)
                    }
                }
            }


        }

        return inventoryEntityAttribute

    }


    def saveKittingStage(companyId, lpn, caseId, kittingInventoryId){

        log.info("lpn : " + lpn)
        log.info("caseId : " + caseId)

        KittingInventory kittingInventory = KittingInventory.findByCompanyIdAndId(companyId, kittingInventoryId)
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingInventory.kittingOrderNumber)
        log.info("kittingOrder.orderInfo : " + kittingOrder.orderInfo)
        ShipmentLine shipmentLine = ShipmentLine.findByCompanyIdAndOrderLineNumber(companyId, kittingOrder.orderInfo)

        if(shipmentLine){
            Shipment shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentLine.shipmentId)
            String locationId = shipment.stagingLocationId
            Location location = Location.findByCompanyIdAndLocationId(companyId, locationId)
            if(location){
                Area area = Area.findByCompanyIdAndAreaId(companyId, location.areaId)


                def inventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${lpn}' ")

                if(inventoryEntityAttribute){

                    inventoryEntityAttribute.locationId = locationId
                    if(inventoryEntityAttribute.parentLpn){
                        def parentInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.parentLpn ='${inventoryEntityAttribute.parentLpn}' and iea.lPN != '${lpn}' ")
                        if(!parentInventoryEntityAttribute){
                            def invalidInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${inventoryEntityAttribute.parentLpn}' and iea.locationId = 'KITTINGTEMPLOCATION' ")
                            if (invalidInventoryEntityAttribute)
                                invalidInventoryEntityAttribute.delete(flush:true, failOnError:true)
                        }

                    }

                    def inventories = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, lpn)
                    for(inventory in inventories){
                        inventory.workReferenceNumber = shipment.shipmentId
                        inventory.save(flush: true, failOnError: true)
                    }


                    inventoryEntityAttribute.parentLpn = null
                    inventoryEntityAttribute.save(flush: true, failOnError: true)

                    //Update Inventory Summary

                    if (area.isStorage){

                        inventorySummaryService.updateIncreasedInventory(companyId, kittingInventory.itemId, kittingInventory.inventoryStatus, kittingInventory.quantity, kittingInventory.uom)

                    }

                    kittingInventory.locationId = locationId
                    kittingInventory.save(flush: true, failOnError: true)

                    //Find Any Other Kitting Inventory to move to Stage
                    KittingInventory pendingStageKittingInventory = KittingInventory.findByCompanyIdAndKittingOrderNumberAndLocationIdIsNull(companyId, kittingInventory.kittingOrderNumber)
                    if(!pendingStageKittingInventory){

                        if(kittingOrder.kittingOrderStatus == KittingOrderStatus.COMPLETED){
                            kittingOrder.kittingOrderStatus = KittingOrderStatus.CLOSED
                            kittingOrder.save(flush: true, failOnError: true)

                            //Find Shipment to Complete
                            if(shipment.shipmentStatus == ShipmentStatus.KO_PROCESSING){
                                shipment.shipmentStatus = ShipmentStatus.STAGED
                                shipment.save(flush: true, failOnError: true)

                            }
                        }
                    }

                }
            }

        }

        return kittingInventory

    }

    def saveKittingInventoryInstruction(companyId, kittingOrderNumber, kittingOrderInstructionId, kittingInventoryId, status, kittingInventoryStatus){
    	def kittingInventoryInstruction = new KittingInventoryInstruction()
    	kittingInventoryInstruction.companyId = companyId
    	kittingInventoryInstruction.kittingOrderNumber = kittingOrderNumber
    	kittingInventoryInstruction.kittingOrderInstructionId = kittingOrderInstructionId.toInteger()
    	kittingInventoryInstruction.kittingInventoryId = kittingInventoryId.toInteger()
    	kittingInventoryInstruction.status = status
    	kittingInventoryInstruction.createdDate = new Date()
    	if (kittingInventoryStatus) {
    		def kittingInventory = KittingInventory.findByCompanyIdAndKittingOrderNumberAndId(companyId, kittingOrderNumber, kittingInventoryId)
    		if (kittingInventory) {
    			kittingInventory.inventoryStatus = kittingInventoryStatus
    			kittingInventory.save(flush: true, failOnError: true)
    		}	
    	}
    	kittingInventoryInstruction.save(flush: true, failOnError: true)
    }

    def saveKittingInventoryForFinalInstruction(companyId, lastModifiedUserId, kittingOrderNumber, kittingInventoryId, kOFinishedProductStatus){
		def kittingInventory = KittingInventory.findByCompanyIdAndKittingOrderNumberAndId(companyId, kittingOrderNumber, kittingInventoryId)
		if (kittingInventory) {
			kittingInventory.inventoryStatus = kOFinishedProductStatus
			kittingInventory.isAllInstructionCompleted = true
			inventoryService.saveInventoryForKitting(companyId, lastModifiedUserId, kittingInventory.palletId, kittingInventory.caseId, kittingInventory.uom, kittingInventory.inventoryStatus, kittingInventory.itemId, kittingInventory.quantity, kittingInventory.lotCode, kittingInventory.expirationDate)
			kittingInventory.save(flush: true, failOnError: true)

            KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
            def completedInventory = getCompletedKittingInventoryTotalQuantity(companyId, kittingOrderNumber)
            if(completedInventory.completedTotalQuantity >= kittingOrder.productionQuantity){
                kittingOrder.kittingOrderStatus =  KittingOrderStatus.COMPLETED
            }
            else{
                kittingOrder.kittingOrderStatus = KittingOrderStatus.PROCESSING
            }
            kittingOrder.save(flush: true, failOnError: true)
		}  


    }

    def getKittingInventoryDataForValidation(companyId, lpn, lpnType, kittingOrderNumber){
    	def kittingInventory = []
    	if (lpnType == 'PALLET') {
    		kittingInventory = KittingInventory.findAllByCompanyIdAndKittingOrderNumberAndPalletIdAndIsAllInstructionCompleted(companyId, kittingOrderNumber, lpn, false)
    	}
    	else if (lpnType == 'CASE') {
    		kittingInventory = KittingInventory.findAllByCompanyIdAndKittingOrderNumberAndCaseIdAndIsAllInstructionCompleted(companyId, kittingOrderNumber, lpn, false)
    	}
    	return kittingInventory
    }

    def getUnCompletedInstructionForKittingInventory(companyId, kittingOrderNumber, kittingInventoryId){
    	def sqlQuery = "SELECT DISTINCT koi.* FROM kitting_order_instruction AS koi LEFT JOIN kitting_inventory_instruction AS kini ON koi.id = kini.kitting_order_instruction_id AND kini.company_id = '${companyId}' WHERE koi.kitting_order_number = '${kittingOrderNumber}' AND koi.company_id = '${companyId}' AND koi.display_order_number > (SELECT koi2.display_order_number FROM kitting_inventory_instruction AS kini2 INNER JOIN kitting_order_instruction AS koi2 ON koi2.id = kini2.kitting_order_instruction_id AND koi2.company_id = '${companyId}' WHERE kini2.kitting_inventory_id = ${kittingInventoryId} AND kini2.kitting_order_number = '${kittingOrderNumber}' ORDER BY koi2.display_order_number DESC LIMIT 1) ORDER BY koi.display_order_number ASC"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def reduceComponentItems(companyId, kittingOrderNumber, itemId, inventoryStatus, quantity, uom, usingCaseId ){

        def pickWorkReferences = PickWork.findAll("from PickWork as pw where pw.companyId = '${companyId}' and pw.orderNumber = '${kittingOrderNumber}' order by pw.workReferenceNumber")

        Integer deleteQty = quantity
        Boolean usingComponentLpn = false

        if(usingCaseId){
            Inventory componentInventory = Inventory.findByCompanyIdAndAssociatedLpnAndItemId(companyId, usingCaseId, itemId)
            if(componentInventory)
                usingComponentLpn = true
        }


        if(usingComponentLpn == true){

            Inventory inventorywithMoreQty = Inventory.find("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = '${uom}' and inv.quantity > '${quantity}' and inv.associatedLpn = '${usingCaseId}' ")

            if(inventorywithMoreQty){
                inventorywithMoreQty.quantity -= quantity
                deleteQty -= quantity

                InventoryEntityAttribute iea = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, usingCaseId)
                if(iea){
                    if(iea.parentLpn){
                        InventoryEntityAttribute anotherIea = InventoryEntityAttribute.findByCompanyIdAndParentLpnAndLPNNotEqual(companyId, iea.parentLpn, usingCaseId)
                        if(!anotherIea){
                            Inventory anotherInventory =  Inventory.findByCompanyIdAndAssociatedLpn(companyId, iea.parentLpn)
                            if(!anotherInventory){
                                InventoryEntityAttribute parentIea = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, iea.parentLpn)
                                if(parentIea)
                                    parentIea.delete(flush: true, failOnError: true)
                            }
                        }
                    }
                    inventorywithMoreQty.associatedLpn = null
                    inventorywithMoreQty.locationId = iea.locationId
                    iea.delete(flush: true, failOnError: true)
                }
                inventorywithMoreQty.save(flush: true, failOnError: true)
            }

            if(deleteQty > 0){
                def inventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = '${uom}' and inv.quantity <= '${quantity}' and inv.associatedLpn = '${usingCaseId}' order by inv.quantity desc")


                for(inventory in inventories){
                    if(inventory && deleteQty > 0 && deleteQty <= inventory.quantity){

                        InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                        if(inventoryEntityAttribute){
                            inventoryEntityAttribute.delete(flush: true, failOnError: true)
                        }
                        deleteQty -= inventory.quantity
                        inventory.delete(flush: true, failOnError: true)
                    }
                }
            }



            if(deleteQty > 0){
                Item item = Item.findByCompanyIdAndItemId(companyId, itemId)
                if(uom == "EACH"){
                    def caseInventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = 'CASE' and inv.associatedLpn = '${usingCaseId}' ")



                    for(inventory in caseInventories){
                        if(inventory && inventory.quantity > 0 && deleteQty > 0){
                            Integer eachQuantity = inventory.quantity * item.eachesPerCase
                            if(deleteQty < eachQuantity){
                                inventory.quantity = inventory.quantity * item.eachesPerCase - deleteQty
                                //TODO CASE and Each
                                inventory.handlingUom = "EACH"
                                inventory.save(flush: true, failOnError: true)
                                deleteQty = 0
                            }
                            else {

                                InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                                if(inventoryEntityAttribute){
                                    inventoryEntityAttribute.delete(flush: true, failOnError: true)
                                }
                                deleteQty -= eachQuantity
                                inventory.delete(flush: true, failOnError: true)
                            }
                        }
                    }


                }
                else{

                    def eachInventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = 'EACH' and inv.associatedLpn = '${usingCaseId}' ")
                    deleteQty = deleteQty * item.eachesPerCase

                    for(inventory in eachInventories){
                        if(inventory && inventory.quantity > 0 && deleteQty > 0){
                            if(deleteQty < inventory.quantity){
                                inventory.quantity = inventory.quantity - deleteQty
                                inventory.save(flush: true, failOnError: true)
                                deleteQty = 0
                            }
                            else{
                                InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                                if(inventoryEntityAttribute){
                                    inventoryEntityAttribute.delete(flush: true, failOnError: true)
                                }
                                deleteQty -= inventory.quantity
                                inventory.delete(flush: true, failOnError: true)
                            }
                        }


                    }



                }
            }

        }
        else if(deleteQty > 0){

            log.info("333333  " + usingCaseId)


            Inventory inventorywithMoreQty = Inventory.find("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = '${uom}' and inv.quantity > '${quantity}' ")

            if(inventorywithMoreQty){
                inventorywithMoreQty.quantity -= quantity
                deleteQty -= quantity
                inventorywithMoreQty.save(flush: true, failOnError: true)
            }

            if(deleteQty > 0){

                log.info("44444444  " + deleteQty)

                def inventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = '${uom}' and inv.quantity <= '${quantity}' order by inv.quantity desc")


                for(inventory in inventories){
                    if(inventory && deleteQty > 0 && deleteQty <= inventory.quantity){

                        InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                        if(inventoryEntityAttribute){
                            inventoryEntityAttribute.delete(flush: true, failOnError: true)
                        }
                        deleteQty -= inventory.quantity
                        inventory.delete(flush: true, failOnError: true)
                    }
                }
            }



            if(deleteQty > 0){
                Item item = Item.findByCompanyIdAndItemId(companyId, itemId)
                if(uom == "EACH"){
                    def caseInventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = 'CASE' ")



                    for(inventory in caseInventories){
                        if(inventory && inventory.quantity > 0 && deleteQty > 0){
                            Integer eachQuantity = inventory.quantity * item.eachesPerCase
                            if(deleteQty < eachQuantity){
                                inventory.quantity = inventory.quantity * item.eachesPerCase - deleteQty
                                //TODO CASE and Each
                                inventory.handlingUom = "EACH"
                                inventory.save(flush: true, failOnError: true)
                                deleteQty = 0
                            }
                            else {

                                InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                                if(inventoryEntityAttribute){
                                    inventoryEntityAttribute.delete(flush: true, failOnError: true)
                                }
                                deleteQty -= eachQuantity
                                inventory.delete(flush: true, failOnError: true)
                            }
                        }
                    }


                }
                else{

                    def eachInventories = Inventory.findAll("from Inventory as inv where inv.companyId = '${companyId}' and inv.itemId = '${itemId}' and inv.inventoryStatus = '${inventoryStatus}' and inv.workReferenceNumber in ('${pickWorkReferences['workReferenceNumber'].join("', '")}') and inv.handlingUom = 'EACH' ")
                    deleteQty = deleteQty * item.eachesPerCase

                    for(inventory in eachInventories){
                        if(inventory && inventory.quantity > 0 && deleteQty > 0){
                            if(deleteQty < inventory.quantity){
                                inventory.quantity = inventory.quantity - deleteQty
                                inventory.save(flush: true, failOnError: true)
                                deleteQty = 0
                            }
                            else{
                                InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
                                if(inventoryEntityAttribute){
                                    inventoryEntityAttribute.delete(flush: true, failOnError: true)
                                }
                                deleteQty -= inventory.quantity
                                inventory.delete(flush: true, failOnError: true)
                            }
                        }


                    }



                }
            }

        }








        return true

    }



//    END KITTING INVENTORY

    def getKittingOrderComponentInventory(companyId, kittingOrderNumber){

        def pickWorkReferences = PickWork.findAll("from PickWork as pw where pw.companyId = '${companyId}' and pw.orderNumber = '${kittingOrderNumber}' and pw.pickType = 'KITTING' ")

        def sqlQuery = "SELECT iea.lpn, inv.handling_uom, inv.quantity, it.item_id, it.item_description, lv.description AS inventory_status, CASE WHEN iea.level = 'CASE' THEN iea.lpn END AS case_id, " +
                "CASE WHEN iea.parent_lpn IS NOT NULL " +
                "   THEN iea.parent_lpn " +
                "   ELSE CASE WHEN iea.level = 'PALLET' THEN iea.lpn END " +
                "END AS pallet_id " +


                "FROM inventory AS inv " +
                "LEFT JOIN inventory_entity_attribute AS iea ON inv.associated_lpn = iea.lpn AND iea.company_id='${companyId}' " +
                "INNER JOIN item AS it ON it.item_id = inv.item_id AND it.company_id='${companyId}' " +
                "INNER JOIN list_value AS lv ON lv.option_value = inv.inventory_status AND lv.company_id = '${companyId}' AND lv.option_group = 'INVSTATUS' " +
                "WHERE  inv.company_id='${companyId}' AND inv.work_reference_number  IN ('${pickWorkReferences['workReferenceNumber'].join("', '")}') "

        log.info("sqlQuery123  : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getKittingStageData(companyId, kittingInventoryId){

        KittingInventory kittingInventory = KittingInventory.findByCompanyIdAndId(companyId, kittingInventoryId)
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingInventory.kittingOrderNumber)
        ShipmentLine shipmentLine = ShipmentLine.findByCompanyIdAndOrderLineNumber(companyId, kittingOrder.orderInfo)

        if(shipmentLine){
            return Shipment.findByCompanyIdAndShipmentId(companyId, shipmentLine.shipmentId)
        }
    }

    def validateKittingDestinationLocation(companyId, destinationLocation, locationToConfirm){

        def sqlQuery = "SELECT * FROM location as l INNER JOIN area as a on l.area_id = a.area_id WHERE l.company_id = '${companyId}'  AND a.company_id = '${companyId}' AND ((l.location_barcode = '${locationToConfirm}' OR l.location_id = '${locationToConfirm}') AND a.is_staging = true AND l.location_id = '${destinationLocation}')"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def row =  sql.rows(sqlQuery)   
        return row  
    }

}
