package com.foysonis.orders

import com.easypost.model.Order
import grails.transaction.Transactional
import groovy.sql.Sql
import com.foysonis.shipping.TrailerService
import com.foysonis.picking.AllocationFailedMessageService

@Transactional
class ShipmentService {

    def sessionFactory
    def orderService
    def inventorySummaryService
    def trailerService
    def allocationFailedMessageService
    def customerService

    def getPlannedShipment(companyId, customerId){

        def sqlQuery = "SELECT DISTINCT sh.shipment_id " +
                        "FROM shipment as sh " +
                        "INNER JOIN shipment_line as shl ON shl.shipment_id = sh.shipment_id " +
                        "INNER JOIN orders as ord ON ord.order_number = shl.order_number " +
                        "WHERE sh.company_id = '${companyId}' AND sh.shipment_status = '${ShipmentStatus.PLANNED}' AND ord.customer_id = '${customerId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def saveShipmentWithNewShippingAddress(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumber, contactName, shipmentNotes, customerAddress) {

        CustomerAddress  ca = customerService.createCustomerShippingAddress(customerAddress)
        return saveShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumber, contactName, ca.id, shipmentNotes)

    }

    def assignMultipleOrderLineToNewShipmentWithNewAdress(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumbers, contactName, customerAddress){

        CustomerAddress  ca = customerService.createCustomerShippingAddress(customerAddress)
        return assignMultipleOrderLineToNewShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumbers, contactName, ca.id)

    }

    def saveShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumber, contactName, shippingAddressId, shipmentNotes){

        OrderLine orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)

        def inventorySummaryUpdationDetails = null
        if(orderLine.isCreateKittingOrder == true){
            inventorySummaryUpdationDetails = inventorySummaryService.commitTriggeredOrderInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM, orderLine.orderLineNumber)
        }
        else{
             inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)
        }

        if(inventorySummaryUpdationDetails['committedResult']){
            def shipment = new Shipment()

            def shipmentIdExist = Shipment.find("from Shipment as sh where sh.companyId='${companyId}' order by shipmentId DESC")

            if (!shipmentIdExist) {
                shipment.shipmentId = companyId.toUpperCase() + "-SH0000001"
            }
            else{
                def lastShipmentId = shipmentIdExist.shipmentId - (companyId.toUpperCase() + "-SH")
                def intIndex = lastShipmentId.toInteger() + 1
                def stringIndex = intIndex.toString().padLeft(7,"0")
                shipment.shipmentId = companyId.toUpperCase() + "-SH" + stringIndex
            }

            shipment.companyId = companyId
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
            shipment.shipmentStatus = ShipmentStatus.PLANNED
            shipment.trackingNo = trackingNo == "" ? null : trackingNo
            shipment.creationDate = new Date()

            //TODO Start
//            def order = Orders.find("from Orders as ord where ord.companyId = ? and ord.orderNumber = ? ", companyId, orderNumber)
            //def customerAddress = CustomerAddress.find("from CustomerAddress as ca where ca.companyId = ? and ca.customerId = ? and ca.addressType = 'shipping' and ca.isDefault = true ", companyId, order.customerId)

            log.info(" shippingAddressId : " + shippingAddressId)

            shipment.shippingAddressId = shippingAddressId.toInteger()
            //TODO END
            shipment.contactName = contactName
            shipment.shipmentNotes = shipmentNotes
            shipment.stagingLocationId = null
            shipment.save(flush: true, failOnError: true)

            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber,shipment.shipmentId)
            }

            saveShipmentLine(companyId, shipment.shipmentId, orderLine)
            checkAndModifyOrderStatus(companyId, orderNumber)
        }

        return inventorySummaryUpdationDetails

    }

    def assignMultipleOrderLineToNewShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, orderNumber, orderLineNumbers, contactName, shippingAddressId){
        def inventorySummaryUpdationDetails = null
        def committedOrderLines = []

        for(orderLineNumber in orderLineNumbers){

            def orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)

//            inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)

            if(orderLine.isCreateKittingOrder == true){
                inventorySummaryUpdationDetails = inventorySummaryService.commitTriggeredOrderInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM, orderLine.orderLineNumber)

            }
            else{

                inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)
            }

            if (!inventorySummaryUpdationDetails['committedResult']){
                for(committedOrderLine in committedOrderLines){
                    inventorySummaryService.unCommitInventory(companyId, committedOrderLine.itemId, committedOrderLine.requestedInventoryStatus, committedOrderLine.orderedQuantity, committedOrderLine.orderedUOM)
                }
                break
            }
            else
                committedOrderLines.push(orderLine)

        }


        if(inventorySummaryUpdationDetails['committedResult']){
            def shipment = new Shipment()

            def shipmentIdExist = Shipment.find("from Shipment as sh where sh.companyId='${companyId}' order by shipmentId DESC")

            if (!shipmentIdExist) {
                shipment.shipmentId = companyId.toUpperCase() + "-SH0000001"
            }
            else{
                def lastShipmentId = shipmentIdExist.shipmentId - (companyId.toUpperCase() + "-SH")
                def intIndex = lastShipmentId.toInteger() + 1
                def stringIndex = intIndex.toString().padLeft(7,"0")
                shipment.shipmentId = companyId.toUpperCase() + "-SH" + stringIndex
            }

            shipment.companyId = companyId
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


            shipment.shipmentStatus = ShipmentStatus.PLANNED
            shipment.trackingNo = trackingNo == "" ? null : trackingNo
            shipment.creationDate = new Date()
            shipment.stagingLocationId = null

            //TODO Start
            //def order = Orders.find("from Orders as ord where ord.companyId = ? and ord.orderNumber = ? ", companyId, orderNumber)
            //def customerAddress = CustomerAddress.find("from CustomerAddress as ca where ca.companyId = ? and ca.customerId = ? and ca.addressType = 'shipping' and ca.isDefault = true ", companyId, order.customerId)

            shipment.shippingAddressId = shippingAddressId.toInteger()
            //TODO END
            shipment.contactName = contactName
            shipment.save(flush: true, failOnError: true)

            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber, shipment.shipmentId)
            }

            for(orderLineNumber in orderLineNumbers){
                def orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)
                saveShipmentLine(companyId, shipment.shipmentId, orderLine)
            }

        }
        checkAndModifyOrderStatus(companyId, orderNumber)
        return inventorySummaryUpdationDetails

    }

    def assignMultipleOrderLineToPlannedShipment(companyId, shipmentId, orderNumber, orderLineNumbers){
        def inventorySummaryUpdationDetails = null
        def committedOrderLines = []


        for(orderLineNumber in orderLineNumbers){

            def orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)

            if(orderLine.isCreateKittingOrder == true){
                inventorySummaryUpdationDetails = inventorySummaryService.commitTriggeredOrderInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM, orderLine.orderLineNumber)

            }
            else{
                inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)
            }

            if (!inventorySummaryUpdationDetails['committedResult']){
                for(committedOrderLine in committedOrderLines){
                    inventorySummaryService.unCommitInventory(companyId, committedOrderLine.itemId, committedOrderLine.requestedInventoryStatus, committedOrderLine.orderedQuantity, committedOrderLine.orderedUOM)
                }
                break
            }

            else
                committedOrderLines.push(orderLine)

        }


        if(inventorySummaryUpdationDetails['committedResult']){

            for(orderLineNumber in orderLineNumbers){
                def orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)
                saveShipmentLine(companyId, shipmentId, orderLine)
            }

        }
        checkAndModifyOrderStatus(companyId, orderNumber)
        return inventorySummaryUpdationDetails

    }

    def assignToPlannedShipment(companyId, shipmentId, orderNumber, orderLineNumber){

        def orderLine = OrderLine.find("from OrderLine as ol where ol.companyId = ? and ol.orderNumber = ? and ol.orderLineNumber = ? ", companyId, orderNumber, orderLineNumber)

        def inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)

        if(inventorySummaryUpdationDetails['committedResult']){
            saveShipmentLine(companyId, shipmentId, orderLine)
        }
        checkAndModifyOrderStatus(companyId, orderNumber)
        return inventorySummaryUpdationDetails
    }

    def checkAndModifyOrderStatus(companyId, orderNumber){
        def getTotalNumberOfPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, orderNumber, 'PLANNED')
        def getTotalNumberOfOrderLinesByOrder = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderNumber)

        if (getTotalNumberOfOrderLinesByOrder.size() == getTotalNumberOfPlannedOrdersLines.size()) {
            def order = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
            order.orderStatus = OrderStatus.PLANNED
            order.save(flush:true, failOnError:true)
        }
        else{
            def order = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
            order.orderStatus = OrderStatus.PARTIALLY_PLANNED
            order.save(flush:true, failOnError:true)
        }
    }

    def saveShipmentLine(companyId, shipmentId, orderLine){

        def shipmentLine = new ShipmentLine()

        def shipmentLineIdExist = ShipmentLine.find("from ShipmentLine as sl where sl.companyId='${companyId}' order by shipmentLineId DESC")

        if (!shipmentLineIdExist) {
            shipmentLine.shipmentLineId = companyId.toUpperCase() + "-SL0000001"
        }
        else{
            def lastShipmentLineId = shipmentLineIdExist.shipmentLineId - (companyId.toUpperCase() + "-SL")
            def intIndex = lastShipmentLineId.toInteger() + 1
            def stringIndex = intIndex.toString().padLeft(7,"0")
            shipmentLine.shipmentLineId = companyId.toUpperCase() + "-SL" + stringIndex
        }

        shipmentLine.companyId = companyId
        shipmentLine.shipmentId = shipmentId
        shipmentLine.orderNumber = orderLine.orderNumber
        shipmentLine.orderLineNumber = orderLine.orderLineNumber
        shipmentLine.itemId = orderLine.itemId
        shipmentLine.shippedQuantity = orderLine.orderedQuantity
        shipmentLine.shippedUOM = orderLine.orderedUOM
        shipmentLine.kittingOrderQuantity = orderLine.kittingOrderQuantity
        shipmentLine.save(flush: true, failOnError: true)

        orderService.planOrderLine(companyId, orderLine.orderNumber, orderLine.orderLineNumber)

    } 

    def getShipmentIds(companyId, orderNumber){
        return ShipmentLine.findAll("select sl.shipmentId from ShipmentLine as sl where sl.companyId = ? and sl.orderNumber = ? group by sl.shipmentId", companyId, orderNumber)
    }

    def editShipmentWithNewShippingAddress(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, shipmentId, contactName, shipmentNotes, customerAddress) {

        CustomerAddress  ca = customerService.createCustomerShippingAddress(customerAddress)
        return editShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, shipmentId, contactName, ca.id, shipmentNotes)

    }

    def editShipment(companyId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, shipmentId, contactName, shippingAddressId, shipmentNotes){

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

            shipment.shipmentStatus = ShipmentStatus.PLANNED
            shipment.trackingNo = trackingNo == "" ? null : trackingNo
            shipment.shippingAddressId = shippingAddressId.toInteger()
            shipment.contactName = contactName
            shipment.shipmentNotes = shipmentNotes
            shipment.save(flush: true, failOnError: true)
            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber,shipmentId)
            }

        }
        return shipment
   

    }
    def cancelShipment(companyId, shipment){
       def orderNumberList = []
        Integer orderLineQty = 0
       def shipmentLineData = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, shipment.shipmentId)

       if (shipmentLineData.size() > 0) {
           for(shipmentLine in shipmentLineData) {
               def orderLineData = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, shipmentLine.orderNumber, shipmentLine.orderLineNumber)
               orderNumberList.add(shipmentLine.orderNumber)
               if(orderLineData){
                    if (orderLineData.orderLineStatus != "UNPLANNED") {
                       orderLineData.orderLineStatus = "UNPLANNED"
                       orderLineData.save(flush: true, failOnError: true)
                    }   
               }
               shipmentLine.delete(flush:true, failOnError:true)

               orderLineQty = orderLineData.orderedQuantity
               if(orderLineData.kittingOrderQuantity && orderLineData.kittingOrderQuantity > 0){
                   orderLineQty = orderLineQty - orderLineData.kittingOrderQuantity
                   orderLineData.kittingOrderQuantity = 0
                   orderLineData.save(flush:true, failOnError:true)
               }

               if(orderLineQty > 0)
                   inventorySummaryService.updateDecreasedCommittedQuantity(companyId, orderLineData.itemId, orderLineData.requestedInventoryStatus, orderLineQty, orderLineData.orderedUOM)
           }
        }
        def shipmentData = Shipment.findByCompanyIdAndShipmentId(companyId, shipment.shipmentId)
        shipmentData.delete(flush:true, failOnError:true)
        def duplicateRemovedOrders = orderNumberList.unique()

        for(order in duplicateRemovedOrders) {
            def getTotalNumberOfPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, order, 'PLANNED')
            def getTotalNumberOfOrderLinesByOrder = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, order)

            if (getTotalNumberOfOrderLinesByOrder.size() == getTotalNumberOfPlannedOrdersLines.size()) {
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, order)
                getOrder.orderStatus = OrderStatus.PLANNED
                getOrder.save(flush:true, failOnError:true)
            }
            else if(getTotalNumberOfOrderLinesByOrder.size() > getTotalNumberOfPlannedOrdersLines.size() && getTotalNumberOfPlannedOrdersLines.size()>0 ){
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, order)
                getOrder.orderStatus = OrderStatus.PARTIALLY_PLANNED
                getOrder.save(flush:true, failOnError:true)
            }
            else{
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, order)
                getOrder.orderStatus = OrderStatus.UNPLANNED
                getOrder.save(flush:true, failOnError:true)                
            }

        }
        allocationFailedMessageService.deleteAllocationFailedMsgByShipment(companyId, shipment.shipmentId)
        return orderNumberList
    }   



    def cancelShipmentLine(companyId, shipmentData){
//       def shipmentLine = ShipmentLine.findAllByCompanyIdAndShipmentIdAndShipmentLineId(companyId, shipmentData.shipmentId, shipmentData.shipmentLineId)
        def shipmentLine = ShipmentLine.findByCompanyIdAndShipmentLineId(companyId, shipmentData.shipmentLineId)
        def orderNumber = shipmentLine.orderNumber
        def orderLineNumber = shipmentLine.orderLineNumber
        def shipmentId = shipmentLine.shipmentId
        if (shipmentLine){
            def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, orderNumber, orderLineNumber)
            shipmentLine.delete(flush:true, failOnError:true)

            Integer orderLineQty = orderLine.orderedQuantity
            if(orderLine.kittingOrderQuantity && orderLine.kittingOrderQuantity > 0){
                orderLineQty = orderLineQty - orderLine.kittingOrderQuantity
                orderLine.kittingOrderQuantity = 0
                orderLine.save(flush:true, failOnError:true)
            }

            inventorySummaryService.updateDecreasedCommittedQuantity(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLineQty, orderLine.orderedUOM)

            def getShipmentLinesByShipment = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId,shipmentId)
            if (getShipmentLinesByShipment.size()==0) {
                def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
                getShipment.delete(flush:true, failOnError:true)
                allocationFailedMessageService.deleteAllocationFailedMsgByShipment(companyId, shipmentId)
            }

            orderLine.orderLineStatus = 'UNPLANNED'
            orderLine.save(flush:true, failOnError:true)
            //return true
            def getTotalNumberOfPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, orderNumber, 'PLANNED')
            def getTotalNumberOfOrderLinesByOrder = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderNumber)

            if (getTotalNumberOfOrderLinesByOrder.size() == getTotalNumberOfPlannedOrdersLines.size()) {
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
                getOrder.orderStatus = OrderStatus.PLANNED
                getOrder.save(flush:true, failOnError:true)
            }
            else if(getTotalNumberOfOrderLinesByOrder.size() > getTotalNumberOfPlannedOrdersLines.size() && getTotalNumberOfPlannedOrdersLines.size()>0 ){
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
                getOrder.orderStatus = OrderStatus.PARTIALLY_PLANNED
                getOrder.save(flush:true, failOnError:true)
            }
            else{
                def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
                getOrder.orderStatus = OrderStatus.UNPLANNED
                getOrder.save(flush:true, failOnError:true)                
            }


        }

    }


    def getShipmentStatusCount(companyId){
        def sqlQuery = "SELECT COUNT(*) total, "
        sqlQuery += "SUM(CASE WHEN shipment_status = '${ShipmentStatus.PLANNED}' THEN 1 ELSE 0 END) planned, "
        sqlQuery += "SUM(CASE WHEN shipment_status = '${ShipmentStatus.ALLOCATED}' THEN 1 ELSE 0 END) allocated, "
        sqlQuery += "SUM(CASE WHEN shipment_status = '${ShipmentStatus.KO_PROCESSING}' THEN 1 ELSE 0 END) ko_processing, "
        sqlQuery += "SUM(CASE WHEN shipment_status = '${ShipmentStatus.STAGED}' THEN 1 ELSE 0 END) staged, "
        sqlQuery += "SUM(CASE WHEN shipment_status = '${ShipmentStatus.COMPLETED}' THEN 1 ELSE 0 END) completed "
        sqlQuery += "FROM shipment "
        sqlQuery += " WHERE company_id = '${companyId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getShipmentByShipmentLine(companyId, shipmentLineId){
        def sqlQuery = "SELECT s.*,sl.* FROM shipment as s LEFT JOIN shipment_line as sl ON sl.shipment_id = s.shipment_id " +
                "WHERE s.company_id = '${companyId}' AND sl.shipment_line_id = '${shipmentLineId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }


    def priorDayInventoryShipped(String companyId){
        def sqlQuery = "SELECT sl.*, lv.description AS inventory_status_desc " +
                "FROM shipment_line AS sl " +
                "INNER JOIN shipment AS sh ON sh.shipment_id = sl.shipment_id AND sh.company_id = '${companyId}' " +
                "INNER JOIN order_line AS ol ON ol.order_line_number = sl.order_line_number AND ol.company_id = '${companyId}' " +
                "LEFT JOIN list_value as lv ON lv.option_value = ol.requested_inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
                "WHERE sl.company_id = '${companyId}' AND sh.completed_date >= CURDATE() - INTERVAL 1 DAY AND sh.completed_date < CURDATE()"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def assignWaveOrderLineToNewShipment(String companyId, String waveNumber, waveOrder, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber){
        def inventorySummaryUpdationDetails = null
        def committedOrderLines = []
        def orderLines = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, waveOrder.order_number)

        for(orderLine in orderLines){

            inventorySummaryUpdationDetails = inventorySummaryService.commitInventory(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedQuantity, orderLine.orderedUOM)


            if (!inventorySummaryUpdationDetails['committedResult']){
                for(committedOrderLine in committedOrderLines){
                    inventorySummaryService.unCommitInventory(companyId, committedOrderLine.itemId, committedOrderLine.requestedInventoryStatus, committedOrderLine.orderedQuantity, committedOrderLine.orderedUOM)
                }
                break
            }
            else
                committedOrderLines.push(orderLine)

        }


        if(inventorySummaryUpdationDetails['committedResult']){
            def shipment = new Shipment()

            def shipmentIdExist = Shipment.find("from Shipment as sh where sh.companyId='${companyId}' order by shipmentId DESC")

            if (!shipmentIdExist) {
                shipment.shipmentId = companyId.toUpperCase() + "-SH0000001"
            }
            else{
                def lastShipmentId = shipmentIdExist.shipmentId - (companyId.toUpperCase() + "-SH")
                def intIndex = lastShipmentId.toInteger() + 1
                def stringIndex = intIndex.toString().padLeft(7,"0")
                shipment.shipmentId = companyId.toUpperCase() + "-SH" + stringIndex
            }

            shipment.companyId = companyId
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


            shipment.shipmentStatus = ShipmentStatus.PLANNED
            shipment.trackingNo = trackingNo == "" ? null : trackingNo
            shipment.creationDate = new Date()
            shipment.stagingLocationId = null

            CustomerAddress customerAddress = CustomerAddress.find("from CustomerAddress as ca where ca.companyId = ? and ca.customerId = ? and ca.addressType = 'shipping' and ca.isDefault = true ", companyId, waveOrder.customer_id)
            shipment.shippingAddressId = customerAddress.id
            shipment.contactName = waveOrder.customer_id
            shipment.waveNumber = waveNumber
            shipment.save(flush: true, failOnError: true)

            if (truckNumber){
                trailerService.createTrailer(companyId, truckNumber, shipment.shipmentId)
            }

            for(orderLine in orderLines){
                saveShipmentLine(companyId, shipment.shipmentId, orderLine)
            }

        }
        orderService.updateWaveOrder(companyId, waveOrder.order_number, waveNumber)
        return inventorySummaryUpdationDetails

    }

    def getShipmentByOrderNumber(String companyId, String orderNumber){

        def sqlQuery = "SELECT distinct s.shipment_id "

        sqlQuery += "FROM shipment as s "
        sqlQuery += "INNER JOIN shipment_line as sl ON s.shipment_id = sl.shipment_id AND sl.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN orders as odr ON sl.order_number = odr.order_number AND odr.company_id = '${companyId}' "
        sqlQuery += "WHERE s.company_id = '${companyId}' "

        if(orderNumber){
            sqlQuery += " AND sl.order_number LIKE '${orderNumber}'"
        }

        sqlQuery += " ORDER BY s.shipment_id DESC"

        println("sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }


    def getPackoutShipmentContent(String companyId, String shipmentId){

        String sqlQuery = "SELECT sl.*, ol.order_line_number, ol.display_order_line_number, ord.notes AS order_notes, it.item_description, it.eaches_per_case, checkPackoutShipmentExist(sl.company_id, sl.shipment_line_id) AS pick_status "
        sqlQuery += "FROM shipment_line AS sl "
        sqlQuery += "INNER JOIN order_line as ol on sl.order_line_number = ol.order_line_number AND ol.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN orders as ord on sl.order_number = ord.order_number AND ord.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN item as it on sl.item_id = it.item_id AND it.company_id = '${companyId}' "
        sqlQuery += "WHERE sl.company_id = '${companyId}' AND sl.shipment_id = '${shipmentId}'"

        println("sqlQuery 123: " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }


    def getWaveShipments(String companyId, String waveNumber){
        return Shipment.findAllByCompanyIdAndWaveNumber(companyId, waveNumber)
    }




}
