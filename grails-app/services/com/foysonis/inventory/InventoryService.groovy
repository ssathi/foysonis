package com.foysonis.inventory

import com.foysonis.area.Area
import com.foysonis.area.Location
import com.foysonis.item.HandlingUom
import com.foysonis.picking.PickWorkStatus
import grails.transaction.Transactional
import groovy.sql.Sql
import com.foysonis.area.LocationService
import com.foysonis.item.Item

@Transactional
class InventoryService {
    def sessionFactory
    def inventorySummaryService
    def locationService
    def inventoryAdjustmentService
    def moveInventoryService
    def entityLastRecordService

    def getItemsForGivenLpn(companyId,lpn){
        def inventory = Inventory.findByCompanyIdAndAssociatedLpn(companyId,lpn)
        if(inventory == null){
            inventory = {}
        }
        return inventory

    }

    def movePalletToLocation(companyId, palletId, locationId, username){
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "PALLET", palletId)
        def prevLocationArea = locationService.getAreaForLocation(companyId, inventoryEntityAttribute.locationId)
        def currentLocationArea = locationService.getAreaForLocation(companyId, locationId)
        String prevLocationId = inventoryEntityAttribute.locationId

        inventoryEntityAttribute.locationId = locationId
        inventoryEntityAttribute.save(flush: true, failOnError: true)

        //Update Move Inventory History
        moveInventoryService.saveMovePalletHistory(companyId, prevLocationId, locationId, palletId, username)

        //Update Inventory Summary Module
        if(prevLocationArea.isStorage != currentLocationArea.isStorage){

            def secondLevelInventoryEntityAttributes = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, palletId)

            if(secondLevelInventoryEntityAttributes){

                for(secondLevelInventoryEntityAttribute in secondLevelInventoryEntityAttributes){
                    inventorySummaryService.UpdateInventorySummaryForInventoryMove(companyId, currentLocationArea, secondLevelInventoryEntityAttribute.lPN)
                }

            }

            inventorySummaryService.UpdateInventorySummaryForInventoryMove(companyId, currentLocationArea, palletId)

        }

        return inventoryEntityAttribute

    }


    def movePalletToBinLocation(companyId, palletId, toLocationId, username){
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "PALLET", palletId)

        if (inventoryEntityAttribute) {
            String prevLocationId = inventoryEntityAttribute.locationId

            def inventoryEntityAttrByParentLpn = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, palletId)

            if (inventoryEntityAttrByParentLpn.size() > 0) {
                // for(inventoryEntityAttrData in inventoryEntityAttrByParentLpn) {
                //     palletOrCaseToEaches(companyId, inventoryEntityAttrData.lPN, toLocationId)

                //     def secondaryLpnExist = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId,inventoryEntityAttrData.lPN)
                //     if (secondaryLpnExist.size() == 0) {
                //         inventoryEntityAttrData.delete(flush: true, failOnError: true)
                //     }

                // }
                return [isPalletContainsCases : true]
            }
            else{
                palletOrCaseToEaches(companyId, palletId, toLocationId)
            }

            def lpnExist = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId,palletId)
            if (lpnExist.size() == 0) {
                    inventoryEntityAttribute.delete(flush: true, failOnError: true)
            }

            //Update Move Inventory History
            moveInventoryService.saveMovePalletHistory(companyId, prevLocationId, toLocationId, palletId, username)


        }
//        return true
    }

    def palletOrCaseToEaches(companyId, associatedLpn, locationId){

        def inventoryData = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, associatedLpn)
        if (inventoryData.size() > 0) {
            for(inventory in inventoryData) {
               def calculatedInventoryQty = 0
               def itemData = Item.findByCompanyIdAndItemId(companyId, inventory.itemId)
               if (itemData.lowestUom == HandlingUom.EACH && inventory.handlingUom == HandlingUom.CASE) {
                   calculatedInventoryQty = (itemData.eachesPerCase.toInteger() * inventory.quantity.toInteger())
               }
               else if (itemData.lowestUom == HandlingUom.EACH && inventory.handlingUom == HandlingUom.EACH) {
                   calculatedInventoryQty = inventory.quantity
               }

               inventory.quantity = calculatedInventoryQty
               inventory.associatedLpn = null
               inventory.handlingUom = HandlingUom.EACH
               inventory.locationId = locationId
               inventory.save(flush: true, failOnError: true)
            }


        }
    }

    def checkLowestUomOfItemByLpn(companyId, lpn){

        def sqlQuery ="SELECT * FROM inventory_entity_attribute AS iea INNER JOIN inventory as inv ON inv.associated_lpn = iea.lpn AND inv.company_id = '${companyId}' INNER JOIN item AS itm ON inv.item_id = itm.item_id AND itm.company_id = '${companyId}' WHERE iea.company_id = '${companyId}' AND (iea.lpn = '${lpn}' OR iea.parent_lpn = '${lpn}') AND itm.lowest_uom = '${HandlingUom.CASE}'"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }


    def moveCaseToPallet(companyId, caseId, palletId, username){
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "CASE", caseId)

        def prevLocationId = getLocationIdForAnyLpn(companyId, caseId)
        def prevLocationArea = locationService.getAreaForLocation(companyId, prevLocationId)

        def currentLocationId = getLocationIdForAnyLpn(companyId, palletId)
        def currentLocationArea = locationService.getAreaForLocation(companyId, currentLocationId)


        inventoryEntityAttribute.locationId = null
        inventoryEntityAttribute.parentLpn = palletId
        inventoryEntityAttribute.save(flush: true, failOnError: true)

        //Update Inventory Summary Module
        if(prevLocationArea.isStorage != currentLocationArea.isStorage){
            inventorySummaryService.UpdateInventorySummaryForInventoryMove(companyId, currentLocationArea, caseId)
        }
        //Update Move Inventory History
        moveInventoryService.saveMoveCaseToPalletHistory(companyId, prevLocationId, palletId, caseId, username)

        return true

    }

    def moveCaseToLocation(companyId, caseId, locationId, username){
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "CASE", caseId)

        def prevLocationId = getLocationIdForAnyLpn(companyId, caseId)
        def prevLocationArea = locationService.getAreaForLocation(companyId, prevLocationId)

        def currentLocationArea = locationService.getAreaForLocation(companyId, locationId)

        inventoryEntityAttribute.locationId = locationId
        inventoryEntityAttribute.parentLpn = null
        inventoryEntityAttribute.save(flush: true, failOnError: true)

        //Update Inventory Summary Module
        if(prevLocationArea.isStorage != currentLocationArea.isStorage){
            inventorySummaryService.UpdateInventorySummaryForInventoryMove(companyId, currentLocationArea, caseId)
        }

        //Update Move Inventory History
        moveInventoryService.saveMoveCaseToLocationHistory(companyId, prevLocationId, locationId, caseId, username)

        return true


    }

    def moveCaseToBinLocation(companyId, caseId, locationId, username){
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "CASE", caseId)

        if (inventoryEntityAttribute) {
            palletOrCaseToEaches(companyId, caseId, locationId)

            def parentLpnOfCase = inventoryEntityAttribute.parentLpn
            def caseToRemove = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, caseId)
            if (caseToRemove.size() == 0) {
                inventoryEntityAttribute.delete(flush: true, failOnError: true)
            }
            if (parentLpnOfCase) {
                def dataByParentLpn = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, parentLpnOfCase)
                if (dataByParentLpn.size() == 0) {
                    def parentLpnRemove = InventoryEntityAttribute.findByCompanyIdAndLevelAndLPN(companyId, "PALLET", parentLpnOfCase)
                    parentLpnRemove.delete(flush: true, failOnError: true)
                }
            }
            //Update Move Inventory History
            def prevLocationId = getLocationIdForAnyLpn(companyId, caseId)
            moveInventoryService.saveMoveCaseToLocationHistory(companyId, prevLocationId, locationId, caseId, username)

        }
        return true

    }


    def moveEntireLocation(companyId, fromLocation, toLocation, username){
        def sqlQuery = "UPDATE inventory as i SET i.location_id = '${toLocation}' WHERE i.company_id = '${companyId}' AND i.location_id = '${fromLocation}'"

        def sqlQuery2 = "UPDATE inventory_entity_attribute as iea SET iea.location_id = '${toLocation}' WHERE iea.company_id = '${companyId}' AND iea.location_id = '${fromLocation}'"

        def sql = new Sql(sessionFactory.currentSession.connection())
        //Update Move Inventory History
        moveInventoryService.saveMoveEntireLocationHistory(companyId, fromLocation, toLocation, username)
        sql.execute(sqlQuery)
        sql.execute(sqlQuery2)
    }

    def moveEntireLocationToBinLocation(companyId, fromLocation, toLocation, username){
        def inventoryOnLocation = Inventory.findAllByCompanyIdAndLocationId(companyId, fromLocation)
        if (inventoryOnLocation.size() > 0) {
            for(inventoryData in inventoryOnLocation) {
                def calculatedInventoryQty = 0
                def itemData = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)
                if (itemData.lowestUom == HandlingUom.EACH && inventoryData.handlingUom == HandlingUom.CASE) {
                   calculatedInventoryQty = (itemData.eachesPerCase.toInteger() * inventoryData.quantity.toInteger())
                }
                else if (itemData.lowestUom == HandlingUom.EACH && inventoryData.handlingUom == HandlingUom.EACH) {
                   calculatedInventoryQty = inventoryData.quantity
                }

                inventoryData.quantity = calculatedInventoryQty
                inventoryData.associatedLpn = null
                inventoryData.handlingUom = HandlingUom.EACH
                inventoryData.locationId = toLocation
                inventoryData.save(flush: true, failOnError: true)
            }
        }

        def inventoryEntityAttribute = InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, fromLocation)

        if (inventoryEntityAttribute.size() > 0) {
            for(inventoryEntityAttrData in inventoryEntityAttribute) {
                def dataByParentLpn = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, inventoryEntityAttrData.lPN)
                if (dataByParentLpn.size() > 0) {
                    for(invByParentLpn in dataByParentLpn) {
                        palletOrCaseToEaches(companyId, invByParentLpn.lPN, toLocation)
                        def secondaryLpnExist = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId,invByParentLpn.lPN)
                        if (secondaryLpnExist.size() == 0) {
                            invByParentLpn.delete(flush: true, failOnError: true)
                        }
                    }
                }
                else{
                    palletOrCaseToEaches(companyId, inventoryEntityAttrData.lPN, toLocation)
                }
                def lpnExist = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId,inventoryEntityAttrData.lPN)
                if (lpnExist.size() == 0) {
                    def lpnToRemove = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId,inventoryEntityAttrData.lPN)
                    if (lpnToRemove) {
                        lpnToRemove.delete(flush: true, failOnError: true)
                    }

                }

            }
        }
        // else{
        //     palletOrCaseToEaches(companyId, palletId, toLocation)
        // }


        //Update Move Inventory History
        moveInventoryService.saveMoveEntireLocationHistory(companyId, fromLocation, toLocation, username)

        return true

    }

    def checkLowestUomOfItemByLocation(companyId, locationId){
        def sqlQuery ="SELECT i.*, itm.* FROM inventory as i INNER JOIN item as itm ON itm.item_id = i.item_id AND itm.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn AND iea.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn  AND ieap.company_id = '${companyId}' WHERE i.company_id = '${companyId}' AND (i.location_id = '${locationId}' OR iea.location_id = '${locationId}' OR ieap.location_id = '${locationId}') AND (itm.lowest_uom = '${HandlingUom.CASE}' OR itm.is_case_tracked = true)"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def moveEachesToLocation(companyId, fromLocation, toLocation, itemId, inventoryStatus, moveQty, totalQty, username){

        if (moveQty.toInteger() == totalQty.toInteger()) {
            def sqlQuery = "UPDATE inventory as i SET i.location_id = '${toLocation}' WHERE i.company_id = '${companyId}' AND i.location_id = '${fromLocation}' AND i.handling_uom = '${HandlingUom.EACH}' AND i.item_id = '${itemId}' AND i.associated_lpn IS NULL AND i.inventory_status = ${inventoryStatus}"

            def sql = new Sql(sessionFactory.currentSession.connection())
            sql.execute(sqlQuery)
        }
        else if (moveQty.toInteger() < totalQty.toInteger()) {

            def remainingMoveQty = moveQty

            def inventoryForEdit = Inventory.findAllByCompanyIdAndItemIdAndInventoryStatusAndHandlingUomAndLocationIdAndAssociatedLpn(companyId,itemId,inventoryStatus, HandlingUom.EACH, fromLocation, null)
            if (inventoryForEdit.size() > 0) {
                for(inventory in inventoryForEdit) {
                    if (remainingMoveQty.toInteger() != 0) {
                        if (inventory.quantity.toInteger() > remainingMoveQty.toInteger()) {
                            createEachesInventory(companyId, inventory.handlingUom, inventory.inventoryStatus, inventory.itemId, toLocation, remainingMoveQty, inventory.lotCode, inventory.expirationDate)
                            inventory.quantity = inventory.quantity.toInteger() - remainingMoveQty.toInteger()
                            inventory.save(flush: true, failOnError: true)
                            remainingMoveQty = remainingMoveQty.toInteger() - remainingMoveQty.toInteger()
                        }
                        else if (inventory.quantity.toInteger() == remainingMoveQty.toInteger()) {
                            inventory.locationId = toLocation
                            inventory.save(flush: true, failOnError: true)
                            remainingMoveQty = remainingMoveQty.toInteger() - inventory.quantity.toInteger()
                        }
                        else if (inventory.quantity.toInteger() < remainingMoveQty.toInteger()) {
                            inventory.locationId = toLocation
                            inventory.save(flush: true, failOnError: true)
                            remainingMoveQty = remainingMoveQty.toInteger() - inventory.quantity.toInteger()
                        }
                    }

                }


            }
        }
        //Update Move Inventory History
        moveInventoryService.saveMoveEachHistory(companyId, fromLocation, itemId, inventoryStatus, moveQty.toInteger(), toLocation, username)

        return true
    }

    def createEachesInventory(companyId, handlingUom, inventoryStatus, itemId, locationId, quantity, lotCode, expirationDate){
        def inventoryForEdit = Inventory.findByCompanyIdAndItemIdAndInventoryStatusAndHandlingUomAndLocationIdAndAssociatedLpnAndLotCodeAndExpirationDate(companyId,itemId,inventoryStatus, HandlingUom.EACH, locationId, null, lotCode, expirationDate)

        if (inventoryForEdit) {
            inventoryForEdit.quantity = inventoryForEdit.quantity.toInteger() + quantity.toInteger()
            inventoryForEdit.save(flush: true, failOnError: true)
        }
        else {
            def inventory   = new Inventory()

            inventory.properties = [
                companyId       : companyId,
                handlingUom     : handlingUom,
                inventoryStatus : inventoryStatus,
                itemId          : itemId,
                locationId      : locationId,
                quantity        : quantity,
                lotCode         : lotCode,
                expirationDate  : expirationDate,
                inventoryId     : generateInventoryId(companyId, "INVENTORY")
            ]

            inventory.save(flush: true, failOnError: true)            
        }
    }

    private def generateInventoryId(companyId, entityId) {
        def intIndex    = entityLastRecordService.getLastRecordId(companyId, entityId).lastRecordId
        def stringIndex = intIndex.toString().padLeft(6,"0")

        return companyId + stringIndex      
    }

    def getLocationId(companyId, lpn){
        return InventoryEntityAttribute.findAllByCompanyIdAndLPN(companyId, lpn)
    }

    def getLocationIdForAnyLpn(companyId, lpn){
        def locationId = null

        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
        if(inventoryEntityAttribute.locationId){
            locationId = inventoryEntityAttribute.locationId
        }
        else{
            def secondLevelInventory = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
            locationId = secondLevelInventory.locationId
        }

        return locationId
    }

    def getLpnByLocation(companyId, locationId){
        return InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, locationId)
    }

    def getAllInventoryDataByLocation(companyId, locationId){
        def sqlQuery ="SELECT i.*, iea.*, CASE WHEN iea.level = 'PALLET' THEN iea.lpn ELSE CASE WHEN ieap.level = 'PALLET' THEN ieap.lpn ELSE NULL END END AS pallet_id FROM inventory as i INNER JOIN item as itm ON itm.item_id = i.item_id AND itm.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn AND iea.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn  AND ieap.company_id = '${companyId}' WHERE i.company_id = '${companyId}' AND (i.location_id = '${locationId}' OR iea.location_id = '${locationId}' OR ieap.location_id = '${locationId}')"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getAllInventoryItemByLocation(companyId, locationId){
        def sqlQuery ="SELECT DISTINCT inv.item_id FROM inventory AS inv WHERE inv.company_id = '${companyId}' AND inv.location_id = '${locationId}' AND inv.handling_uom = '${HandlingUom.EACH}' AND inv.associated_lpn IS NULL"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getAllInventoryStatusByItemAndLocation(companyId, itemId, locationId, invStatus){

        def sqlQuery = null
        if (invStatus) {
            sqlQuery ="SELECT sum(inv.quantity) AS total_inventory_qty FROM inventory AS inv WHERE inv.company_id = '${companyId}' AND inv.location_id = '${locationId}' AND inv.handling_uom = '${HandlingUom.EACH}' AND inv.item_id = '${itemId}' AND inv.associated_lpn IS NULL AND inv.inventory_status = ${invStatus}"
        }
        else{
            sqlQuery ="SELECT inv.*, lv.description AS inventory_status, lv.option_value AS inventory_status_opt FROM inventory AS inv LEFT JOIN list_value as lv ON lv.option_value = inv.inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}' WHERE inv.company_id = '${companyId}' AND inv.location_id = '${locationId}' AND inv.handling_uom = '${HandlingUom.EACH}' AND inv.item_id = '${itemId}' AND inv.associated_lpn IS NULL GROUP BY lv.option_group"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getCaseParentId(companyId, caseId){
        def sqlQuery = "SELECT lpn, parent_lpn, location_id, CASE WHEN location_id IS NOT NULL THEN 'Location' ELSE 'Pallet' END AS parentType, CASE WHEN location_id IS NOT NULL THEN location_id ELSE parent_lpn END AS parentId FROM inventory_entity_attribute AS iea WHERE iea.company_id = '${companyId}' AND iea.lpn = '${caseId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getPalletInventory(caseId, palletId, companyId, itemId, inventoryStatus, handlingUOM){

        if(palletId != null && caseId == null){
            def sqlQuery = "SELECT DISTINCT inv.inventory_id, inv.item_id, it.item_description, it.item_category, it.origin_code, it.upc_code, inv.quantity, inv.handling_uom, " +
                    "CASE WHEN inv.expiration_date IS NOT NULL AND inv.expiration_date <  NOW() " +
                    "THEN 'EXPIRED' " +
                    "ELSE lv.description " +
                    "END AS inventoryStatus, " +
                    "CASE  " +
                    "WHEN iea.level = 'CASE' " +
                    "THEN iea.lpn " +
                    "ELSE NULL " +
                    "END AS case_id, " +
                    "CASE  " +
                    "WHEN picked_inventory_notes IS NOT NULL " +
                    "THEN picked_inventory_notes " +
                    "ELSE inote.notes " +
                    "END AS notes " +
                    "FROM inventory AS inv " +
                    "INNER JOIN item AS it ON it.item_id = inv.item_id AND it.company_id  = '${companyId}' " +
                    "INNER JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn AND iea.company_id  = '${companyId}' " +
                    "INNER JOIN list_value AS lv ON inv.inventory_status = lv.option_value AND lv.company_id = '${companyId}' AND lv.option_value = inv.inventory_status AND lv.option_group = 'INVSTATUS' " +
                    "LEFT JOIN inventory_notes AS inote ON inote.lpn = inv.associated_lpn AND inote.company_id = '${companyId}' " +
                    "WHERE inv.company_id = '${companyId}' AND inv.item_id = '${itemId}' AND lv.description = '${inventoryStatus}' AND inv.handling_uom = '${handlingUOM}' AND (iea.lpn = '${palletId}' OR iea.parent_lpn = '${palletId}' ) "

            def sql = new Sql(sessionFactory.currentSession.connection())

            return sql.rows(sqlQuery)
        }
        else{
            return []
        }
    }

    def getInventoryEntityAttributeForSelectedRow(palletId, companyId,inventoryStatus){

        def sqlQuery = "SELECT i.item_id, it.item_description, it.item_category, it.origin_code, it.upc_code, i.quantity, i.handling_uom, " +
                "CASE " +
                "WHEN i.location_id IS NOT NULL " +
                "THEN i.location_id " +
                "ELSE " +
                "CASE " +
                "WHEN iea.location_id IS NOT NULL " +
                "THEN iea.location_id " +
                "ELSE ieap.location_id " +
                "END " +
                "END AS location_id, " +

                "CASE " +
                "WHEN iea.level = 'PALLET' " +
                "THEN iea.lpn " +
                "ELSE " +
                "CASE WHEN ieap.level = 'PALLET' " +
                "THEN ieap.lpn " +
                "ELSE NULL " +
                "END " +
                "END AS pallet_id, " +

                "CASE WHEN expiration_date IS NOT NULL AND expiration_date <  NOW() " +
                "THEN 'EXPIRED' " +
                "ELSE (SELECT distinct lv.description FROM inventory as i2 LEFT JOIN list_value as lv ON i2.inventory_status = lv.option_value WHERE lv.company_id = '${companyId}' AND lv.option_value = i.inventory_status AND lv.option_group = 'INVSTATUS' ) " +
                "END AS inventoryStatus, " +

                "CASE " +
                "WHEN iea.level = 'CASE' " +
                "THEN iea.lpn " +
                "ELSE " +
                "CASE " +
                "WHEN ieap.level = 'CASE' " +
                "THEN ieap.lpn " +
                "ELSE NULL " +
                "END " +
                "END AS case_id, inote.notes " +

                "FROM inventory as i " +
                "INNER JOIN item as it ON i.item_id = it.item_id " +
                "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn " +
                "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn " +
                "LEFT JOIN inventory_notes as inote ON inote.lpn = "+
                "CASE " +
                "WHEN iea.level = 'CASE' " +
                "THEN iea.lpn " +
                "ELSE " +
                "CASE " +
                "WHEN ieap.level = 'CASE' " +
                "THEN ieap.lpn " +
                "ELSE NULL " +
                "END " +
                "END " +
                "AND inote.company_id = '${companyId}' "+


                "WHERE i.company_id = '${companyId}' AND iea.company_id = '${companyId}' AND it.company_id = '${companyId}' AND (iea.lpn = '${palletId}' OR ieap.lpn = '${palletId}')"

        if (inventoryStatus) {
            if (inventoryStatus == 'EXPIRED') {
                sqlQuery = sqlQuery + " AND i.expiration_date IS NOT NULL AND i.expiration_date <  NOW()"
            }
            else{
                sqlQuery = sqlQuery + " AND i.inventory_status = '${inventoryStatus}' AND i.expiration_date IS NULL "
            }
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def search(companyId, itemId, locationId, lpn, lotCode, originCode, inventoryStatus, areaId){

        def sqlQuery = "SELECT i.item_id, " +
                "CASE " +
                "WHEN i.location_id IS NOT NULL " +
                "THEN i.location_id " +
                "ELSE " +
                "    CASE " +
                "    WHEN iea.location_id IS NOT NULL " +
                "    THEN iea.location_id " +
                "    ELSE ieap.location_id " +
                "    END " +
                "END AS  grid_location_id, " +

                "CASE " +
                "WHEN iea.level = 'PALLET' " +
                "THEN iea.lpn " +
                "ELSE " +
                "    CASE " +
                "    WHEN ieap.level = 'PALLET' " +
                "    THEN ieap.lpn " +
                "    ELSE NULL " +
                "    END " +
                "END AS  grid_pallet_id, " +

                "CASE " +
                "WHEN (SELECT item_count FROM " +
                "(  " +
                "    SELECT  i2.item_id, COUNT(DISTINCT i2.item_id) as item_count, " +
                "            CASE " +
                "            WHEN i2.location_id IS NOT NULL " +
                "            THEN i2.location_id  " +
                "            ELSE " +
                "                CASE " +
                "                WHEN iea2.location_id IS NOT NULL " +
                "                THEN iea2.location_id " +
                "                ELSE ieap2.location_id " +
                "                END " +
                "            END AS location_id_2, " +

                "            CASE " +
                "            WHEN iea2.level = 'PALLET' " +
                "            THEN iea2.lpn " +
                "            ELSE " +
                "                CASE " +
                "                WHEN ieap2.level = 'PALLET' " +
                "                THEN ieap2.lpn " +
                "                ELSE NULL " +
                "                END " +
                "            END AS pallet_id_2 " +

                "      FROM inventory as i2 " +
                "      LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn " +
                "      LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn " +
                "      WHERE i2.company_id = '${companyId}' AND iea2.company_id = '${companyId}' AND ieap2.company_id = '${companyId}'  " +
                "      GROUP BY location_id_2, pallet_id_2 " +

                " ) " +

                " AS temp WHERE (location_id_2 =  grid_location_id AND  grid_pallet_id = pallet_id_2))  > 1 " +

                "THEN 'Multiple' " +
                "ELSE i.item_id " +
                "END AS  grid_item_id, " +

                "CASE " +
                "WHEN (SELECT item_count FROM " +

                "(  " +
                "    SELECT  i2.item_id, COUNT(DISTINCT i2.item_id) as item_count, " +
                "            CASE  " +
                "            WHEN i2.location_id IS NOT NULL " +
                "            THEN i2.location_id " +
                "            ELSE " +
                "                CASE " +
                "                WHEN iea2.location_id IS NOT NULL " +
                "                THEN iea2.location_id " +
                "                ELSE ieap2.location_id " +
                "                END " +
                "            END AS location_id_2, " +

                "            CASE   " +
                "            WHEN iea2.level = 'PALLET'   " +
                "            THEN iea2.lpn   " +
                "            ELSE   " +
                "                CASE   " +
                "                WHEN ieap2.level = 'PALLET'   " +
                "                THEN ieap2.lpn   " +
                "                ELSE NULL   " +
                "                END  " +
                "            END AS pallet_id_2  " +

                "      FROM inventory as i2   " +
                "      LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn  " +
                "      LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn  " +
                "      WHERE i2.company_id = '${companyId}' AND iea2.company_id = '${companyId}' AND ieap2.company_id = '${companyId}'  " +
                "      GROUP BY location_id_2, pallet_id_2  " +
                " )  " +

                " AS temp WHERE (location_id_2 =  grid_location_id AND  grid_pallet_id = pallet_id_2) GROUP BY i.item_id )  > 1 " +
                "THEN 'Multiple'  " +
                "ELSE it.item_description  " +
                "END AS  grid_item_description,  " +

                "CASE  " +
                "WHEN (SELECT item_count FROM " +
                "(    " +
                "    SELECT  i2.item_id, COUNT(DISTINCT i2.handling_uom) as item_count,  " +
                "            CASE   " +
                "            WHEN i2.location_id IS NOT NULL  " +
                "            THEN i2.location_id   " +
                "            ELSE   " +
                "                CASE   " +
                "                WHEN iea2.location_id IS NOT NULL   " +
                "                THEN iea2.location_id   " +
                "                ELSE ieap2.location_id   " +
                "                END  " +
                "            END AS location_id_2,  " +

                "            CASE   " +
                "            WHEN iea2.level = 'PALLET'   " +
                "            THEN iea2.lpn  " +
                "            ELSE  " +
                "                CASE  " +
                "                WHEN ieap2.level = 'PALLET'  " +
                "                THEN ieap2.lpn  " +
                "                ELSE NULL  " +
                "                END " +
                "            END AS pallet_id_2 " +
                "     " +
                "     " +
                "      FROM inventory as i2  " +
                "      LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn " +
                "      LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn " +
                "      WHERE i2.company_id = '${companyId}' AND iea2.company_id = '${companyId}' AND ieap2.company_id = '${companyId}'  " +
                "      GROUP BY location_id_2, pallet_id_2 " +
                "  " +
                " )  " +
                "   " +
                " AS temp WHERE (location_id_2 =  grid_location_id AND  grid_pallet_id = pallet_id_2))  > 1  " +
                "     " +
                "THEN NULL  " +
                "ELSE i.handling_uom  " +
                "END AS  grid_handling_uom,  " +
                "  " +
                "CASE  " +
                "WHEN (ieap.level = 'PALLET' && ieap.lpn IS NOT NULL)  " +
                "THEN NULL  " +
                "ELSE  " +
                "    CASE  " +
                "    WHEN iea.level = 'CASE'   " +
                "    THEN iea.lpn   " +
                "    ELSE   " +
                "        CASE   " +
                "        WHEN ieap.level = 'CASE'   " +
                "        THEN ieap.lpn   " +
                "        ELSE NULL   " +
                "        END   " +
                "    END   " +
                "END  " +
                "AS grid_case_id,  " +
                " " +
                "CASE  " +
                "WHEN (SELECT item_count FROM  " +
                "  " +
                "(    " +
                "    SELECT  i2.item_id, COUNT(DISTINCT i2.item_id) as item_count,  " +
                "            CASE   " +
                "            WHEN i2.location_id IS NOT NULL  " +
                "            THEN i2.location_id   " +
                "            ELSE   " +
                "                CASE   " +
                "                WHEN iea2.location_id IS NOT NULL   " +
                "                THEN iea2.location_id   " +
                "                ELSE ieap2.location_id   " +
                "                END  " +
                "            END AS location_id_2,  " +

                "            CASE   " +
                "            WHEN iea2.level = 'PALLET'   " +
                "            THEN iea2.lpn   " +
                "            ELSE   " +
                "                CASE   " +
                "                WHEN ieap2.level = 'PALLET'   " +
                "                THEN ieap2.lpn   " +
                "                ELSE NULL   " +
                "                END  " +
                "            END AS pallet_id_2  " +

                "      FROM inventory as i2   " +
                "      LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn  " +
                "      LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn  " +
                "      WHERE i2.company_id = '${companyId}' AND iea2.company_id = '${companyId}' AND ieap2.company_id = '${companyId}'  " +
                "     GROUP BY location_id_2, pallet_id_2  " +
                " ) " +

                " AS temp WHERE (location_id_2 =  grid_location_id AND pallet_id_2 = grid_pallet_id) GROUP BY i.item_id )  > 1 " +

                "THEN NULL  " +
                "ELSE (   " +
                " SELECT SUM(i2.quantity) as total_quantity  " +
                " FROM inventory as i2   " +
                " LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn  " +
                " LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn  " +
                " WHERE i2.company_id = '${companyId}' AND ((i2.location_id IS NOT NULL AND i2.location_id = grid_location_id) OR (iea2.location_id IS NOT NULL AND iea2.location_id = grid_location_id AND (grid_pallet_id IS NOT NULL OR grid_case_id IS NOT NULL)) OR (ieap2.location_id IS NOT NULL AND ieap2.location_id = grid_location_id))  " +
                " AND   " +
                " (grid_pallet_id IS NULL OR ((iea2.level = 'PALLET' AND iea2.lpn = grid_pallet_id) OR (ieap2.level = 'PALLET' AND ieap2.lpn = grid_pallet_id)))  " +
                " AND   " +
                " (grid_case_id IS NULL OR ((iea2.level = 'CASE' AND iea2.lpn = grid_case_id) OR (ieap2.level = 'CASE' AND ieap2.lpn = grid_case_id)))  " +
                " AND (i2.handling_uom = grid_handling_uom)  " +
                " AND (i2.item_id = grid_item_id)  " +
                " )  " +
                "END AS grid_quantity,  " +

                "CASE  " +
                "WHEN (ieap.level = 'PALLET' && ieap.lpn IS NOT NULL)  " +
                "THEN NULL  " +
                "ELSE  " +
                "    CASE  " +
                "    WHEN iea.level = 'CASE'   " +
                "    THEN iea.lpn   " +
                "    ELSE   " +
                "        CASE   " +
                "        WHEN ieap.level = 'CASE'   " +
                "        THEN ieap.lpn   " +
                "        ELSE NULL   " +
                "        END   " +
                "    END   " +
                "END  " +
                "AS grid_case_id, loc.area_id,  " +
                "CASE "+
                "WHEN i.picked_inventory_notes IS NOT NULL "+
                "THEN i.picked_inventory_notes "+
                "ELSE inote.notes "+
                "END as notes "+
                "  " +
                "FROM inventory as i   " +
                "INNER JOIN item as it ON i.item_id = it.item_id   " +
                "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn   " +
                "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn   " +

                "LEFT JOIN location as loc ON loc.location_id = "+
                "(CASE "+
                "WHEN i.location_id IS NOT NULL "+
                "THEN i.location_id "+
                "ELSE "+
                    "CASE "+
                    "WHEN iea.location_id IS NOT NULL "+
                    "THEN iea.location_id "+
                    "ELSE ieap.location_id "+
                    "END "+
                "END) "+

                "LEFT JOIN inventory_notes as inote ON inote.lpn = "+
                "CASE  " +
                "WHEN (ieap.level = 'PALLET' && ieap.lpn IS NOT NULL)  " +
                "THEN NULL  " +
                "ELSE  " +
                "    CASE  " +
                "    WHEN iea.level = 'CASE'   " +
                "    THEN iea.lpn   " +
                "    ELSE   " +
                "        CASE   " +
                "        WHEN ieap.level = 'CASE'   " +
                "        THEN ieap.lpn   " +
                "        ELSE NULL   " +
                "        END   " +
                "    END   " +
                "END  " +
                "AND inote.company_id = '${companyId}' "+


                "WHERE i.company_id = '${companyId}' "

        sqlQuery = sqlQuery + " AND (((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${companyId}' AND loc.location_id = i.location_id) > 0) OR ((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${companyId}' AND loc.location_id = iea.location_id) > 0) OR ((SELECT COUNT(location_id) FROM location AS loc WHERE loc.company_id = '${companyId}' AND loc.location_id = ieap.location_id) > 0)) "

        if(itemId){
            def findItem = '%'+itemId+'%'
            sqlQuery = sqlQuery + " AND (i.item_id LIKE '${findItem}' OR it.item_description LIKE '${findItem}')"
        }

        if (locationId){
            sqlQuery = sqlQuery + " AND (i.location_id = '${locationId}' OR iea.location_id = '${locationId}' OR ieap.location_id = '${locationId}')"
        }

        if (lpn){
            def findLpn = '%'+lpn+'%'
            sqlQuery = sqlQuery + " AND (i.associated_lpn LIKE '${findLpn}' OR iea.lpn LIKE '${findLpn}' OR iea.parent_lpn LIKE '${findLpn}')"
        }

        if(lotCode){
            def findLotCode = '%'+lotCode+'%'
            sqlQuery = sqlQuery + " AND i.lot_code LIKE '${findLotCode}'"
        }

        if(originCode){
            sqlQuery = sqlQuery + " AND it.origin_code = '${originCode}'"
        }

        if (inventoryStatus) {
            if (inventoryStatus == 'EXPIRED') {
                sqlQuery = sqlQuery + " AND i.expiration_date <= NOW()"
            }
            else{
                sqlQuery = sqlQuery + " AND i.inventory_status = '${inventoryStatus}' AND (i.expiration_date >= NOW() OR i.expiration_date IS NULL)"
            }
        }

        if (areaId) {
            sqlQuery = sqlQuery + " AND loc.area_id = '${areaId}'"
        }

        sqlQuery = sqlQuery + " GROUP By grid_location_id,  grid_pallet_id, grid_case_id, grid_item_id, grid_handling_uom "

        log.info("sqlQuery  : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def inventorySearch(companyId, itemId, locationId, lpn, lotCode, inventoryNote, originCode, inventoryStatus, areaId, itemCategory){
        def sqlQuery = "SELECT inv.inventory_id, loc.area_id AS grid_area_id, " +
                "GetInventoryLocation('${companyId}', inv.inventory_id) AS grid_location_id, " +
                "GetInventoryPalletId('${companyId}', inv.inventory_id) AS grid_pallet_id, " +
                "GetInventoryCaseId('${companyId}', inv.inventory_id)  AS grid_case_id, " +
                "GetInventoryItem('${companyId}', inv.inventory_id) As grid_item_id, " +
                "GetInventoryStatus('${companyId}', inv.inventory_id) As grid_inventory_status, " +
                "GetInventoryItemDescription('${companyId}', inv.inventory_id) As grid_item_description, " +
                "GetInventoryUom('${companyId}', inv.inventory_id) As grid_handling_uom,  " +
                "GetInventoryQuantity('${companyId}', inv.inventory_id) As grid_quantity, " +
                "GetInventoryNotes('${companyId}', inv.inventory_id) As grid_notes " +
                "FROM inventory AS inv " +
                "INNER JOIN item as it ON inv.item_id = it.item_id " +
                "LEFT JOIN inventory_entity_attribute as iea ON inv.associated_lpn = iea.lpn and iea.company_id='${companyId}'   " +
                "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn and ieap.company_id='${companyId}'  " +
                "LEFT JOIN location as loc ON loc.location_id = "+
                "(CASE "+
                "WHEN inv.location_id IS NOT NULL "+
                "THEN inv.location_id "+
                "ELSE "+
                "CASE "+
                "WHEN iea.location_id IS NOT NULL "+
                "THEN iea.location_id "+
                "ELSE ieap.location_id "+
                "END "+
                "END) "+
                "WHERE  loc.company_id='${companyId}' and it.company_id='${companyId}' and inv.company_id='${companyId}' and GetInventoryLocation('${companyId}', inv.inventory_id) is not null "

        if(itemId){
            def findItem = '%'+itemId+'%'
            sqlQuery = sqlQuery + " AND (it.item_id LIKE '${findItem}' OR it.item_description LIKE '${findItem}' OR it.upc_code LIKE '${findItem}') "
        }

        if (locationId){
            sqlQuery = sqlQuery + " AND GetInventoryLocation('${companyId}', inv.inventory_id) = '${locationId}' "
        }

        if (lpn){
            def findLpn = '%'+lpn+'%'
            sqlQuery = sqlQuery + " AND (GetInventoryPalletId('${companyId}', inv.inventory_id) LIKE '${findLpn}' OR GetInventoryCaseId('${companyId}', inv.inventory_id) LIKE '${findLpn}' )"
        }

        if(lotCode){
            String findLotCode = '%'+lotCode+'%'
            sqlQuery = sqlQuery + " AND inv.lot_code LIKE '${findLotCode}'"
        }

        if(inventoryNote){
            String findInventoryNote = '%'+inventoryNote+'%'
            sqlQuery = sqlQuery + " AND GetInventoryNotes('${companyId}', inv.inventory_id) LIKE '${findInventoryNote}'"
        }

        if(originCode){
            sqlQuery = sqlQuery + " AND it.origin_code = '${originCode}'"
        }

        if (inventoryStatus) {
            sqlQuery = sqlQuery + " AND inv.inventory_status = '${inventoryStatus}' "
        }

        if (areaId) {
            String findareaId = '%' + areaId + '%'
            sqlQuery = sqlQuery + " AND loc.area_id LIKE '${findareaId}'"
        }

        if (itemCategory) {
            sqlQuery = sqlQuery + " AND it.item_category = '${itemCategory}'"
        }

        sqlQuery = sqlQuery + "GROUP By grid_location_id, grid_pallet_id, grid_case_id, grid_item_id, grid_handling_uom, grid_inventory_status "
        sqlQuery = sqlQuery + "ORDER BY grid_location_id, grid_pallet_id LIMIT 10000 "


        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def checkPalletIdAndCaseExist(companyId, lpn, level){
        return InventoryEntityAttribute.findAllByCompanyIdAndLPNAndLevel(companyId,lpn, level)
    }

    def saveInventoryForReceive(companyId, lastModifiedUserId, palletId, caseId, uom, inventoryStatus, itemId, quantity, lotCode, expirationDate){

        def inventoryAssociatedLpn = caseId

        if(palletId && caseId){
            def checkPalletExists = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, palletId)

            if(!checkPalletExists){
                def inventoryEntityAttributeForPallet = new InventoryEntityAttribute()
                inventoryEntityAttributeForPallet.properties = [companyId : companyId,
                                                                lastModifiedUserId : lastModifiedUserId,
                                                                lPN : palletId,
                                                                locationId : "TEMPLOCATION",
                                                                level : 'PALLET',
                                                                parentLpn : null,
                                                                createdDate : new Date(),
                                                                lastModifiedDate : new Date()
                ]
                inventoryEntityAttributeForPallet.save(flush: true, failOnError: true)
            }


            def inventoryEntityAttributeForCase = new InventoryEntityAttribute()
            inventoryEntityAttributeForCase.properties = [companyId : companyId,
                                                          lastModifiedUserId : lastModifiedUserId,
                                                          lPN : caseId,
                                                          locationId : null,
                                                          level : 'CASE',
                                                          parentLpn : palletId,
                                                          createdDate : new Date(),
                                                          lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForCase.save(flush: true, failOnError: true)

        }
        else if(palletId && !caseId){

            inventoryAssociatedLpn = palletId

            def inventoryEntityAttributeForPallet = new InventoryEntityAttribute()
            inventoryEntityAttributeForPallet.properties = [companyId : companyId,
                                                            lastModifiedUserId : lastModifiedUserId,
                                                            lPN : palletId,
                                                            locationId : "TEMPLOCATION",
                                                            level : 'PALLET',
                                                            parentLpn : null,
                                                            createdDate : new Date(),
                                                            lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForPallet.save(flush: true, failOnError: true)

        }
        else if(!palletId && caseId){

            def inventoryEntityAttributeForCase = new InventoryEntityAttribute()
            inventoryEntityAttributeForCase.properties = [companyId : companyId,
                                                          lastModifiedUserId : lastModifiedUserId,
                                                          lPN : caseId,
                                                          locationId : "TEMPLOCATION",
                                                          level : 'CASE',
                                                          parentLpn : null,
                                                          createdDate : new Date(),
                                                          lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForCase.save(flush: true, failOnError: true)

        }


        Inventory inventoryForReceiving = new Inventory()

        //def inventoryIdExist = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
        //if (!inventoryIdExist) {
           // inventoryForReceiving.inventoryId = companyId + 0000001.toString().padLeft(6,"0")
        //}
        //else{
            //def inventoryIdInteger = inventoryIdExist.inventoryId - companyId
            //def intIndex = inventoryIdInteger.toInteger()
            //intIndex = intIndex + 1
            def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
            def stringIndex = intIndex.toString().padLeft(6,"0")
            inventoryForReceiving.inventoryId = companyId + stringIndex
        //}

        inventoryForReceiving.properties = [companyId:companyId,
                                            associatedLpn:inventoryAssociatedLpn,
                                            handlingUom:uom,
                                            inventoryStatus:inventoryStatus,
                                            itemId:itemId,
                                            locationId:null,
                                            quantity:quantity,
                                            lotCode:lotCode
        ]

        if (expirationDate == null) {
            inventoryForReceiving.expirationDate = null
        }
        else{
            def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", expirationDate)
            inventoryForReceiving.expirationDate = convertedExpirationDate
        }
        inventoryForReceiving.save(flush: true, failOnError: true)

//        Update Inventory Summary
//        inventorySummaryService.updateIncreasedInventory(companyId, itemId, inventoryStatus, quantity, uom)

    }


    def saveInventoryForKitting(companyId, lastModifiedUserId, palletId, caseId, uom, inventoryStatus, itemId, quantity, lotCode, expirationDate){

        def inventoryAssociatedLpn = caseId

        if(palletId && caseId){
            def checkPalletExists = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, palletId)

            if(!checkPalletExists){
                def inventoryEntityAttributeForPallet = new InventoryEntityAttribute()
                inventoryEntityAttributeForPallet.properties = [companyId : companyId,
                                                                lastModifiedUserId : lastModifiedUserId,
                                                                lPN : palletId,
                                                                locationId : "KITTINGTEMPLOCATION",
                                                                level : 'PALLET',
                                                                parentLpn : null,
                                                                createdDate : new Date(),
                                                                lastModifiedDate : new Date()
                ]
                inventoryEntityAttributeForPallet.save(flush: true, failOnError: true)
            }


            def inventoryEntityAttributeForCase = new InventoryEntityAttribute()
            inventoryEntityAttributeForCase.properties = [companyId : companyId,
                                                          lastModifiedUserId : lastModifiedUserId,
                                                          lPN : caseId,
                                                          locationId : null,
                                                          level : 'CASE',
                                                          parentLpn : palletId,
                                                          createdDate : new Date(),
                                                          lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForCase.save(flush: true, failOnError: true)

        }
        else if(palletId && !caseId){

            inventoryAssociatedLpn = palletId

            def inventoryEntityAttributeForPallet = new InventoryEntityAttribute()
            inventoryEntityAttributeForPallet.properties = [companyId : companyId,
                                                            lastModifiedUserId : lastModifiedUserId,
                                                            lPN : palletId,
                                                            locationId : "KITTINGTEMPLOCATION",
                                                            level : 'PALLET',
                                                            parentLpn : null,
                                                            createdDate : new Date(),
                                                            lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForPallet.save(flush: true, failOnError: true)

        }
        else if(!palletId && caseId){

            def inventoryEntityAttributeForCase = new InventoryEntityAttribute()
            inventoryEntityAttributeForCase.properties = [companyId : companyId,
                                                          lastModifiedUserId : lastModifiedUserId,
                                                          lPN : caseId,
                                                          locationId : "KITTINGTEMPLOCATION",
                                                          level : 'CASE',
                                                          parentLpn : null,
                                                          createdDate : new Date(),
                                                          lastModifiedDate : new Date()
            ]
            inventoryEntityAttributeForCase.save(flush: true, failOnError: true)

        }


        def inventoryForKitting = new Inventory()

        //def inventoryIdExist = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
        //if (!inventoryIdExist) {
            //inventoryForKitting.inventoryId = companyId + 0000001.toString().padLeft(6,"0")
        //}
        //else{
            //def inventoryIdInteger = inventoryIdExist.inventoryId - companyId
            //def intIndex = inventoryIdInteger.toInteger()
           // intIndex = intIndex + 1
            def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
            def stringIndex = intIndex.toString().padLeft(6,"0")
            inventoryForKitting.inventoryId = companyId + stringIndex
        //}

        inventoryForKitting.properties = [companyId:companyId,
                                            associatedLpn:inventoryAssociatedLpn,
                                            handlingUom:uom,
                                            inventoryStatus:inventoryStatus,
                                            itemId:itemId,
                                            locationId:null,
                                            quantity:quantity,
                                            lotCode:lotCode
        ]

        if (expirationDate == null) {
            inventoryForKitting.expirationDate = null
        }
        else{
            inventoryForKitting.expirationDate = expirationDate
        }
        inventoryForKitting.save(flush: true, failOnError: true)

//        Update Inventory Summary
//        inventorySummaryService.updateIncreasedInventory(companyId, itemId, inventoryStatus, quantity, uom)

    }


    def getInventoryStatusReport(companyId){
        def sqlQuery = "SELECT inventory.inventory_status, list_value.description, COUNT(DISTINCT inventory.item_id) AS total_inventories  "
        sqlQuery += "FROM inventory "
        sqlQuery += "INNER JOIN list_value ON inventory.inventory_status = list_value.option_value "
        sqlQuery += "WHERE inventory.company_id = '${companyId}' AND list_value.company_id = '${companyId}' AND list_value.option_group = 'INVSTATUS' "
        sqlQuery += "GROUP BY inventory.inventory_status"
        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getInventoryStatus(inventory){
//        def inventory = Inventory.findByCompanyIdAndInventoryId(companyId, inventoryId)
        def status = inventory.inventoryStatus

        if(inventory && inventory.expirationDate && inventory.expirationDate < new Date()){
            status = "EXPIRED"
        }

        return status
    }

    def validatePalletIdForMovePallet(companyId, palletId) {
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevelAndLocationIdNotEqual(companyId, palletId, "PALLET", "TEMPLOCATION")
        if(inventoryEntityAttribute){
            return [palletId: palletId, allowToMove: true]
        } else {
            return [palletId: palletId, allowToMove: false]
        }
    }

    def validateCaseIdForMoveCase(companyId, caseId) {
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevelAndLocationIdNotEqual(companyId, caseId, "CASE", "TEMPLOCATION")
        if(inventoryEntityAttribute){
            return [caseId: caseId, allowToMove: true]
        } else {
            return [caseId: caseId, allowToMove: false]
        }
    }

    def inventoryMoveDataFromTo(companyId, fromDate, toDate){
        def convertedFromDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate)
        def convertedToDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toDate)

        def fromDateFormat = convertedFromDate.format( 'yyyy-MM-dd' )
        convertedToDate.set(hourOfDay: 23, minute: 59, second: 0)
        def toDateFormat = convertedToDate.format( 'yyyy-MM-dd HH:mm:ss' )

        println  fromDateFormat
        println toDateFormat

        def sqlQuery ="SELECT mi.*, lv.description as inventory_status_desc FROM move_inventory as mi LEFT JOIN list_value AS lv ON mi.inventory_status = lv.option_value AND lv.company_id = '${companyId}' AND lv.option_group = 'INVSTATUS'  WHERE mi.company_id = '${companyId}' and mi.created_date >= '${fromDateFormat}' AND mi.created_date < '${toDateFormat}'"

        log.info("sql : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def checkInventoryUnavailable(companyId, itemId, inventoryStatus){
        def errorMessage = null
        def inventory = Inventory.findAllByCompanyIdAndItemIdAndInventoryStatus(companyId, itemId,inventoryStatus)
        if (!inventory)
            errorMessage = "There is no inventory in the store to match order line requirement."

        return errorMessage

    }



    def getPalletLevelInventory(companyId, itemId, inventoryStatus){

        def inventoryMaps =[]

        def inventories =  null
        def item = Item.findByCompanyIdAndItemId(companyId, itemId)

        String expiredCondition = " inv.inventory_status = '${inventoryStatus}' AND (inv.expiration_date is null or inv.expiration_date >= NOW()) "
        String caseTrackedJoin = " INNER JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.level = 'PALLET'  AND iea.company_id = '${companyId}' "
        String selectLocation = " iea.location_id "
        String associatedLpnLevel = "PALLET"
        String locationCondition = " (iea.location_id  != 'TEMPLOCATION' AND iea.location_id  != 'KITTINGTEMPLOCATION') "

        if(inventoryStatus == 'EXPIRED'){
            expiredCondition = " inv.expiration_date is not null and inv.expiration_date < '${new Date()}' "

        }

        if(item.isCaseTracked == true){
            caseTrackedJoin = " INNER JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.company_id = '${companyId}' INNER JOIN inventory_entity_attribute AS iea2 ON iea2.lpn = iea.parent_lpn AND iea2.level = 'PALLET' AND iea2.company_id = '${companyId}' "
            selectLocation = " iea2.location_id "
            associatedLpnLevel = "CASE"
            locationCondition = " (iea2.location_id  != 'TEMPLOCATION' AND iea2.location_id  != 'KITTINGTEMPLOCATION') "

        }

        String sqlQuery = "SELECT DISTINCT inv.*, " + selectLocation + " AS location_id, iea.parent_lpn AS parent_lpn FROM inventory AS inv " + caseTrackedJoin + " WHERE inv.company_id = '${companyId}' AND inv.item_id = '${itemId}' AND " + expiredCondition + " AND " + locationCondition + " AND  inv.work_reference_number is NULL "
        def sql = new Sql(sessionFactory.currentSession.connection())
        inventories  =  sql.rows(sqlQuery)



        if(inventories){
            for(inventory in inventories){

                Integer palletFill = 1

                if(inventory.handling_uom == "CASE")
                    palletFill = item.casesPerPallet/2
                else if(inventory.handling_uom == "EACH")
                    palletFill = (item.casesPerPallet * item.eachesPerCase)/2


                if(palletFill <= inventory.quantity){

                    def inventoryLocation = Location.findByCompanyIdAndLocationId(companyId, inventory.location_id)
                    def inventoryArea = null

                    if(inventoryLocation)
                        inventoryArea = Area.findByCompanyIdAndAreaId(companyId, inventoryLocation.areaId)

                    if(inventoryArea && !inventoryArea.isStaging && inventoryLocation){

                        def map = [companyId: inventory.company_id,
                                   inventoryId: inventory.inventory_id,
                                   itemId: inventory.item_id,
                                   associatedLpn: inventory.associated_lpn,
                                   locationId: inventory.location_id,
                                   quantity: inventory.quantity,
                                   handlingUom: inventory.handling_uom,
                                   lotCode: inventory.lot_code,
                                   expirationDate: inventory.expiration_date,
                                   inventoryStatus: inventory.inventory_status,
                                   associatedLpnLevel: associatedLpnLevel,
                                   parentLpn: inventory.parent_lpn,
                                   locationTravelSeq: inventoryLocation.travelSequence,
                                   areaId: inventoryArea.areaId,
                                   areaAllocationOrder: inventoryArea.allocationOrder,
                                   expirationDate: inventory.expiration_date]

                        inventoryMaps.add(map)
                    }

                }

            }
        }

        inventoryMaps = inventoryMaps.sort{-it.quantity}
        inventoryMaps = inventoryMaps.sort{it.handlingUom}
        inventoryMaps = inventoryMaps.sort{it.locationId}
        inventoryMaps = inventoryMaps.sort{it.locationTravelSeq}
        inventoryMaps = inventoryMaps.sort{it.expirationDate}
        inventoryMaps = inventoryMaps.sort{it.areaId}
        inventoryMaps = inventoryMaps.sort{it.areaAllocationOrder}

        return inventoryMaps

    }


    def getCaseLevelInventories(companyId, itemId, inventoryStatus){


        def inventoryMap =[]

        def caseInventoryDatas =  null
        def item = Item.findByCompanyIdAndItemId(companyId, itemId)

        String expiredCondition = " inv.inventory_status = '${inventoryStatus}' AND (inv.expiration_date is null or inv.expiration_date >= NOW()) "
        String caseTrackedJoin = " LEFT JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.level = 'PALLET'  AND iea.company_id = '${companyId}' "
        String selectLocation = " CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id  ELSE inv.location_id END  "
        String locationCondition = " ((iea.location_id IS NULL OR iea.location_id  != 'TEMPLOCATION') AND (iea.location_id IS NULL OR iea.location_id  != 'KITTINGTEMPLOCATION')) "

        if(inventoryStatus == 'EXPIRED'){
            expiredCondition = " inv.expiration_date is not null and inv.expiration_date < '${new Date()}' "
        }

        if(item.isCaseTracked == true){
            caseTrackedJoin = " LEFT JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute AS iea2 ON iea2.lpn = iea.parent_lpn AND iea2.level = 'PALLET' AND iea2.company_id = '${companyId}' "
            selectLocation = " CASE WHEN iea2.location_id IS NOT NULL THEN iea2.location_id  ELSE iea.location_id END  "
            locationCondition = " (iea.location_id  != 'TEMPLOCATION' AND iea.location_id  != 'KITTINGTEMPLOCATION' AND (iea2.location_id IS NULL OR iea2.location_id  != 'TEMPLOCATION') AND (iea2.location_id IS NULL OR iea2.location_id  != 'KITTINGTEMPLOCATION')) "

        }

        String sqlQuery = "SELECT DISTINCT inv.*, " + selectLocation + " AS location_id, iea.parent_lpn AS parent_lpn, iea.level AS associated_lpn_level FROM inventory AS inv " + caseTrackedJoin + " WHERE inv.company_id = '${companyId}' AND inv.handling_uom = '${HandlingUom.CASE}' AND inv.item_id = '${itemId}' AND " + expiredCondition + " AND " + locationCondition + " AND  inv.work_reference_number is NULL "
        def sql = new Sql(sessionFactory.currentSession.connection())

        caseInventoryDatas  =  sql.rows(sqlQuery)

        if(caseInventoryDatas){
            for(caseInventory in caseInventoryDatas){

                def sameLocationInventory = inventoryMap.find { it.locationId == caseInventory.location_id }
                if(sameLocationInventory){
                    sameLocationInventory.quantity = sameLocationInventory.quantity + caseInventory.quantity
                }
                else{

                    def inventoryLocation = Location.findByCompanyIdAndLocationId(companyId, caseInventory.location_id)
                    def inventoryArea = null

                    if(inventoryLocation)
                        inventoryArea= Area.findByCompanyIdAndAreaId(companyId, inventoryLocation.areaId)

                    if(inventoryArea && !inventoryArea.isStaging && inventoryLocation){
                        def map = [companyId: companyId,
                                   inventoryId: caseInventory.inventory_id,
                                   itemId: item.itemId,
                                   associatedLpn: caseInventory.associated_lpn,
                                   locationId: caseInventory.location_id,
                                   quantity: caseInventory.quantity,
                                   handlingUom: caseInventory.handling_uom,
                                   lotCode: caseInventory.lot_code,
                                   expirationDate: caseInventory.expiration_date,
                                   inventoryStatus: caseInventory.inventory_status,
                                   associatedLpnLevel: caseInventory.associated_lpn_level,
                                   parentLpn: caseInventory.parent_lpn,
                                   locatonTravelSeq: inventoryLocation.travelSequence,
                                   areaId: inventoryArea.areaId,
                                   areaAllocationOrder: inventoryArea.allocationOrder]
                        inventoryMap.add(map)

                    }

                }
            }
        }


        def sqlPwQuery = "SELECT * FROM pick_work AS pw INNER JOIN order_line AS ol ON ol.order_line_number = pw.order_line_number WHERE pw.company_id = '${companyId}' AND pw.pick_quantity_uom = '${HandlingUom.CASE}' AND pick_status = '${PickWorkStatus.READY_TO_PICK}' AND ol.item_id = '${itemId}'  AND ol.requested_inventory_status = '${inventoryStatus}'  "

        def sqlPw = new Sql(sessionFactory.currentSession.connection())
        def activePickWorkRows = sqlPw.rows(sqlPwQuery)

        for(activePickWork in activePickWorkRows){
            def sameLocationInventory = inventoryMap.find {it.locationId == activePickWork.source_location_id}
            if(sameLocationInventory){
                sameLocationInventory.quantity = sameLocationInventory.quantity - activePickWork.pick_quantity
            }
        }

        inventoryMap = inventoryMap.sort{-it.quantity}
        inventoryMap = inventoryMap.sort{it.handlingUom}
        inventoryMap = inventoryMap.sort{it.locationId}
        inventoryMap = inventoryMap.sort{it.locationTravelSeq}
        inventoryMap = inventoryMap.sort{it.areaId}
        inventoryMap = inventoryMap.sort{it.areaAllocationOrder}


        return inventoryMap

    }


    def getEachLevelInventories(companyId, itemId, inventoryStatus){

        def inventoryMap = []

        def eachInventoryDatas =  null
        def item = Item.findByCompanyIdAndItemId(companyId, itemId)

        String expiredCondition = " inv.inventory_status = '${inventoryStatus}' AND (inv.expiration_date is null or inv.expiration_date >= NOW()) "
        String caseTrackedJoin = " LEFT JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.level = 'PALLET'  AND iea.company_id = '${companyId}' "
        String selectLocation = " CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id  ELSE inv.location_id END  "
        String locationCondition = " ((iea.location_id IS NULL OR iea.location_id  != 'TEMPLOCATION') AND (iea.location_id IS NULL OR iea.location_id  != 'KITTINGTEMPLOCATION')) "

        if(inventoryStatus == 'EXPIRED'){
            expiredCondition = " inv.expiration_date is not null and inv.expiration_date < '${new Date()}' "
        }

        if(item.isCaseTracked == true){
            caseTrackedJoin = " LEFT JOIN inventory_entity_attribute AS iea ON iea.lpn = inv.associated_lpn  AND iea.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute AS iea2 ON iea2.lpn = iea.parent_lpn AND iea2.level = 'PALLET' AND iea2.company_id = '${companyId}' "
            selectLocation = " CASE WHEN iea2.location_id IS NOT NULL THEN iea2.location_id  ELSE iea.location_id END  "
            locationCondition = " (iea.location_id  != 'TEMPLOCATION' AND iea.location_id  != 'KITTINGTEMPLOCATION' AND (iea2.location_id IS NULL OR iea2.location_id  != 'TEMPLOCATION') AND (iea2.location_id IS NULL OR iea2.location_id  != 'KITTINGTEMPLOCATION')) "

        }

        String sqlQuery = "SELECT DISTINCT inv.*, " + selectLocation + " AS location_id, iea.parent_lpn AS parent_lpn, iea.level AS associated_lpn_level FROM inventory AS inv " + caseTrackedJoin + " WHERE inv.company_id = '${companyId}' AND inv.handling_uom = '${HandlingUom.EACH}' AND inv.item_id = '${itemId}' AND " + expiredCondition + " AND " + locationCondition + " AND  inv.work_reference_number is NULL "
        def sql = new Sql(sessionFactory.currentSession.connection())

        eachInventoryDatas  =  sql.rows(sqlQuery)

        if(eachInventoryDatas){
            for(eachInventory in eachInventoryDatas){

                def sameLocationInventory = inventoryMap.find { it.locationId == eachInventory.location_id }
                if(sameLocationInventory){
                    sameLocationInventory.quantity = sameLocationInventory.quantity + eachInventory.quantity
                }
                else{

                    def inventoryLocation = Location.findByCompanyIdAndLocationId(companyId, eachInventory.location_id)
                    def inventoryArea = null

                    if(inventoryLocation)
                        inventoryArea = Area.findByCompanyIdAndAreaId(companyId, inventoryLocation.areaId)

                    if(inventoryArea && !inventoryArea.isStaging && inventoryLocation){
                        def map = [companyId: companyId,
                                   inventoryId: eachInventory.inventory_id,
                                   itemId: itemId,
                                   associatedLpn: eachInventory.associated_lpn,
                                   locationId: eachInventory.location_id,
                                   quantity: eachInventory.quantity,
                                   handlingUom: eachInventory.handling_uom,
                                   lotCode: eachInventory.lot_code,
                                   expirationDate: eachInventory.expiration_date,
                                   inventoryStatus: eachInventory.inventory_status,
                                   associatedLpnLevel: eachInventory.associated_lpn_level,
                                   parentLpn: eachInventory.parent_lpn,
                                   locatonTravelSeq: inventoryLocation.travelSequence,
                                   areaId: inventoryArea.areaId,
                                   areaAllocationOrder: inventoryArea.allocationOrder]
                        inventoryMap.add(map)
                    }
                }
            }
        }


        def sqlPwQuery = "SELECT * FROM pick_work AS pw INNER JOIN order_line AS ol ON ol.order_line_number = pw.order_line_number WHERE pw.company_id = '${companyId}' AND pw.pick_quantity_uom = '${HandlingUom.EACH}' AND pick_status = '${PickWorkStatus.READY_TO_PICK}' AND ol.item_id = '${itemId}'  AND ol.requested_inventory_status = '${inventoryStatus}'  "

        def sqlPw = new Sql(sessionFactory.currentSession.connection())
        def activePickWorkRows = sqlPw.rows(sqlPwQuery)

        for(activePickWork in activePickWorkRows){
            def sameLocationInventory = inventoryMap.find {it.locationId == activePickWork.source_location_id}
            if(sameLocationInventory){
                sameLocationInventory.quantity = sameLocationInventory.quantity - activePickWork.pick_quantity
            }
        }

        inventoryMap = inventoryMap.sort{-it.quantity}
        inventoryMap = inventoryMap.sort{it.handlingUom}
        inventoryMap = inventoryMap.sort{it.locationId}
        inventoryMap = inventoryMap.sort{it.locationTravelSeq}
        inventoryMap = inventoryMap.sort{it.areaId}
        inventoryMap = inventoryMap.sort{it.areaAllocationOrder}

        return inventoryMap

    }
    

}

