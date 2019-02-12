package com.foysonis.inventory

import com.foysonis.item.HandlingUom
import com.foysonis.item.Item
import com.foysonis.kitting.BillMaterial
import com.foysonis.kitting.BillMaterialComponent
import com.foysonis.kitting.KittingOrder
import com.foysonis.orders.OrderLine
import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class InventorySummaryService {

    def sessionFactory
    def kittingOrderService

    def updateIncreasedInventory(companyId, itemId, inventoryStatus, increasedQuantity, unitOfMeasure){
        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)


        if(!inventorySummary){
            inventorySummary = new InventorySummary(companyId: companyId,
                                                    itemId: itemId,
                                                    inventoryStatus: inventoryStatus,
                                                    totalQuantity: getQauantityInLowestUOM(companyId,itemId, increasedQuantity, unitOfMeasure),
                                                    committedQuantity: 0,
                                                    uom: getInventorySummaryUOM(companyId, itemId))
        }
        else{
            inventorySummary.totalQuantity += getQauantityInLowestUOM(companyId,itemId, increasedQuantity, unitOfMeasure)
        }

        inventorySummary.save(flush: true, failOnError: true)

    }
    def updateDecreasedInventory(companyId, itemId, inventoryStatus, decreasedQuantity, unitOfMeasure){
        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)

        if (inventorySummary) {        
            inventorySummary.totalQuantity -= getQauantityInLowestUOM(companyId,itemId, decreasedQuantity, unitOfMeasure)

            if(inventorySummary.totalQuantity < 0)
                inventorySummary.totalQuantity = 0
        }
        else{
            inventorySummary = new InventorySummary(companyId: companyId,
                                                    itemId: itemId,
                                                    inventoryStatus: inventoryStatus,
                                                    totalQuantity: 0,
                                                    committedQuantity: 0,
                                                    uom: getInventorySummaryUOM(companyId, itemId))            
        }
        inventorySummary.save(flush: true, failOnError: true)
        deleteNonExistingInventorySummary(companyId, itemId, inventoryStatus)
    }

    def updateEditInventory(companyId, itemId, prevInventoryStatus, inventoryStatus, prevQuantity, quantity, unitOfMeasure){
        updateDecreasedInventory(companyId, itemId, prevInventoryStatus, prevQuantity, unitOfMeasure)
        updateIncreasedInventory(companyId, itemId, inventoryStatus, quantity, unitOfMeasure)

    }

    def updateDecreasedCommittedQuantity(companyId, itemId, inventoryStatus, decreasedQuantity, unitOfMeasure){
        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)


        inventorySummary.committedQuantity -= getQauantityInLowestUOM(companyId,itemId, decreasedQuantity, unitOfMeasure)

        inventorySummary.save(flush: true, failOnError: true)
        deleteNonExistingInventorySummary(companyId, itemId, inventoryStatus)

    }

    def getQauantityInLowestUOM(companyId, itemId, quantity, unitOfMeasure){
        def item = Item.findByItemIdAndCompanyId(itemId, companyId)
        def lowestUOM = item.lowestUom.toUpperCase()
        def quantityInLowestUOM = quantity
        unitOfMeasure = unitOfMeasure.toUpperCase()

        if(lowestUOM == HandlingUom.EACH) {
            if(unitOfMeasure == HandlingUom.CASE){
                quantityInLowestUOM = quantity * item.eachesPerCase
            }
            else if(unitOfMeasure == HandlingUom.PALLET){
                quantityInLowestUOM = quantity * item.eachesPerCase * item.casesPerPallet
            }
        }
        else if(lowestUOM == HandlingUom.CASE && unitOfMeasure == HandlingUom.PALLET){
            quantityInLowestUOM = quantity * item.casesPerPallet
        }
        return quantityInLowestUOM
    }

    def getInventorySummaryUOM(companyId, itemId){
        def item = Item.findByItemIdAndCompanyId(itemId, companyId)
        return item.lowestUom.toUpperCase()
    }

    def deleteNonExistingInventorySummary(companyId, itemId, inventoryStatus){
        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)

        if(inventorySummary && inventorySummary.committedQuantity == 0 && inventorySummary.totalQuantity == 0){
            inventorySummary.delete()
            return true
        }

    }

    def commitInventory(companyId, itemId, inventoryStatus, plannedQuantity, unitOfMeasure){
        def isCommitted = false
        def warningMessage = null

        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)

        if(!inventorySummary){
            // No inventory
            warningMessage = itemId + ": There is no inventory in the store to match order line requirement"
        }
        else{
            if(isCommittedQuantityExceedTotalQuantity(inventorySummary, plannedQuantity)){
                warningMessage = "Item " + itemId + ": There is not enough inventory in the warehouse to ship this item. The lines with this item cannot be planned into a shipment"
            }
            else{
                inventorySummary.committedQuantity += getQauantityInLowestUOM(companyId,itemId, plannedQuantity, unitOfMeasure)
                inventorySummary.save(flush: true, failOnError: true)
                isCommitted = true
            }
        }

        return [committedResult: isCommitted, error: warningMessage]

    }

    def commitTriggeredOrderInventory(companyId, itemId, inventoryStatus, plannedQuantity, unitOfMeasure, orderLineNumber){
        def isCommitted = false
        def warningMessage = null

        def inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)

        log.info("111111")
        if(!inventorySummary){
            log.info("22222222")


            def commitInventory = commitBOMComponents(companyId, itemId, inventoryStatus, plannedQuantity, unitOfMeasure, orderLineNumber)
            isCommitted = commitInventory['committedResult']
            warningMessage = commitInventory['error']

        }
        else{
            log.info("333333")


            Integer availableQuantity = inventorySummary.totalQuantity.toInteger() - inventorySummary.committedQuantity.toInteger()
            if(availableQuantity >= plannedQuantity ){
                log.info("44444444")

                inventorySummary.committedQuantity += getQauantityInLowestUOM(companyId,itemId, plannedQuantity, unitOfMeasure)
                inventorySummary.save(flush: true, failOnError: true)
                isCommitted = true
            }
            else{
                log.info("555555")


                def commitInventory = commitBOMComponents(companyId, itemId, inventoryStatus, (plannedQuantity.toInteger() - availableQuantity.toInteger()), unitOfMeasure, orderLineNumber)
                isCommitted = commitInventory['committedResult']
                warningMessage = commitInventory['error']
                log.info("warningMessage : " + commitInventory)

                if(isCommitted == true){
                    log.info("6666666")
                    inventorySummary.committedQuantity += getQauantityInLowestUOM(companyId,itemId, availableQuantity, unitOfMeasure)
                    inventorySummary.save(flush: true, failOnError: true)
                }


            }

        }

        return [committedResult: isCommitted, error: warningMessage]

    }

    def commitBOMComponents(companyId, itemId, inventoryStatus, plannedQuantity, unitOfMeasure, orderLineNumber)
    {
        Boolean isCommitted = false
        String warningMessage = null
        BillMaterial bom = BillMaterial.findByCompanyIdAndItemIdAndFinishedProductDefaultStatus(companyId, itemId, inventoryStatus)
        if(bom){
            def bomComponents = BillMaterialComponent.findAllByCompanyIdAndBomId(companyId, bom.id)
            Integer failedComponentIndex = -1
            Boolean isFailed = false

            bomComponents.eachWithIndex { bomComponent, index ->

                if(!isFailed){
                    InventorySummary inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, bomComponent.componentItemId, bomComponent.componentInventoryStatus)

                    if(!inventorySummary){

                        log.info(bomComponent.componentItemId + "aaaa")
                        // No inventory
                        warningMessage = bomComponent.componentItemId + " : There is no BOM Component inventory in the store to match order line requirement"
                        failedComponentIndex = index
                        isCommitted = false
                        isFailed =  true
                    }
                    else{
                        log.info(bomComponent.componentItemId + "bbbb")

                        if(isCommittedQuantityExceedTotalQuantity(inventorySummary, (plannedQuantity.toInteger() * bomComponent.componentQuantity.toInteger()))){
                            log.info(bomComponent.componentItemId + "ccccc")

                            warningMessage = "Item " + bomComponent.componentItemId + " : There is not enough inventory in the warehouse to ship this item. The lines with this item cannot be planned into a shipment"
                            failedComponentIndex = index
                            isCommitted = false
                            isFailed =  true
                        }
                        else{
                            log.info(bomComponent.componentItemId + "dddd")

//                            inventorySummary.committedQuantity += getQauantityInLowestUOM(companyId, bomComponent.componentItemId, (plannedQuantity.toInteger() * bomComponent.componentQuantity.toInteger()), bomComponent.componentUom)
//                            inventorySummary.save(flush: true, failOnError: true)
                            isCommitted = true
                            isFailed =  false
                        }
                    }
                }



            }

            log.info("failedComponentIndex :" + failedComponentIndex)

            if(isCommitted == false){


                log.info( "eeeee")

                warningMessage = "There is no BOM Component inventory in the store to match order line requirement"

//                if(failedComponentIndex != -1){
//
//
//                    log.info( "ffffff")
//
//                    def committedBomComponents = BillMaterialComponent.findAllByCompanyIdAndBomId(companyId, bom.id)
//
//                    committedBomComponents.eachWithIndex { bomComponent, index ->
//
//                        if(index < failedComponentIndex){
//
//
//                            log.info(bomComponent.componentItemId + "ggggg")
//                            InventorySummary inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, bomComponent.componentItemId, bomComponent.componentInventoryStatus)
//
//                            inventorySummary.committedQuantity -= getQauantityInLowestUOM(companyId, bomComponent.componentItemId, (plannedQuantity.toInteger() * bomComponent.componentQuantity.toInteger()), bomComponent.componentUom)
//                            inventorySummary.save(flush: true, failOnError: true)
//                        }
//                    }
//                }

            }
            else{
                // TODO
                OrderLine orderLine =  OrderLine.findByCompanyIdAndOrderLineNumber(companyId, orderLineNumber)
                orderLine.kittingOrderQuantity = plannedQuantity
                orderLine.save(flush: true, failOnError: true)

//                KittingOrder kittingOrder = kittingOrderService.copyBOMDataToKittingOrder(companyId,  bom, orderLineNumber)
//                kittingOrder.productionQuantity = plannedQuantity
//                kittingOrder.orderInfo = orderLineNumber
//                kittingOrder.save(flush: true, failOnError: true)
            }

        }
        else{

            warningMessage = "There is no BOM Component inventory in the store to match order line requirement"

        }

        return [committedResult: isCommitted, error: warningMessage]

    }



    def unCommitInventory(companyId, itemId, inventoryStatus, plannedQuantity, unitOfMeasure) {
        InventorySummary inventorySummary = InventorySummary.findByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId, inventoryStatus)
        inventorySummary.committedQuantity -= getQauantityInLowestUOM(companyId,itemId, plannedQuantity, unitOfMeasure)
        return inventorySummary.save(flush: true, failOnError: true)

    }

    def isCommittedQuantityExceedTotalQuantity(inventorySummary, plannedQuantity){
        def results = true
        if ((inventorySummary.committedQuantity + plannedQuantity) <= inventorySummary.totalQuantity)
            results = false

        return results

    }

    def UpdateInventorySummaryForInventoryMove(companyId, currentLocationArea, lpn){
        def inventories = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, lpn)

        for(inventory in inventories){

            if(currentLocationArea.isStorage == true){
                updateIncreasedInventory(companyId, inventory.itemId, inventory.inventoryStatus, inventory.quantity, inventory.handlingUom)
            }
            else{
                updateDecreasedInventory(companyId, inventory.itemId, inventory.inventoryStatus, inventory.quantity, inventory.handlingUom)
            }
        }
    }

    def getAllInventorySummary(String companyId){

        def sqlQuery ="SELECT invs.*, (invs.total_quantity - invs.committed_quantity) AS available_qty, lv.description AS inventory_status_desc FROM inventory_summary AS invs LEFT JOIN list_value as lv ON lv.option_value = invs.inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}' WHERE invs.company_id = '${companyId}' "
        log.info("sqlQuery :" + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }
}
