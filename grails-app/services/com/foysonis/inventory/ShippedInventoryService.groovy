package com.foysonis.inventory

import grails.transaction.Transactional
import groovy.sql.Sql
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.inventory.ShippedInventory
import com.foysonis.inventory.ShippedInventoryEntityAttribute

@Transactional
class ShippedInventoryService {

    def sessionFactory
    def entityLastRecordService

    def shippedInventorySearch(companyId, itemId, lpn, shipmentId, orderNumber, customerName, inventoryNote, inventoryStatus, fromShipmentCompletionDate, toShipmentCompletionDate){

        def sqlQuery = "SELECT DISTINCT si.id, siea.lpn, siea.parent_lpn, si.handling_uom, si.quantity, si.picked_inventory_notes, sh.shipment_id, it.item_id, it.item_description, lv.description AS inventory_status, ord.order_number, CONCAT(cus.contact_name, ' - ', cus.company_name) AS customer_name, sh.completed_date, CONCAT(ca.street_address, ', ', ca.city, ', ', ca.state, ', ', ca.post_code, ', ', COALESCE(ca.country,'')) AS shipment_address, ord.notes AS order_notes, CASE WHEN level = 'CASE' THEN siea.lpn END AS case_id, CASE WHEN level = 'PALLET' THEN siea.lpn END AS pallet_id " +
                "FROM shipped_inventory AS si " +
                "LEFT JOIN shipped_inventory_entity_attribute AS siea ON si.associated_lpn = siea.lpn AND si.shipment_id=siea.shipment_id AND siea.company_id='${companyId}' " +
                "INNER JOIN shipment AS sh ON sh.shipment_id = si.shipment_id AND sh.company_id='${companyId}' " +
                "INNER JOIN shipment_line AS sl ON sl.shipment_id = si.shipment_id AND sl.company_id='${companyId}' " +
                "INNER JOIN orders AS ord ON ord.order_number = sl.order_number AND ord.company_id='${companyId}' " +
                "INNER JOIN customer AS cus ON cus.customer_id = ord.customer_id AND cus.company_id='${companyId}' " +
                "INNER JOIN item AS it ON it.item_id = si.item_id AND it.company_id='${companyId}' " +
                "INNER JOIN customer_address AS ca ON ca.id = sh.shipping_address_id AND ca.company_id='${companyId}' " +
                "INNER JOIN list_value AS lv ON lv.option_value = si.inventory_status AND lv.company_id = '${companyId}' AND lv.option_group = 'INVSTATUS' " +
                "WHERE  si.company_id='${companyId}' "


        if(itemId){
            itemId = '%'+itemId+'%'
            sqlQuery = sqlQuery + " AND (it.item_id LIKE '${itemId}' OR it.item_description LIKE '${itemId}') "
        }

        if (lpn){
            lpn = '%'+lpn+'%'
            sqlQuery = sqlQuery + " AND (siea.lpn LIKE '${lpn}' OR siea.parent_lpn LIKE '${lpn}') "
        }

        if (shipmentId){
            shipmentId = '%'+shipmentId+'%'
            sqlQuery = sqlQuery + " AND (sh.shipment_id LIKE '${shipmentId}') "
        }

        if (orderNumber){
            orderNumber = '%'+orderNumber+'%'
            sqlQuery = sqlQuery + " AND (ord.order_number LIKE '${orderNumber}') "
        }

        if (customerName){
            customerName = '%'+customerName+'%'
            sqlQuery = sqlQuery + " AND (cus.contact_name LIKE '${customerName}' OR cus.company_name LIKE '${customerName}') "
        }

        if (inventoryNote){
            inventoryNote = '%'+inventoryNote+'%'
            sqlQuery = sqlQuery + " AND (si.picked_inventory_notes LIKE '${inventoryNote}') "
        }

        if (inventoryStatus){
            sqlQuery = sqlQuery + " AND (lv.option_value = '${inventoryStatus}') "
        }

        if(toShipmentCompletionDate == null && fromShipmentCompletionDate){
            sqlQuery = sqlQuery + " AND (sh.completed_date >= DATE('${fromShipmentCompletionDate}') AND sh.completed_date < DATE_ADD(DATE('${fromShipmentCompletionDate}'), INTERVAL 1 DAY)) "
        }
        else if(toShipmentCompletionDate && fromShipmentCompletionDate){
            sqlQuery = sqlQuery + " AND (sh.completed_date >= DATE('${fromShipmentCompletionDate}') AND sh.completed_date < DATE_ADD(DATE('${toShipmentCompletionDate}'), INTERVAL 1 DAY)) "
        }


        sqlQuery = sqlQuery + " ORDER BY sh.completed_date DESC LIMIT 10000 "

        log.info("sqlQuery123  : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def createShippedInventory(inventory, shipmentId){
        ShippedInventory shippedInventory = new ShippedInventory()

        shippedInventory.companyId = inventory.companyId
        shippedInventory.inventoryId = inventory.inventoryId
        shippedInventory.itemId = inventory.itemId
        shippedInventory.associatedLpn = inventory.associatedLpn
        shippedInventory.locationId = inventory.locationId
        shippedInventory.quantity = inventory.quantity
        shippedInventory.handlingUom = inventory.handlingUom
        shippedInventory.lotCode = inventory.lotCode
        shippedInventory.expirationDate = inventory.expirationDate
        shippedInventory.inventoryStatus = inventory.inventoryStatus
        shippedInventory.workReferenceNumber = inventory.workReferenceNumber
        shippedInventory.pickedInventoryNotes = inventory.pickedInventoryNotes
        shippedInventory.shipmentId = shipmentId

        if(shippedInventory.save(flush: true, failOnError: true)){
            return inventory.delete(flush: true, failOnError: true)
        }

    }

    def createShippedInventoryEntityAttribute(inventoryEntityAttribute, shipmentId){

        ShippedInventoryEntityAttribute shippedInventoryEntityAttribute = new ShippedInventoryEntityAttribute()

        shippedInventoryEntityAttribute.companyId = inventoryEntityAttribute.companyId
        shippedInventoryEntityAttribute.lPN = inventoryEntityAttribute.lPN
        shippedInventoryEntityAttribute.level = inventoryEntityAttribute.level
        shippedInventoryEntityAttribute.locationId = inventoryEntityAttribute.locationId
        shippedInventoryEntityAttribute.parentLpn = inventoryEntityAttribute.parentLpn
        shippedInventoryEntityAttribute.sscc = inventoryEntityAttribute.sscc
        shippedInventoryEntityAttribute.lastModifiedDate = inventoryEntityAttribute.lastModifiedDate
        shippedInventoryEntityAttribute.createdDate = inventoryEntityAttribute.createdDate
        shippedInventoryEntityAttribute.lastModifiedUserId = inventoryEntityAttribute.lastModifiedUserId
        shippedInventoryEntityAttribute.inventoryEntityAttributeId = inventoryEntityAttribute.id
        shippedInventoryEntityAttribute.shipmentId = shipmentId

        if(shippedInventoryEntityAttribute.save(flush: true, failOnError: true)){
            return inventoryEntityAttribute.delete(flush: true, failOnError: true)
        }

    }

    def voidShippedInventory(shippedInventory, locationId){
        Inventory inventory = new Inventory()

        inventory.companyId = shippedInventory.companyId
        inventory.itemId = shippedInventory.itemId
        inventory.associatedLpn = shippedInventory.associatedLpn
        if(shippedInventory.locationId){
            inventory.locationId = locationId
        }
        inventory.quantity = shippedInventory.quantity
        inventory.handlingUom = shippedInventory.handlingUom
        inventory.lotCode = shippedInventory.lotCode
        inventory.expirationDate = shippedInventory.expirationDate
        inventory.inventoryStatus = shippedInventory.inventoryStatus
        inventory.workReferenceNumber = shippedInventory.workReferenceNumber
        inventory.pickedInventoryNotes = shippedInventory.pickedInventoryNotes

        //def inventoryIdExist = Inventory.find("from Inventory as i where i.companyId='${shippedInventory.companyId}' order by inventoryId DESC")
        //if (!inventoryIdExist) {

            //inventory.inventoryId =  companyId + "000001"
        //}
        //else{

            //def inventoryIdInteger = inventoryIdExist.inventoryId - shippedInventory.companyId
            //def intIndex = inventoryIdInteger.toInteger()
            //intIndex = intIndex + 1
            def intIndex = entityLastRecordService.getLastRecordId(shippedInventory.companyId, "INVENTORY").lastRecordId
            def stringIndex = intIndex.toString().padLeft(6,"0")
            inventory.inventoryId = shippedInventory.companyId + stringIndex
        //}

        if(inventory.save(flush: true, failOnError: true)){
            return shippedInventory.delete(flush: true, failOnError: true)
        }
    }

    def voidShippedInventoryEntityAttribute(shippedInventoryEntityAttribute, locationId){

        InventoryEntityAttribute inventoryEntityAttribute = new InventoryEntityAttribute()

        inventoryEntityAttribute.companyId = shippedInventoryEntityAttribute.companyId
        inventoryEntityAttribute.lPN = shippedInventoryEntityAttribute.lPN
        inventoryEntityAttribute.level = shippedInventoryEntityAttribute.level

        if(shippedInventoryEntityAttribute.locationId){
            inventoryEntityAttribute.locationId = locationId
        }
        inventoryEntityAttribute.parentLpn = shippedInventoryEntityAttribute.parentLpn
        inventoryEntityAttribute.sscc = shippedInventoryEntityAttribute.sscc
        inventoryEntityAttribute.lastModifiedDate = shippedInventoryEntityAttribute.lastModifiedDate
        inventoryEntityAttribute.createdDate = shippedInventoryEntityAttribute.createdDate
        inventoryEntityAttribute.lastModifiedUserId = shippedInventoryEntityAttribute.lastModifiedUserId

        if(inventoryEntityAttribute.save(flush: true, failOnError: true)){
            return shippedInventoryEntityAttribute.delete(flush: true, failOnError: true)
        }

    }
}
