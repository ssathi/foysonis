package com.foysonis.area

import com.foysonis.item.EntityAttribute
import com.foysonis.item.EntityAttributeService
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.inventory.Inventory
import com.foysonis.item.Item

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class AreaService {
    def entityAttributeService
    def sessionFactory

    def getAllAreas(companyId){
        return Area.findAllByCompanyId(companyId)
    }

    def checkAreaIdExist(companyId, areaId){
        return Area.findAllByCompanyIdAndAreaId(companyId, areaId)
    }

    def saveArea(area, jsonObject){
        area.createdDate = new Date()

        //Create Max Load
        if(area.isStorage && jsonObject.maximumLoad){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "MAXLOAD", jsonObject.maximumLoad, null)
        }

        //Create Storage Restriction
        if(area.isStorage && jsonObject.selectedStorageRestrictionOptions){
            jsonObject.selectedStorageRestrictionOptions.eachWithIndex { option, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "STRG", option.optionValue, index+1)
            }
        }

        //Create Picking Level
        if(area.isPickable && jsonObject.selectedReplenishmentAreas){
            jsonObject.selectedReplenishmentAreas.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "RESERVEDAREA", level, index+1)
            }
        }

        //Create Picking Level
        if(area.isStorage && jsonObject.pickedLevels){
            jsonObject.pickedLevels.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "PICKLEVEL", level, index+1)
            }
        }

        //Create Next Processing Area
        if(area.isProcessing && !area.isStaging && jsonObject.nextProcessingArea){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "NXTPROCESSAREA", jsonObject.nextProcessingArea.areaId, null)
        }

        area.save(flush: true, failOnError: true)

    }

    def updateArea(area, jsonObject){

        entityAttributeService.removeEntityAttributesByConfigKey(area.companyId, area.areaId)

        //Create Max Load
        if(area.isStorage && jsonObject.maximumLoad){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "MAXLOAD", jsonObject.maximumLoad, null)
        }

        //Create Storage Restriction
        if(area.isStorage && jsonObject.selectedStorageRestrictionOptions){
            jsonObject.selectedStorageRestrictionOptions.eachWithIndex { option, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "STRG", option.configValue, index+1)
            }
        }

        //Create Picking Level
        if(area.isPickable && jsonObject.selectedReplenishmentAreas){
            jsonObject.selectedReplenishmentAreas.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "RESERVEDAREA", level.configValue, index+1)
            }
        }

        //Create Picking Level
        if(area.isStorage && jsonObject.pickedLevels){
            jsonObject.pickedLevels.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "PICKLEVEL", level.configValue, index+1)
            }
        }

        //Create Next Processing Area
        if(area.isProcessing && !area.isStaging && jsonObject.nextProcessingArea){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "NXTPROCESSAREA", jsonObject.nextProcessingArea.areaId, null)
        }
        area.save(flush: true, failOnError: true)

    }

    def updateBinArea(area, jsonObject){
        entityAttributeService.removeEntityAttributesByConfigKey(area.companyId, area.areaId)

        //Create Max Load
        if(area.isStorage && jsonObject.maximumLoad){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "MAXLOAD", jsonObject.maximumLoad, null)
        }

        //Create Storage Restriction
        if(area.isStorage && jsonObject.selectedStorageRestrictionOptions){
            jsonObject.selectedStorageRestrictionOptions.eachWithIndex { option, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "STRG", option.configValue, index+1)
            }
        }

        //Create Picking Level
        if(area.isPickable && jsonObject.selectedReplenishmentAreas){
            jsonObject.selectedReplenishmentAreas.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "RESERVEDAREA", level.configValue, index+1)
            }
        }

        //Create Picking Level
        if(area.isStorage && jsonObject.pickedLevels){
            jsonObject.pickedLevels.eachWithIndex { level, index ->
                entityAttributeService.save(area.companyId, "AREAS", area.areaId, "PICKLEVEL", level.configValue, index+1)
            }
        }

        //Create Next Processing Area
        if(area.isProcessing && !area.isStaging && jsonObject.nextProcessingArea){
            entityAttributeService.save(area.companyId, "AREAS", area.areaId, "NXTPROCESSAREA", jsonObject.nextProcessingArea.areaId, null)
        }

        def allLocationByArea = Location.findAllByCompanyIdAndAreaId(area.companyId, jsonObject.areaId)
        if (allLocationByArea.size() > 0) {
            for(location in allLocationByArea) {
                moveEntireInventoryToBinLocation(area.companyId, location.locationId, location.locationId)
            }
        }

        area.save(flush: true, failOnError: true)        
    }

    def moveEntireInventoryToBinLocation(companyId, fromLocation, toLocation){
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
        return inventoryEntityAttribute

    }

    def palletOrCaseToEaches(companyId, associatedLpn, locationId){

        def inventoryData = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, associatedLpn)
        if (inventoryData.size() > 0) {
            for(inventory in inventoryData) {
               def calculatedInventoryQty = 0
               def itemData = Item.findByCompanyIdAndItemId(companyId, inventory.itemId) 
               if (itemData.lowestUom == 'EACH' && inventory.handlingUom == 'CASE') {
                   calculatedInventoryQty = (itemData.eachesPerCase.toInteger() * inventory.quantity.toInteger())
               }
               else if (itemData.lowestUom == 'EACH' && inventory.handlingUom == 'EACH') {
                   calculatedInventoryQty = inventory.quantity
               }

               inventory.quantity = calculatedInventoryQty
               inventory.associatedLpn = null
               inventory.handlingUom = 'EACH'
               inventory.locationId = locationId
               inventory.save(flush: true, failOnError: true)
            }
            
            
        }
    }

    def checkPalletAndCaseExistForArea(companyId, areaId){
        def lpnData = []
        def locationsByArea = Location.findAllByCompanyIdAndAreaId(companyId, areaId)
        if (locationsByArea.size() > 0) {
            for(location in locationsByArea) {
                def inventoryWithLpn = InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, location.locationId)
                if (inventoryWithLpn.size() > 0) {
                    return inventoryWithLpn   
                    break                          
                }                       
            }
            return []            
        }
        else{
            return []
        }
    }

    def checkLowestUOMCaseExistForArea(companyId, areaId){
        def sqlQuery = "SELECT i.*, itm.* FROM inventory as i INNER JOIN item as itm ON itm.item_id = i.item_id AND itm.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn AND iea.company_id = '${companyId}' LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn AND ieap.company_id = '${companyId}' INNER JOIN location as loc ON loc.location_id = (CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END ) WHERE i.company_id = '${companyId}' AND loc.area_id = '${areaId}' AND itm.lowest_uom = 'CASE'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getProcessingAreas(companyId){
        return Area.findAllByCompanyIdAndIsProcessingAndIsStaging(companyId, true, false)
    }

    def getReplenishmentAreaIds(companyId, pickedLevels){

        def sqlQuery =  "SELECT DISTINCT config_key AS areaId FROM entity_attribute " +
                        " WHERE company_id = '${companyId}' " +
                        " AND entity_id ='AREAS' " +
                        " AND config_group = 'PICKLEVEL' "

        if(pickedLevels && pickedLevels.contains('EACH')){
            sqlQuery += " AND (config_value = 'PALLET' or config_value = 'CASE' or config_value = 'EACH')"
        }
        else if (pickedLevels && pickedLevels.contains('CASE')){
            sqlQuery += " AND (config_value = 'PALLET' or config_value = 'CASE')"
        }
        else  if (pickedLevels && pickedLevels.contains('PALLET')){
            sqlQuery += " AND config_value = 'PALLET' "
        }
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getReplenishmentAreas(companyId, areaId){
        def sqlQuery =  "SELECT config_value " +
                        "FROM entity_attribute " +
                        "WHERE company_id = '${companyId}' " +
                        "AND entity_id = 'AREAS' " +
                        "AND config_key = '${areaId}' " +
                        "AND config_group = 'RESERVEDAREA' " +
                        "ORDER By sort_sequence "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getArea(companyId, areaId){
        return Area.findByCompanyIdAndAreaId(companyId, areaId)
    }


    def deleteArea(area){
        entityAttributeService.removeEntityAttributesByConfigKey(area.companyId, area.areaId)
        area.delete()
        return true
    }

    def searchArea(companyId, areaId, locationId)
    {        

        def sqlQuery = "SELECT a.area_id as areaId, loc.location_id as locationId from area as a LEFT JOIN location as loc ON a.area_id = loc.area_id AND loc.company_id = '${companyId}' WHERE a.company_id = '${companyId}'"

        if(areaId){
            def findAreaId = '%'+areaId+'%'
            sqlQuery = sqlQuery + " AND a.area_id LIKE '${findAreaId}'"
        }

        if(locationId){
            def findLocationId = '%'+locationId+'%'
            sqlQuery = sqlQuery + " AND (loc.location_id LIKE '${findLocationId}' OR loc.location_barcode LIKE '${findLocationId}')"
        }

        sqlQuery = sqlQuery + "GROUP BY a.area_id  ORDER BY a.area_id ASC"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }

    def checkPickableAreaUnavailable(companyId){
        def errorMessage = null
        def pickableAreas = Area.findAllByCompanyIdAndIsPickable(companyId, true)
        if (!pickableAreas)
            errorMessage = "There are no areas that can be pickable item from that area"

        return errorMessage

    }

}

