package com.foysonis.kitting

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN'])
class BillMaterialController extends RestfulController<BillMaterial>  {

    BillMaterialService billMaterialService
    def springSecurityService

    static responseFormats = ['json', 'xml']

    BillMaterialController() {
        super(BillMaterial)
    }


    def index() {
        String pageTitle = "Bill Of Material";
        [pageTitle: pageTitle]

    }

    def kittingOrder() {
        String pageTitle = "Kitting Order";
        [pageTitle: pageTitle]

    }

    def getAllBillOfMaterialByCompanyId = {
        respond billMaterialService.getAllBillOfMaterialByCompanyId(springSecurityService.currentUser.companyId)
    }

    def getAllBOMWithItemDetailsByCompanyId = {
        respond billMaterialService.getAllBOMWithItemDetailsByCompanyId(springSecurityService.currentUser.companyId)
    }

    def getAllBOMComponentDataByCompanyIdAndBomId = {
        respond billMaterialService.getAllBOMComponentDataByCompanyIdAndBomId(springSecurityService.currentUser.companyId, params.bomId)
    }

    def getBillOfMaterialByCompanyIdAndItemId = {
        respond billMaterialService.getBillOfMaterialByCompanyIdAndItemId(springSecurityService.currentUser.companyId, params.itemId)
    }

    def searchBillOfMaterialByCompanyIdAndItemId = {
        respond billMaterialService.searchBillOfMaterialByCompanyIdAndItemId(springSecurityService.currentUser.companyId, params.itemId)
    }

    def  saveBillOfMaterial() {
        def jsonObject = request.JSON
        BillMaterial billMaterial = new BillMaterial(jsonObject)
        billMaterial.companyId = springSecurityService.currentUser.companyId
        respond billMaterialService.saveBillOfMaterial(billMaterial)
    }

    def  updateBillOfMaterial() {
        def jsonObject = request.JSON
        BillMaterial billMaterial = BillMaterial.findById(jsonObject.bomId)
        billMaterial.companyId = springSecurityService.currentUser.companyId
        billMaterial.itemId = jsonObject.itemId
        billMaterial.finishedProductDefaultStatus = jsonObject.finishedProductDefaultStatus
        billMaterial.defaultProductionQuantity = jsonObject.defaultProductionQuantity
        billMaterial.productionUom = jsonObject.productionUom
        respond billMaterialService.updateBillOfMaterial(billMaterial)
    }

    def deleteBillOfMaterial(){
        def jsonObject = request.JSON
        BillMaterial billMaterial = BillMaterial.findByCompanyIdAndIdAndItemId(springSecurityService.currentUser.companyId,jsonObject.bomId, jsonObject.itemId)
        if (billMaterial) {
            respond billMaterialService.deleteBillOfMaterial(springSecurityService.currentUser.companyId, billMaterial)
        }
    }

    def saveBOMComponent(){
        def jsonObject = request.JSON
        BillMaterialComponent billMaterialComponent = new BillMaterialComponent(jsonObject)
        billMaterialComponent.companyId = springSecurityService.currentUser.companyId
        respond billMaterialService.saveBOMComponent(billMaterialComponent)        
    }
    def updateBOMComponent(){
        def jsonObject = request.JSON
        BillMaterialComponent billMaterialComponent = BillMaterialComponent.findByCompanyIdAndBomIdAndId(springSecurityService.currentUser.companyId,jsonObject.bomId,jsonObject.componentId)
        if (billMaterialComponent) {
            billMaterialComponent.componentItemId = jsonObject.componentItemId
            billMaterialComponent.componentQuantity = jsonObject.componentQuantity
            billMaterialComponent.componentInventoryStatus = jsonObject.componentInventoryStatus
            billMaterialComponent.componentUom = jsonObject.componentUom
            respond billMaterialService.updateBOMComponent(billMaterialComponent)             
        }
       
    }
    def deleteBOMComponent(){
        def jsonObject = request.JSON
        BillMaterialComponent billMaterialComponent = BillMaterialComponent.findByCompanyIdAndIdAndComponentItemId(springSecurityService.currentUser.companyId,jsonObject.componentId,jsonObject.componentItemId)
        if (billMaterialComponent) {
            respond billMaterialService.deleteBOMComponent(billMaterialComponent)             
        }        
    }

    def saveBOMInstruction(){
        def jsonObject = request.JSON
        BillMaterialInstruction billMaterialInstruction = new BillMaterialInstruction(jsonObject)
        billMaterialInstruction.companyId = springSecurityService.currentUser.companyId
        def bOMDispalyOrdNum = BillMaterialInstruction.find("from BillMaterialInstruction as bom where bom.companyId='${springSecurityService.currentUser.companyId}' AND bom.bomId = '${jsonObject.bomId}' order by bom.displayOrderNumber DESC")
        if (!bOMDispalyOrdNum) {
            billMaterialInstruction.displayOrderNumber =  1

        }
        else{
            billMaterialInstruction.displayOrderNumber = bOMDispalyOrdNum.displayOrderNumber +1
        }

        respond billMaterialService.saveBOMInstruction(billMaterialInstruction)        
    }

    def updateBOMInstruction(){
        def jsonObject = request.JSON
        BillMaterialInstruction billMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndBomIdAndId(springSecurityService.currentUser.companyId,jsonObject.bomId,jsonObject.instructionIdPrimary)
        if (billMaterialInstruction) {
            billMaterialInstruction.instruction = jsonObject.instruction
            billMaterialInstruction.instructionType = jsonObject.instructionType
            billMaterialInstruction.inventoryStatus = jsonObject.inventoryStatus
            billMaterialInstruction.instructionId = jsonObject.instructionId
            respond billMaterialService.updateBOMInstruction(billMaterialInstruction)             
        }
       
    }

    def deleteBOMInstruction(){
        def jsonObject = request.JSON
        BillMaterialInstruction billMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndId(springSecurityService.currentUser.companyId,jsonObject.instructionId)
        if (billMaterialInstruction) {
            respond billMaterialService.deleteBOMInstruction(billMaterialInstruction)             
        }        
    }    

    def getAllBOMInstructionDataByCompanyIdAndBomId = {
        respond billMaterialService.getAllBOMInstructionDataByCompanyIdAndBomId(springSecurityService.currentUser.companyId, params.bomId)
    }


    def moveUpBOMInstruction = {
        respond billMaterialService.moveUpBOMInstruction(springSecurityService.currentUser.companyId,  params.bomId, params.bomInstructionId)
    }

    def moveDownBOMInstruction = {
        respond billMaterialService.moveDownBOMInstruction(springSecurityService.currentUser.companyId,  params.bomId, params.bomInstructionId)
    }



}
