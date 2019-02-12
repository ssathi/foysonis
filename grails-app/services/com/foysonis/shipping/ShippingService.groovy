package com.foysonis.shipping

import com.foysonis.area.Location
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.inventory.ShippedInventory
import com.foysonis.inventory.ShippedInventoryEntityAttribute
import com.foysonis.orders.OrderStatus
import com.foysonis.orders.ShipmentStatus

//import com.foysonis.util.FoysonisLogger
import grails.transaction.Transactional
import groovy.sql.Sql
import com.foysonis.orders.Shipment
import com.foysonis.orders.ShipmentLine
import com.foysonis.picking.PickWork
import com.foysonis.orders.Orders
import com.foysonis.orders.CustomerAddress
import com.foysonis.inventory.ShippedInventoryService

@Transactional
class ShippingService {
    def sessionFactory
    def trailerService
    def customerService
    def shippedInventoryService
//    FoysonisLogger logger = FoysonisLogger.getLogger(AllocationService.class);
    //active shipments

    def findAllShipmentLinesByShipmentId(companyId, selectedShipmentId){
        return ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, selectedShipmentId)
    }

    def findAllPickWorksByShipmentLine(companyId, shipmentLineId){
        return PickWork.findAllByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
    }

    def findAllPickWorksByShipment(companyId, shipmentId){
        return PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def findAssociatedLpnByReference(companyId, workReferenceNumber){
        return Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
    }

    def findOderByShipment(companyId, shipmentId){
        return ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def findShipment(companyId, shipmentId){
        return Shipment.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def editShipmentWithNewShippingAddress(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, contactName, shipmentId, customerAddress, shipmentNotes) {

        CustomerAddress  ca = customerService.createCustomerShippingAddress(customerAddress)
        return editShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, contactName, shipmentId, ca.id, shipmentNotes)

    }

    def editShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, contactName, shipmentId, shippingAddressId, shipmentNotes){

        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
        if (shipment) {

            shipment.carrierCode = carrierCode
            if(isParcel == 'true'){
                shipment.isParcel = true
                shipment.serviceLevel = serviceLevel
                shipment.truckNumber = null
            }
            else{
                shipment.isParcel = false
                shipment.serviceLevel = null
                shipment.truckNumber = truckNumber
            }       
            //shipment.shipmentStatus = "PLANNED"
            shipment.trackingNo = trackingNo == "" ? null : trackingNo





            shipment.shippingAddressId = shippingAddressId.toInteger()
            shipment.contactName = contactName
            shipment.shipmentNotes = shipmentNotes
            shipment.save(flush: true, failOnError: true)

            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber, shipmentId)
            }                 
        }
        return shipment

    }

    def findOrderLine(companyId,shipmentLineId) {
        def sqlQuery = "SELECT * from shipment_line as sl INNER JOIN order_line as ol ON sl.order_line_number = ol.order_line_number WHERE sl.company_id = '${companyId}' AND sl.shipment_line_id = '${shipmentLineId}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getTotalPickQty(companyId,selectedShipmentLine) {
        def sqlQuery = "SELECT *,SUM(pw.pick_quantity) AS totalPickQty from pick_work as pw WHERE pw.company_id = '${companyId}'AND pw.shipment_line_id = '${selectedShipmentLine}' GROUP BY pw.shipment_line_id"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getLocations(companyId, isStaging) {
        def sqlQuery = "SELECT l.location_id as contactName FROM area as a INNER JOIN location as l ON a.area_id = l.area_id WHERE l.company_id = '${companyId}' AND a.is_staging ='1';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getShipment(companyId, locationId) {
        def sqlQuery = "SELECT * FROM staging_lane_shipment as sl INNER JOIN shipment as s ON sl.shipment_id = s.shipment_id WHERE s.company_id = '${companyId}'AND sl.location_id = '${locationId}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def loadShipment(companyId,truckNumber, shipmentId, noOfLabels){
        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
        if (shipment) {
            shipment.truckNumber = truckNumber
            shipment.shipmentStatus = ShipmentStatus.COMPLETED
            shipment.completedDate = new Date()
            if (noOfLabels) {
                shipment.noOfLabels = noOfLabels.toInteger()
            }
            
            shipment.save(flush: true, failOnError: true)
            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber, shipmentId)
            }             
        }

        def getShipmentLine = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId,shipmentId)

        for(shipmentLine in getShipmentLine) {

                def sqlQueryForCompletedShip = "SELECT * FROM orders as ord INNER JOIN shipment_line as sl ON sl.order_number = ord.order_number AND sl.company_id = '${companyId}' INNER JOIN shipment as sh ON sl.shipment_id = sh.shipment_id AND sh.company_id = '${companyId}' WHERE ord.order_number = '${shipmentLine.orderNumber}' AND sh.shipment_status = '${ShipmentStatus.COMPLETED}' AND ord.company_id = '${companyId}';"

                def sqlQueryForTotalShip = "SELECT * FROM orders as ord INNER JOIN shipment_line as sl ON sl.order_number = ord.order_number AND sl.company_id = '${companyId}' INNER JOIN shipment as sh ON sl.shipment_id = sh.shipment_id AND sh.company_id = '${companyId}' WHERE ord.order_number = '${shipmentLine.orderNumber}' AND sh.shipment_status = '${ShipmentStatus.COMPLETED}' AND ord.company_id = '${companyId}';"

                def sql1 = new Sql(sessionFactory.currentSession.connection())
                def sql2 = new Sql(sessionFactory.currentSession.connection())
                def getTotalNumberOfCompletedShipmentsByOrder = sql1.rows(sqlQueryForCompletedShip)
                def getTotalNumberOfShipmentsByOrder = sql2.rows(sqlQueryForTotalShip)                

                if (getTotalNumberOfShipmentsByOrder.size() == getTotalNumberOfCompletedShipmentsByOrder.size()) {
                    def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, shipmentLine.orderNumber)
                    getOrder.orderStatus = OrderStatus.CLOSED
                    getOrder.save(flush:true, failOnError:true)
                }            
           }

        def pickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)

        for(pickWork in pickWorks){

            pickWork.destinationLocationId = shipmentId
            pickWork.destinationAreaId = ""
            pickWork.save(flush: true, failOnError: true)

            //Start Update Inventory Location to Shipment Id
            def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, pickWork.workReferenceNumber)
            if(inventories){
                for(inventory in inventories){

                    if(inventory.associatedLpn){
                        InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)

                        if(inventoryEntityAttribute){
                            InventoryEntityAttribute inventoryEntityAttributeParent = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
                            if(inventoryEntityAttributeParent){
                                shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttributeParent, shipmentId)
                            }
                            shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttribute, shipmentId)
                        }
                    }
                    shippedInventoryService.createShippedInventory(inventory, shipmentId)
                }
            }
            //END Update Inventory Location to Shipment Id

        }

        //KITTING ORDER INVENTORY : Start Update Inventory Location to  Shipment Id
        def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, shipmentId)
        if(inventories){
            for(inventory in inventories){

                log.info("11111")

                if(inventory.associatedLpn){
                    log.info("222222")

                    InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)

                    if(inventoryEntityAttribute){
                        InventoryEntityAttribute inventoryEntityAttributeParent = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
                        if(inventoryEntityAttributeParent){
                            log.info("33333333")

                            shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttributeParent, shipmentId)
                        }
                        log.info("4444444")

                        shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttribute, shipmentId)
                    }
                }
                log.info("55555")

                shippedInventoryService.createShippedInventory(inventory, shipmentId)
            }
        }
        //KITTING ORDER INVENTORY : END Update Inventory Location to Shipment Id

        return shipment

    }

    def completeShipment(companyId,shipmentId,workReferenceNumber,orderNumber,noOfLabels) {

        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
        if (shipment) {
            shipment.shipmentStatus = ShipmentStatus.COMPLETED
            shipment.completedDate = new Date()
            if (noOfLabels) {
                shipment.noOfLabels = noOfLabels.toInteger()
            }
            shipment.save(flush: true, failOnError: true)
        }

        def sqlQuery = "SELECT COUNT(s.shipment_id) from shipment as s INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id WHERE sl.company_id = '${companyId}' AND sl.order_number = '${orderNumber}' AND s.shipment_status = '${ShipmentStatus.COMPLETED}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def getTotalNumberOfCompletedShipment =  sql.rows(sqlQuery)

        def sqlQuery1 = "SELECT COUNT(s.shipment_id) from shipment as s INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id WHERE sl.company_id = '${companyId}' AND sl.order_number = '${orderNumber}' "
        def sql1 = new Sql(sessionFactory.currentSession.connection())
        def getTotalNumberOfOrderByShipment =  sql1.rows(sqlQuery1)

        def orders = Orders.findByCompanyIdAndOrderNumber(companyId,orderNumber)

        if (getTotalNumberOfCompletedShipment == getTotalNumberOfOrderByShipment) {
            orders.orderStatus = OrderStatus.CLOSED
            orders.save(flush: true, failOnError: true)

        }
//        else{
//            orders.orderStatus = 'PLANNED'
//            orders.save(flush: true, failOnError: true)
//        }


        def pickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)

        for (pickWork in pickWorks) {

            pickWork.destinationLocationId = shipmentId
            pickWork.destinationAreaId = ""
            pickWork.save(flush: true, failOnError: true)

            //Start Update Inventory Location to Shipment Id
            def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, pickWork.workReferenceNumber)
            if(inventories){
                for(inventory in inventories){
//                    if(inventory.locationId){
//                        inventory.locationId = shipmentId
//                        inventory.save(flush: true, failOnError: true)
//                    }
//                    else if(inventory.associatedLpn){
//                        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)
//                        if(inventoryEntityAttribute.locationId){
//                            inventoryEntityAttribute.locationId = shipmentId
//                            inventoryEntityAttribute.save(flush: true, failOnError: true)
//                        }
//                        else if(inventoryEntityAttribute.parentLpn){
//                            def inventoryEntityAttributeParent = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
//                            if(inventoryEntityAttributeParent.locationId){
//                                inventoryEntityAttributeParent.locationId = shipmentId
//                                inventoryEntityAttributeParent.save(flush: true, failOnError: true)
//                            }
//                        }
//                    }


                    if(inventory.associatedLpn){
                        InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)

                        if(inventoryEntityAttribute){
                            InventoryEntityAttribute inventoryEntityAttributeParent = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
                            if(inventoryEntityAttributeParent){
                                shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttributeParent, shipmentId)
                            }
                            shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttribute, shipmentId)
                        }
                    }
                    shippedInventoryService.createShippedInventory(inventory, shipmentId)
                }
            }
            //END Update Inventory Location to Shipment Id

        }

        //KITTING ORDER INVENTORY : Start Update Inventory Location to  Shipment Id
        def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, shipmentId)
        if(inventories){
            for(inventory in inventories){

                log.info("11111")

                if(inventory.associatedLpn){
                    log.info("222222")

                    InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventory.associatedLpn)

                    if(inventoryEntityAttribute){
                        InventoryEntityAttribute inventoryEntityAttributeParent = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, inventoryEntityAttribute.parentLpn)
                        if(inventoryEntityAttributeParent){
                            log.info("33333333")

                            shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttributeParent, shipmentId)
                        }
                        log.info("4444444")

                        shippedInventoryService.createShippedInventoryEntityAttribute(inventoryEntityAttribute, shipmentId)
                    }
                }
                log.info("55555")

                shippedInventoryService.createShippedInventory(inventory, shipmentId)
            }
        }
        //KITTING ORDER INVENTORY : END Update Inventory Location to Shipment Id

        return shipment
    }


    def voidShipment(companyId,shipmentId,workReferenceNumber,locationId,orderNumber) {

        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
        if (shipment) {
            shipment.shipmentStatus = ShipmentStatus.STAGED
            shipment.completedDate = null
            shipment.save(flush:true, failOnError:true)
        }

        def sqlQuery = "SELECT COUNT(s.shipment_id) from shipment as s INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id WHERE sl.company_id = '${companyId}' AND sl.order_number = '${orderNumber}' AND s.shipment_status = '${ShipmentStatus.STAGED}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def getTotalNumberOfCompletedShipment =  sql.rows(sqlQuery)

        def sqlQuery1 = "SELECT COUNT(s.shipment_id) from shipment as s INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id WHERE sl.company_id = '${companyId}' AND sl.order_number = '${orderNumber}' "
        def sql1 = new Sql(sessionFactory.currentSession.connection())
        def getTotalNumberOfOrderByShipment =  sql1.rows(sqlQuery1)

        def orders = Orders.findByCompanyIdAndOrderNumber(companyId,orderNumber)

        if (getTotalNumberOfCompletedShipment == getTotalNumberOfOrderByShipment) {
            orders.orderStatus = OrderStatus.PLANNED
            orders.save(flush: true, failOnError: true)

        }
//        else{
//            orders.orderStatus = 'CLOSED'
//            orders.save(flush: true, failOnError: true)
//        }

        def pickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)

        for (pickWork in pickWorks) {
            pickWork.destinationLocationId = locationId
            pickWork.destinationAreaId = location.areaId
            pickWork.save(flush:true, failOnError:true)
        }

        //Update Inventory Locations
        def shippedInventories = ShippedInventory.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        if(shippedInventories){
            for (shippedInventory in shippedInventories) {
//                inventory.locationId = locationId
//                inventory.save(flush:true, failOnError:true)
                shippedInventoryService.voidShippedInventory(shippedInventory, locationId)
            }
        }
        def shippedInventoryEntityAttributes = ShippedInventoryEntityAttribute.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        if(shippedInventoryEntityAttributes){
            for (shippedInventoryEntityAttribute in shippedInventoryEntityAttributes) {
//                inventoryEntityAttribute.locationId = locationId
//                inventoryEntityAttribute.save(flush:true, failOnError:true)

                shippedInventoryService.voidShippedInventoryEntityAttribute(shippedInventoryEntityAttribute, locationId)
            }
        }

        return shipment
    }


    def checkTruckNumberExist(companyId, truckNumber){
        return Shipment.findAllByCompanyIdAndTruckNumber(companyId, truckNumber)
    }

    def findAllInventoryByShipmentLine(companyId,selectedShipmentLine) {
        def sqlQuery = "SELECT * , CASE WHEN iea.level = 'CASE' THEN inv.associated_lpn ELSE NULL END AS pickedCaseId, CASE WHEN iea.level = 'Pallet' THEN inv.associated_lpn ELSE NULL END AS pickedPalletId  "
        sqlQuery = sqlQuery + " FROM shipment_line AS sl  "
        sqlQuery = sqlQuery + " INNER JOIN pick_work AS pw ON sl.shipment_line_id = pw.shipment_line_id "
        sqlQuery = sqlQuery + " INNER JOIN inventory AS inv ON pw.work_reference_number = inv.work_reference_number "
        sqlQuery = sqlQuery + " LEFT JOIN inventory_entity_attribute AS iea ON inv.associated_lpn = iea.lpn "
        sqlQuery = sqlQuery + " LEFT JOIN item as i ON sl.item_id = i.item_id "
        sqlQuery = sqlQuery + " WHERE pw.company_id = '${companyId}' AND sl.shipment_line_id = '${selectedShipmentLine}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def findAllShippedInventoryByShipmentLine(companyId,selectedShipmentLine) {
        def sqlQuery = "SELECT * , CASE WHEN iea.level = 'CASE' THEN inv.associated_lpn ELSE NULL END AS pickedCaseId, CASE WHEN iea.level = 'Pallet' THEN inv.associated_lpn ELSE NULL END AS pickedPalletId  "
        sqlQuery = sqlQuery + " FROM shipment_line AS sl  "
        sqlQuery = sqlQuery + " INNER JOIN pick_work AS pw ON sl.shipment_line_id = pw.shipment_line_id "
        sqlQuery = sqlQuery + " INNER JOIN shipped_inventory AS inv ON pw.work_reference_number = inv.work_reference_number "
        sqlQuery = sqlQuery + " LEFT JOIN shipped_inventory_entity_attribute AS iea ON inv.associated_lpn = iea.lpn "
        sqlQuery = sqlQuery + " LEFT JOIN item as i ON sl.item_id = i.item_id "
        sqlQuery = sqlQuery + " WHERE pw.company_id = '${companyId}' AND sl.shipment_line_id = '${selectedShipmentLine}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def shipmentSearch (companyId,orderNumber,shipmentId,truckNumber,smallPackage,completedDateRange,completedDate, kittingOrderNumber)
    {
        def sqlQuery = "SELECT distinct s.shipment_id, s.is_parcel, s.service_level, s.shipment_status, s.tracking_no, s.truck_number, s.creation_date, s.completed_date, s.truck_instance_id, s.shipping_address_id, s.shipment_notes, cus.customer_id, cus.contact_name AS billing_contact_name, cus.company_name AS billing_company_name, s.contact_name, sl.order_number, lv.description AS carrier_code, odr.notes, lv.option_value AS carrier_code_option_value, s.company_id, s.easy_post_manifested, s.easy_post_shipment_id, s.easy_post_label, s.actual_weight "

        sqlQuery += "FROM shipment as s "
        sqlQuery += "INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id AND sl.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN orders as odr ON sl.order_number = odr.order_number AND odr.company_id = '${companyId}' "
        sqlQuery += "LEFT JOIN list_value as lv ON lv.option_value = s.carrier_code AND lv.option_group = 'CARRCODE' AND lv.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN customer as cus ON odr.customer_id = cus.customer_id AND cus.company_id = '${companyId}' "
        sqlQuery += "LEFT JOIN kitting_order AS ko ON ko.order_info = sl.order_line_number AND ko.company_id = '${companyId}' "
        sqlQuery += "WHERE s.company_id = '${companyId}' "

        if(orderNumber){
            def findOrderNumber = '%'+orderNumber+'%'
            sqlQuery += " AND sl.order_number LIKE '${findOrderNumber}'"
        }

        if(shipmentId){
            def findShipmentId = '%'+shipmentId+'%'
            sqlQuery += " AND s.shipment_id LIKE '${findShipmentId}'"
        }

        if(truckNumber){
            def findTruckNumber = '%'+truckNumber+'%'
            sqlQuery += " AND s.truck_number LIKE '${findTruckNumber}'"
        }

        if(smallPackage == "true"){
            sqlQuery += " AND s.is_parcel = true"
        }

        if(completedDateRange == "true"){
            sqlQuery += " AND s.shipment_status ='${ShipmentStatus.COMPLETED}'"

            def checkDate = new Date();

            if(completedDate == 'last7Days'){
                checkDate = new Date()-7;
            }
            else if(completedDate == 'last14Days'){
                checkDate = new Date()-14;
            }
            else if(completedDate == 'last30Days'){
                checkDate = new Date()-30;
            }

            def convertedCheckDate = checkDate.format("yyyy-MM-dd")
            sqlQuery += " AND s.shipment_status ='${ShipmentStatus.COMPLETED}' AND s.completed_date >= '${convertedCheckDate}'"

        }
        else{
            sqlQuery += " AND (s.shipment_status ='${ShipmentStatus.ALLOCATED}' OR s.shipment_status ='${ShipmentStatus.STAGED}' OR s.shipment_status ='${ShipmentStatus.KO_PROCESSING}')"
        }
        if(kittingOrderNumber){
            kittingOrderNumber = '%'+kittingOrderNumber+'%'
            sqlQuery += " AND ko.order_info LIKE '${kittingOrderNumber}'"
        }

        sqlQuery += " ORDER BY s.shipment_id DESC"

        println("sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows

    }

    //active trucks

    def findTruck(companyId, id){
        return Trailer.findAllByCompanyIdAndId(companyId, id)
    }

    def closeTruck(companyId, id) {
        def trailer = Trailer.findByCompanyIdAndId(companyId,id)
        if (trailer) {
            trailer.status = TrailerStatus.CLOSED
            trailer.save(flush: true, failOnError: true)
        }
    }

    def openTruck(companyId, id) {
        def trailer = Trailer.findByCompanyIdAndId(companyId,id)
        if (trailer) {
            trailer.status = TrailerStatus.OPEN
            trailer.save(flush: true, failOnError: true)
        }
    }

    def dispatchTruck(companyId, id) {
        def trailer = Trailer.findByCompanyIdAndId(companyId, id)
        if (trailer) {
            trailer.status = TrailerStatus.DISPATCHED
            trailer.dispatchedDate = new Date()
            trailer.save(flush: true, failOnError: true)
        }

    }

    def truckSearch (companyId,truckNumber,dispatchedDateRange,dispatchedDate) {
        def sqlQuery = "SELECT distinct s.*,t.*,sl.order_number from shipment as s INNER JOIN trailer as t ON s.truck_instance_id = t.id LEFT JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id WHERE t.company_id = '${companyId}'"

        if(truckNumber){
            def findTruckNumber = '%'+truckNumber+'%'
            sqlQuery = sqlQuery + " AND t.trailer_number LIKE '${findTruckNumber}'"
        }

        if(dispatchedDateRange == 'true'){
            sqlQuery = sqlQuery + " AND t.status ='${TrailerStatus.DISPATCHED}'"

            def checkDate = new Date()-3;

            if(dispatchedDate == 'last7Days'){
                checkDate = new Date()-7;
            }
            else if(dispatchedDate == 'last14Days'){
                checkDate = new Date()-14;
            }
            else if(dispatchedDate == 'last30Days'){
                checkDate = new Date()-30;
            }

            def convertedCheckDate = checkDate.format("yyyy-MM-dd HH:mm:ss")
            sqlQuery = sqlQuery + " AND t.status ='${TrailerStatus.DISPATCHED}' AND t.dispatched_date >= '${convertedCheckDate}'"
        }
        else {
            sqlQuery = sqlQuery +" AND t.status !='${TrailerStatus.DISPATCHED}'"
        }

        sqlQuery = sqlQuery + " ORDER BY t.id ASC"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows

    }

    def updateShipmentWithEasyPostData(companyId, shipmentId, easyPostLabel, easyPostShipmentId,
                                       easyPostManifested, trackingCode){
        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
        if (shipment) {
            shipment.easyPostLabel = easyPostLabel
            shipment.easyPostManifested = easyPostManifested
            shipment.easyPostShipmentId = easyPostShipmentId
            shipment.trackingNo = trackingCode
            shipment.save(flush: true, failOnError: true)
        }
    }



}
