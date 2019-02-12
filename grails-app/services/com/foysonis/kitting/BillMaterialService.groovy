package com.foysonis.kitting

import grails.transaction.Transactional
import groovy.sql.Sql


@Transactional
class BillMaterialService {
    def sessionFactory


    def getAllBillOfMaterialByCompanyId(String companyId){
        return BillMaterial.findAllByCompanyId(companyId)
    }

    def getBillOfMaterialByCompanyIdAndItemId(String companyId, String itemId){
        return BillMaterial.findByCompanyIdAndItemId(companyId, itemId)
    }

    def saveBillOfMaterial(BillMaterial billMaterial){
        billMaterial.createdDate = new Date()
        billMaterial.updatedDate = new Date()

        return billMaterial.save(flush: true, failOnError: true)
    }

    def updateBillOfMaterial(BillMaterial billMaterial){

        billMaterial.updatedDate = new Date()
        return billMaterial.save(flush: true, failOnError: true)

    }

    def deleteBillOfMaterial(String companyId, BillMaterial billMaterial){
        def billMaterialComponent = BillMaterialComponent.findAllByCompanyIdAndBomId(companyId, billMaterial.id)
        def billMaterialInstruction = BillMaterialInstruction.findAllByCompanyIdAndBomId(companyId, billMaterial.id)
        if (billMaterialComponent.size() > 0) {
            for(bomComponentData in billMaterialComponent) {
                bomComponentData.delete(flush: true, failOnError: true)
            }
        }

        if (billMaterialInstruction.size() > 0) {
            for(bomInstructionData in billMaterialInstruction) {
                bomInstructionData.delete(flush: true, failOnError: true)
            }
        }
        billMaterial.delete(flush: true, failOnError: true)
        return [status:"success"]
    }

    def saveBOMComponent(BillMaterialComponent billMaterialComponent){
        return billMaterialComponent.save(flush: true, failOnError: true)
    }

    def updateBOMComponent(BillMaterialComponent billMaterialComponent){
        return billMaterialComponent.save(flush: true, failOnError: true)
    }
    def deleteBOMComponent(BillMaterialComponent billMaterialComponent){
        billMaterialComponent.delete(flush: true, failOnError: true)
        return [status:"success"]
    }

    def searchBillOfMaterialByCompanyIdAndItemId(String companyId, String itemId){
        def sqlQuery = "SELECT bom.id AS bomId, bom.item_id AS itemId, bom.default_production_quantity AS defaultProductionQuantity, bom.finished_product_default_status AS finishedProductDefaultStatus, bom.production_uom AS productionUom, it.item_description AS itemDescription, lv.description AS finishedProductDefaultStatusDesc "
        sqlQuery += "FROM bill_material AS bom "
        sqlQuery += "INNER JOIN item AS it ON it.item_id = bom.item_id AND it.company_id='${companyId}' "
        sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = bom.finished_product_default_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        sqlQuery += "WHERE bom.company_id='${companyId}' "

        if(itemId){
            itemId = '%'+itemId+'%'
            sqlQuery += "AND (it.item_id LIKE '${itemId}' OR it.item_description LIKE '${itemId}') "
        }

        sqlQuery += "ORDER BY bom.created_date DESC "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getAllBOMWithItemDetailsByCompanyId(String companyId){
        def sqlQuery = "SELECT bom.id AS bomId, bom.item_id AS itemId, bom.default_production_quantity AS defaultProductionQuantity, bom.finished_product_default_status AS finishedProductDefaultStatus, bom.production_uom AS productionUom, it.item_description AS itemDescription, lv.description AS finishedProductDefaultStatusDesc "
        sqlQuery += "FROM bill_material AS bom "
        sqlQuery += "INNER JOIN item AS it ON it.item_id = bom.item_id AND it.company_id='${companyId}' "
        sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = bom.finished_product_default_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS' "
        sqlQuery += "WHERE bom.company_id='${companyId}' "
        sqlQuery += "ORDER BY bom.created_date DESC "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getAllBOMComponentDataByCompanyIdAndBomId(companyId,bomId){
        def sqlQuery = "SELECT bomCom.*, lv.description AS componentInventoryStatusDesc "
        sqlQuery += "FROM bill_material_component AS bomCom "
        sqlQuery += "INNER JOIN list_value AS lv ON lv.option_value = bomCom.component_inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS'"
        sqlQuery += "WHERE bomCom.company_id='${companyId}' AND bomCom.bom_id = ${bomId}"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)        
    }

    def saveBOMInstruction(BillMaterialInstruction billMaterialInstruction){
        return billMaterialInstruction.save(flush: true, failOnError: true)
    }

    def updateBOMInstruction(BillMaterialInstruction billMaterialInstruction){
        return billMaterialInstruction.save(flush: true, failOnError: true)
    }    

    def deleteBOMInstruction(BillMaterialInstruction billMaterialInstruction){
        billMaterialInstruction.delete(flush: true, failOnError: true)
        return [status:"success"]
    }

    def getAllBOMInstructionDataByCompanyIdAndBomId(companyId,bomId){
        def sqlQuery = "SELECT bomIns.*, lv.description AS inventoryStatusDesc "
        sqlQuery += "FROM bill_material_instruction AS bomIns "
        sqlQuery += "LEFT JOIN list_value AS lv ON lv.option_value = bomIns.inventory_status AND lv.company_id='${companyId}' AND lv.option_group = 'INVSTATUS'"
        sqlQuery += "WHERE bomIns.company_id='${companyId}' AND bomIns.bom_id = ${bomId} "
        sqlQuery += "ORDER BY bomIns.display_order_number"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)        
    }

    def moveUpBOMInstruction(companyId, bomId, bomInstructionId){

        BillMaterialInstruction billMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndBomIdAndId(companyId, bomId, bomInstructionId)
        BillMaterialInstruction nextBillMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndBomIdAndDisplayOrderNumberLessThan(companyId, bomId, billMaterialInstruction.displayOrderNumber, [sort: "displayOrderNumber", order: "desc"])

        Integer displayOrderNumber = billMaterialInstruction.displayOrderNumber
        billMaterialInstruction.displayOrderNumber = nextBillMaterialInstruction.displayOrderNumber

        nextBillMaterialInstruction.displayOrderNumber = displayOrderNumber
        nextBillMaterialInstruction.save(flush: true, failOnError: true)

        return billMaterialInstruction.save(flush: true, failOnError: true)
    }

    def moveDownBOMInstruction(companyId, bomId, bomInstructionId){

        BillMaterialInstruction billMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndBomIdAndId(companyId, bomId, bomInstructionId)
        BillMaterialInstruction nextBillMaterialInstruction = BillMaterialInstruction.findByCompanyIdAndBomIdAndDisplayOrderNumberGreaterThan(companyId, bomId, billMaterialInstruction.displayOrderNumber, [sort: "displayOrderNumber", order: "asc"])

        Integer displayOrderNumber = billMaterialInstruction.displayOrderNumber
        billMaterialInstruction.displayOrderNumber = nextBillMaterialInstruction.displayOrderNumber

        nextBillMaterialInstruction.displayOrderNumber = displayOrderNumber
        nextBillMaterialInstruction.save(flush: true, failOnError: true)

        return billMaterialInstruction.save(flush: true, failOnError: true)
    }
}
