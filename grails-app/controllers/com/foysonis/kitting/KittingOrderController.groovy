package com.foysonis.kitting

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN'])
class KittingOrderController extends RestfulController<KittingOrder> {

	def kittingOrderService
    def springSecurityService
    def inventoryService

    static responseFormats = ['json', 'xml']

    KittingOrderController(){
    	super(KittingOrder)
    }

    def index() { 
        String pageTitle = "Kitting Order";
        [pageTitle: pageTitle]
    }

    def searchKittingOrderByCompanyIdAndItemId = {

        def kittingSearchData = [:]
        kittingSearchData.currentPageNum = params.currentPageNum
        kittingSearchData.kittingSearchForCount = false


        respond kittingOrderService.searchKittingOrderByCompanyIdAndItemId(springSecurityService.currentUser.companyId, params.itemId, params.kittingOrderNumber, params.kittingOrderStatus, params.orderNumber,kittingSearchData)
    }

    def searchKittingOrderForCount = {

        def kittingSearchData = [:]
        kittingSearchData.kittingSearchForCount = true

        respond kittingOrderService.searchKittingOrderByCompanyIdAndItemId(springSecurityService.currentUser.companyId, params.itemId, params.kittingOrderNumber, params.kittingOrderStatus, params.orderNumber, kittingSearchData)
    }    

    def saveKittingOrder() {
        def jsonObject = request.JSON
        KittingOrder kittingOrder = new KittingOrder(jsonObject)
        kittingOrder.companyId = springSecurityService.currentUser.companyId      
        respond kittingOrderService.saveKittingOrder(kittingOrder)
    }

    def getAllKittingOrderWithItemDetailsByCompanyId = {
        respond kittingOrderService.getAllKittingOrderWithItemDetailsByCompanyId(springSecurityService.currentUser.companyId)
    }

    def  updateKittingOrder() {
        def jsonObject = request.JSON
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(springSecurityService.currentUser.companyId,jsonObject.kitting_order_number)
        kittingOrder.companyId = springSecurityService.currentUser.companyId
        kittingOrder.kittingItemId = jsonObject.kitting_item_id
        kittingOrder.finishedProductInventoryStatus = jsonObject.finished_product_inventory_status
        kittingOrder.productionQuantity = jsonObject.production_quantity
        kittingOrder.productionUom = jsonObject.production_uom
        kittingOrder.orderInfo = jsonObject.order_info
        respond kittingOrderService.updateKittingOrder(kittingOrder)
    }   

    def deleteKittingOrder(){
        def jsonObject = request.JSON
        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumberAndKittingItemId(springSecurityService.currentUser.companyId,jsonObject.kittingOrderNumber, jsonObject.itemId)
        if (kittingOrder) {
            respond kittingOrderService.deleteKittingOrder(springSecurityService.currentUser.companyId, kittingOrder)
        }
    }

    def saveKittingOrderComponent(){
        def jsonObject = request.JSON
        KittingOrderComponent kittingOrderComponent = new KittingOrderComponent(jsonObject)
        kittingOrderComponent.companyId = springSecurityService.currentUser.companyId
        respond kittingOrderService.saveKittingOrderComponent(kittingOrderComponent)        
    }
    def updateKittingOrderComponent(){
        def jsonObject = request.JSON
        KittingOrderComponent kittingOrderComponent = KittingOrderComponent.findByCompanyIdAndKittingOrderNumberAndId(springSecurityService.currentUser.companyId,jsonObject.kittingOrderNumber,jsonObject.componentId)
        if (kittingOrderComponent) {
            kittingOrderComponent.componentItemId = jsonObject.componentItemId
            kittingOrderComponent.componentQuantity = jsonObject.componentQuantity
            kittingOrderComponent.componentInventoryStatus = jsonObject.componentInventoryStatus
            kittingOrderComponent.componentUom = jsonObject.componentUom
            respond kittingOrderService.updateKittingOrderComponent(kittingOrderComponent)             
        }
       
    }
    def deleteKittingOrderComponent(){
        def jsonObject = request.JSON
        KittingOrderComponent kittingOrderComponent = KittingOrderComponent.findByCompanyIdAndIdAndComponentItemId(springSecurityService.currentUser.companyId,jsonObject.componentId,jsonObject.componentItemId)
        if (kittingOrderComponent) {
            respond kittingOrderService.deleteKittingOrderComponent(kittingOrderComponent)             
        }        
    } 

    def getAllKOComponentDataByCompanyIdAndOrdNum = {
        respond kittingOrderService.getAllKOComponentDataByCompanyIdAndOrdNum(springSecurityService.currentUser.companyId, params.kittingOrdNum)
    }    

    def saveKittingOrderInstruction(){
        def jsonObject = request.JSON
        KittingOrderInstruction kittingOrderInstruction = new KittingOrderInstruction(jsonObject)
        kittingOrderInstruction.companyId = springSecurityService.currentUser.companyId
        def kittingOrderDispalyOrdNum = KittingOrderInstruction.find("from KittingOrderInstruction as koi where koi.companyId='${springSecurityService.currentUser.companyId}' AND koi.kittingOrderNumber = '${jsonObject.kittingOrderNumber}' order by koi.displayOrderNumber DESC")
        if (!kittingOrderDispalyOrdNum) {
            kittingOrderInstruction.displayOrderNumber =  1
        }
        else{
            kittingOrderInstruction.displayOrderNumber = kittingOrderDispalyOrdNum.displayOrderNumber +1
        }
        respond kittingOrderService.saveKittingOrderInstruction(kittingOrderInstruction)        
    }

    def updateKittingOrderInstruction(){
        def jsonObject = request.JSON
        KittingOrderInstruction kittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndKittingOrderNumberAndId(springSecurityService.currentUser.companyId,jsonObject.kittingOrderNumber,jsonObject.instructionIdPrimary)
        if (kittingOrderInstruction) {
            kittingOrderInstruction.instruction = jsonObject.instruction
            kittingOrderInstruction.instructionType = jsonObject.instructionType
            kittingOrderInstruction.inventoryStatus = jsonObject.inventoryStatus
            kittingOrderInstruction.instructionId = jsonObject.instructionId
            respond kittingOrderService.updateKittingOrderInstruction(kittingOrderInstruction)             
        }
       
    }

    def deleteKittingOrderInstruction(){
        def jsonObject = request.JSON
        KittingOrderInstruction kittingOrderInstruction = KittingOrderInstruction.findByCompanyIdAndId(springSecurityService.currentUser.companyId,jsonObject.instructionId)
        if (kittingOrderInstruction) {
            respond kittingOrderService.deleteKittingOrderInstruction(kittingOrderInstruction)             
        }        
    } 

    def getAllKittingOrderInstructionDataByCompanyIdAndBomId = {
        respond kittingOrderService.getAllKittingOrderInstructionDataByCompanyIdAndBomId(springSecurityService.currentUser.companyId, params.kittingOrdNum)
    }

    def getAllKittingOrderInventoryDataByKittingOrderNumber = {
        respond kittingOrderService.getAllKittingOrderInventoryDataByKittingOrderNumber(springSecurityService.currentUser.companyId, params.kittingOrdNum)
    }    

    def copyBOMDataToKittingOrder = {
    	BillMaterial billMaterial = BillMaterial.findByCompanyIdAndItemId(springSecurityService.currentUser.companyId, params.itemId)
    	if (billMaterial) {
    		respond kittingOrderService.copyBOMDataToKittingOrder(springSecurityService.currentUser.companyId, billMaterial, params.kittingOrderNumber)
    	}
    }

    def getSelectedKittingOrderByKittingOrderNumber = {
    	respond kittingOrderService.getSelectedKittingOrderByKittingOrderNumber(springSecurityService.currentUser.companyId, params.kittingOrderNumber)
    }      

    def getKittingLocationsByArea ={
    	respond kittingOrderService.getKittingLocationsByArea(springSecurityService.currentUser.companyId, params.keyword)
    }

    def validatePalletIdForKitting = {
        respond kittingOrderService.validatePalletIdForKitting(session.user.companyId, params.palletId, params.kittingOrderNumber)
    }

    def validateCaseIdForKitting = {
        respond kittingOrderService.validateCaseIdForKitting(session.user.companyId, params.caseId, params.kittingOrderNumber)
    }

    def  saveKittingInventory() {
        respond kittingOrderService.saveKittingInventory(session.user.companyId, params['kittingOrderNumber'], params['palletId'], params['caseId'], params['uom'], params['quantity'].toInteger(), params['lotCode'], params['expirationDate'], params['inventoryStatus'], session.user.username, params['itemId'], params['itemNote'])
    }

    def saveKittingPutaway = {
        respond kittingOrderService.saveKittingPutaway(springSecurityService.currentUser.companyId, params.lpn, params.caseId, params.locationId, params.kittingInventoryId)
    }

    def saveKittingStage = {
        respond kittingOrderService.saveKittingStage(springSecurityService.currentUser.companyId, params.lpn, params.caseId, params.kittingInventoryId)
    }

    def saveKittingInventoryInstruction = {
    	respond kittingOrderService.saveKittingInventoryInstruction(springSecurityService.currentUser.companyId, params.kittingOrderNumber, params.kittingOrderInstructionId, params.kittingInventoryId, params.status, params.kittingInventoryStatus)
    }

    def saveKittingInventoryForFinalInstruction = {
    	respond kittingOrderService.saveKittingInventoryForFinalInstruction(springSecurityService.currentUser.companyId, springSecurityService.currentUser.username, params.kittingOrderNumber, params.kittingInventoryId, params.kOFinishedProductStatus)
    }

    def getKittingInventoryDataForValidation = {
    	respond kittingOrderService.getKittingInventoryDataForValidation(springSecurityService.currentUser.companyId, params.lpn, params.lpnType, params.kittingOrderNumber)
    }

    def getUnCompletedInstructionForKittingInventory = {
        respond kittingOrderService.getUnCompletedInstructionForKittingInventory(springSecurityService.currentUser.companyId,  params.kittingOrderNumber, params.kittingInventoryId)
    }

    def getReceivedKittingInventoryTotalQuantity = {
        respond kittingOrderService.getReceivedKittingInventoryTotalQuantity(springSecurityService.currentUser.companyId,  params.kittingOrderNumber)
    }

    def moveUpKittingOrderInstruction = {
        respond kittingOrderService.moveUpKittingOrderInstruction(springSecurityService.currentUser.companyId,  params.kittingOrderNumber, params.kittingOrderInstructionId)
    }

    def moveDownKittingOrderInstruction = {
        respond kittingOrderService.moveDownKittingOrderInstruction(springSecurityService.currentUser.companyId,  params.kittingOrderNumber, params.kittingOrderInstructionId)
    }

    def getKittingOrderComponentInventory = {
        respond kittingOrderService.getKittingOrderComponentInventory(springSecurityService.currentUser.companyId,  params.kittingOrderNumber)
    }

    def getKittingStageData = {
        respond kittingOrderService.getKittingStageData(springSecurityService.currentUser.companyId,  params.kittingInventoryId)
    }

    def validateKittingDestinationLocation = {
        respond kittingOrderService.validateKittingDestinationLocation(springSecurityService.currentUser.companyId,  params.destinationLocation, params.locationToConfirm)
    }

}
