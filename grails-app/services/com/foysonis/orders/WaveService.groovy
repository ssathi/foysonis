package com.foysonis.orders

import com.foysonis.inventory.InventorySummary
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.picking.PickLevel
import com.foysonis.picking.PickList
import com.foysonis.picking.PickListStatus
import com.foysonis.picking.PickWork
import com.foysonis.picking.PickWorkStatus
import groovy.sql.Sql
import grails.transaction.Transactional

@Transactional
class WaveService {

    def sessionFactory
    def inventorySummaryService
    def shipmentService
    def entityLastRecordService
    def orderService
    def allocationService
    def shippingService
    def printerService

    def searchOrderForWave(companyId, searchData) {

        def sqlQuery = "SELECT DISTINCT o.*, TotalUOMCountByOrderNumber('${companyId}', o.order_number) as total_no_Of_uom, "
        sqlQuery += "(SELECT COUNT(*) FROM order_line WHERE order_number = o.order_number AND company_id = '${companyId}') as total_order_lines, "
        sqlQuery += "getInvLevelIconSummaryForOrder('${companyId}', o.order_number) as available_inventory_status "
        sqlQuery += "from orders as o "
        sqlQuery += "INNER JOIN order_line as ol on o.order_number = ol.order_number and ol.company_id = '${companyId}' "
        sqlQuery += "WHERE o.company_id = '${companyId}' AND o.is_submitted = true AND o.order_status = 'UNPLANNED' AND ol.is_create_kitting_order = false "

        if (searchData.orderNumber) {
            def findOrderNumber = '%' + searchData.orderNumber + '%'
            sqlQuery = sqlQuery + " AND o.order_number LIKE '${findOrderNumber}' "
        }

        if (searchData.customerName) {
            sqlQuery = sqlQuery + " AND o.customer_id = '${searchData.customerName}' "
        }


        if (searchData.fromEarlyShipDate) {
            sqlQuery = sqlQuery + " AND o.early_ship_date >= '${searchData.fromEarlyShipDate}' "
        }


        if (searchData.toEarlyShipDate) {
            sqlQuery = sqlQuery + " AND o.early_ship_date <= '${searchData.toEarlyShipDate}' "
        }

        if (searchData.fromLateShipDate) {
            sqlQuery = sqlQuery + " AND o.late_ship_date >= '${searchData.fromLateShipDate}' "
        }


        if (searchData.toLateShipDate) {
            sqlQuery = sqlQuery + " AND o.late_ship_date <= '${searchData.toLateShipDate}' "
        }

        if (searchData.requestedShipSpeed) {
            sqlQuery = sqlQuery + " AND o.requested_ship_speed = '${searchData.requestedShipSpeed}' "
        }
        sqlQuery = sqlQuery + "ORDER BY o.created_date DESC "

        if (searchData.maxOrderNum) {
            def limitAmt = searchData.maxOrderNum.toInteger()
            sqlQuery = sqlQuery + " LIMIT ${limitAmt}"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }

    def planWave(String companyId, waveOrders) {

        String waveErrorMessage = null
        def orderLines = null
        def waveErrrorsMap = []
        Boolean wavePlanSuccess = true

        String waveNumber = createWave(companyId).waveNumber

        for (waveOrder in waveOrders) {

            waveErrorMessage = null

            // Check the order status
            if (waveOrder.order_status == OrderStatus.UNPLANNED) {

                def shipmentPlanDetails = shipmentService.assignWaveOrderLineToNewShipment(companyId, waveNumber, waveOrder, null, false, null, null, null)

                if (shipmentPlanDetails['committedResult'] != true) {
                    waveErrorMessage = shipmentPlanDetails['error']
                    wavePlanSuccess = false
                }

            } else {
                waveErrorMessage = "The order : " + waveOrder.order_number + " is already planned / partially planned."
                wavePlanSuccess = false
            }

            if (waveErrorMessage != null) {
                def map = [wavePlanSuccess: wavePlanSuccess,
                           message        : waveErrorMessage]
                waveErrrorsMap.add(map)
            }
        }

        String planWaveNotifyMessage = null
        Boolean wavePlanResult = null

        if (waveErrrorsMap.find { it.wavePlanSuccess == false }) {

            // RollBack Plan Wave
            cancelWave(companyId, waveNumber)
            wavePlanResult = false
            planWaveNotifyMessage = waveErrrorsMap.collect { map -> map.message }.join(", ")
        } else {

            wavePlanResult = true
            planWaveNotifyMessage = "Wave Planning Succeed"
        }

        return [wavePlanResult: wavePlanResult, message: planWaveNotifyMessage, waveNumber: waveNumber]


    }

    def createWave(String companyId) {

        def intIndex = entityLastRecordService.getLastRecordId(companyId, "WAVING").lastRecordId
        String stringIndex = intIndex.toString().padLeft(6, "0")
        String waveNumber = companyId + stringIndex

        Wave wave = new Wave()
        wave.companyId = companyId
        wave.waveNumber = waveNumber
        wave.createdDate = new Date()
        wave.waveStatus = WaveStatus.PLANNED
        wave.save(flush: true, failOnError: true)
        return wave

    }

    def cancelWave(String companyId, String waveNumber) {

        def waveShipments = Shipment.findAllByCompanyIdAndWaveNumber(companyId, waveNumber)
        def waveOrders = Orders.findAllByCompanyIdAndWaveNumber(companyId, waveNumber)

        // Cancel Wave shipment
        for (shipment in waveShipments) {
            shipmentService.cancelShipment(companyId, shipment)
        }

        // Cancel Wave Orders
        for (waveOrder in waveOrders) {
            waveOrder.waveNumber = null
            waveOrder.orderStatus = OrderStatus.UNPLANNED
            waveOrder.save(flush: true, failOnError: true)
        }

        // Delete Wave
        Wave wave = Wave.findByCompanyIdAndWaveNumber(companyId, waveNumber)
        wave.delete(flush: true, failOnError: true)
        return [code: "success"]
    }

    def getAllWaveNumbers(String companyId, searchData) {
        //return Shipment.findAll("from Shipment as sh WHERE sh.companyId = '${companyId}' AND sh.waveNumber is not null group by sh.waveNumber")
        def sqlQuery = "SELECT * FROM wave as wa WHERE wa.company_id = '${companyId}' AND wa.wave_number is not null "

        if (searchData.waveNumber) {
            def findWaveNumber = '%' + searchData.waveNumber + '%'
            sqlQuery = sqlQuery + " AND wa.wave_number LIKE '${findWaveNumber}' "
        }

        if (searchData.waveStatus) {
            sqlQuery = sqlQuery + " AND wa.wave_status = '${searchData.waveStatus}' "
        }

        sqlQuery = sqlQuery + "group by wa.wave_number order by wa.wave_number desc"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)


    }

    def getAllOrdersDataByWaveNumbers(String companyId, String waveNumber) {
        def sqlQuery = "SELECT DISTINCT o.*, cus.contact_name AS customer_name, TotalUOMCountByOrderNumber('${companyId}', o.order_number) as total_no_Of_uom, "
        sqlQuery += "(SELECT COUNT(*) FROM order_line WHERE order_number = o.order_number AND company_id = '${companyId}') as total_order_lines "
        sqlQuery += "from orders as o "
        sqlQuery += "INNER JOIN order_line as ol on o.order_number = ol.order_number and ol.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN customer as cus on cus.customer_id = o.customer_id and cus.company_id = '${companyId}' "
        sqlQuery += "WHERE o.company_id = '${companyId}' AND o.wave_number = ${waveNumber} "
        sqlQuery += "ORDER BY o.created_date DESC "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def getAllShipmentAndLinesCountData(String companyId, String waveNumber) {
        def sqlQuery = "SELECT COUNT(DISTINCT sh.shipment_id) as total_shipment_count, COUNT(sl.shipment_line_id) AS total_shipment_line_count FROM shipment AS sh INNER JOIN shipment_line AS sl ON sl.shipment_id = sh.shipment_id AND sl.company_id = '${companyId}' WHERE sh.company_id = '${companyId}' AND sh.wave_number = '${waveNumber}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows[0]
    }

    def prepareWaveAllocation(companyId, destinationLocation, updatedUser, Wave wave, Integer picksPerList, String pickTicketPrintOption) {

        def allocation = [:]
        def shipments = Shipment.findAllByCompanyIdAndWaveNumber(companyId, wave.waveNumber)

        wave.picksPerList = picksPerList
        wave.pickTicketPrintOption = pickTicketPrintOption
        wave.save(flush: true, failOnError: true)

        //RE ALLOCATE
        if (wave.waveStatus == WaveStatus.ALLOCATED) {
            //Remove Pick Works
            def pickWorks = PickWork.findAllByCompanyIdAndWaveNumber(companyId, wave.waveNumber)
            String pickListId = null

            if (pickWorks.size() > 0) {
                for (pickWork in pickWorks) {
                    pickListId = pickWork.pickListId
                    pickWork.delete(flush: true, failOnError: true)

                    //Delete Pick List
                    if (pickListId) {
                        def listPickWorks = PickWork.findAllByCompanyIdAndPickListId(companyId, pickListId)
                        if (listPickWorks.size() == 0) {
                            PickList pickList = PickList.findByCompanyIdAndPickListId(companyId, pickListId)
                            pickList.delete(flush: true, failOnError: true)
                        }

                    }

                }
            }

            //Change Shipment's Status
            for (shipment in shipments) {
                shipment.shipmentStatus = ShipmentStatus.PLANNED
                shipment.save(flush: true, failOnError: true)
            }
        }

        for (shipment in shipments) {

            if (shipment.shipmentStatus == ShipmentStatus.PLANNED)
                allocationService.prepareAllocation(companyId, shipment.shipmentId, destinationLocation, updatedUser, wave.waveNumber)

        }

        def allocatedShipments = Shipment.findAllByCompanyIdAndWaveNumberAndShipmentStatus(companyId, wave.waveNumber, ShipmentStatus.ALLOCATED)
        def plannedShipments = Shipment.findAllByCompanyIdAndWaveNumberAndShipmentStatus(companyId, wave.waveNumber, ShipmentStatus.PLANNED)

        if (allocatedShipments.size() > 0 && plannedShipments.size() > 0) {
            wave.waveStatus = WaveStatus.PARTIALLY_ALLOCATED
            allocation.status = true
            allocation.confirmationMessage = "This wave has been partially allocated"
        } else if (allocatedShipments.size() > 0 && plannedShipments.size() == 0) {
            wave.waveStatus = WaveStatus.ALLOCATED
            allocation.status = true
            allocation.confirmationMessage = "This wave has been successfully allocated"
        } else {
            allocation.status = false
            allocation.confirmationMessage = "This wave has not been allocated"
        }
        wave.save(flush: true, failOnError: true)
        return allocation

    }

    def getAllOrdersDataForViewDetails(String companyId, String waveNumber) {
        def sqlQuery = "SELECT DISTINCT o.*, sh.shipment_id, TotalUOMCountByOrderNumber('${companyId}', o.order_number) as total_no_Of_uom, "
        sqlQuery += "(SELECT COUNT(*) FROM order_line WHERE order_number = o.order_number AND company_id = '${companyId}') as total_order_lines, "
        sqlQuery += "getInvLevelIconSummaryForOrder('${companyId}', o.order_number) as available_inventory_status, "
        sqlQuery += "(CASE WHEN sh.shipment_status = 'PLANNED' THEN 'NO' ELSE 'YES' END) AS allocation_status, afm.message as allocation_failed_message "
        sqlQuery += "from orders as o "
        sqlQuery += "INNER JOIN order_line as ol on o.order_number = ol.order_number and ol.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN shipment_line as shl on shl.order_number = ol.order_number and shl.company_id = '${companyId}' "
        sqlQuery += "INNER JOIN shipment as sh on sh.shipment_id = shl.shipment_id and sh.company_id = '${companyId}' "
        sqlQuery += "LEFT JOIN allocation_failed_message AS afm ON sh.shipment_id = afm.shipment_id AND afm.company_id = '${companyId}' "
        sqlQuery += "WHERE o.company_id = '${companyId}' AND o.wave_number = ${waveNumber} "
        sqlQuery += "GROUP BY o.order_number ORDER BY o.created_date DESC "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def getPackOutShipment(String companyId, String searchText) {
        String resultMessage = null
        Shipment shipment = null

        // Pick Reference
        PickWork pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, searchText)
        if (pickWork) {
            shipment = Shipment.findByCompanyIdAndShipmentId(companyId, pickWork.shipmentId)
        }

        // Order Number
        if (shipment == null) {
            def shipmentRows = shipmentService.getShipmentByOrderNumber(companyId, searchText)
            if (shipmentRows && shipmentRows.size() > 0) {
                shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentRows[0].shipment_id)
            }

        }

        // Shipment ID
        if (shipment == null) {
            shipment = Shipment.findByCompanyIdAndShipmentId(companyId, searchText)
        }

        // TODO Pick-To Carton ID or Pallet ID

        if (shipment) {
            if (shipment.shipmentStatus == ShipmentStatus.COMPLETED) {
                resultMessage = "Shipment is already Completed"
            } else if (shipment.waveNumber == null || shipment.waveNumber == "") {
                resultMessage = "This shipment is not part of a wave"
                shipment = null
            }

        } else
            resultMessage = "No Uncomplete Shipment Found"

        return [resultMessage: resultMessage, shipment: shipment]

    }

    def displayPackoutConfirm(String companyId, String shipmentLineId) {
        Boolean displayConfirm = false

        def pickWorks = PickWork.findAllByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        if (pickWorks) {
            Integer completedPickQuantity = 0
            for (pickWork in pickWorks) {
                completedPickQuantity += pickWork.completedQuantity
            }

            ShipmentLine shipmentLine = ShipmentLine.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
            if (shipmentLine.shippedQuantity == completedPickQuantity)
                displayConfirm = true
        }

        PackoutShipment packoutShipment = PackoutShipment.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        if (packoutShipment)
            displayConfirm = false

        return [results: displayConfirm]

    }

    def displayPackoutUnconfirm(String companyId, String shipmentLineId) {
        Boolean displayUnconfirm = false

        PackoutShipment packoutShipment = PackoutShipment.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        if (packoutShipment)
            displayUnconfirm = true

        return [results: displayUnconfirm]

    }

    def confirmShipmentLine(String companyId, String username, String shipmentLineId, String shipmentContainerId) {

        ShipmentLine shipmentLine = ShipmentLine.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        Shipment shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentLine.shipmentId)

        PackoutShipment packoutShipment = new PackoutShipment()
        packoutShipment.companyId = companyId
        packoutShipment.waveNumber = shipment.waveNumber
        packoutShipment.shipmentId = shipmentLine.shipmentId
        packoutShipment.shipmentLineId = shipmentLine.shipmentLineId
        packoutShipment.shipmentContainerId = shipmentContainerId
        packoutShipment.confirmedQuantity = shipmentLine.shippedQuantity
        packoutShipment.createdDate = new Date()
        packoutShipment.save(flush: true, failOnError: true)
        println("created packoutShipment")

        InventoryEntityAttribute inventoryEntityAttribute = null
        inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, shipmentContainerId)

        if (!inventoryEntityAttribute) {
            inventoryEntityAttribute = new InventoryEntityAttribute()
            inventoryEntityAttribute.companyId = companyId
            inventoryEntityAttribute.lPN = shipmentContainerId
            inventoryEntityAttribute.level = "CASE"
            inventoryEntityAttribute.locationId = shipment.stagingLocationId
            inventoryEntityAttribute.parentLpn = null
            inventoryEntityAttribute.lastModifiedDate = new Date()
            inventoryEntityAttribute.createdDate = new Date()
            inventoryEntityAttribute.lastModifiedUserId = username
            inventoryEntityAttribute.save(flush: true, failOnError: true)
            println("created inventoryEntityAttribute")
        }


        def pickWorks = PickWork.findAllByCompanyIdAndShipmentLineId(companyId, shipmentLineId)

        if (pickWorks) {

            for (pickWork in pickWorks) {

                def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, pickWork.workReferenceNumber)

                if (inventories) {

                    for (inventory in inventories) {

                        inventory.associatedLpn = shipmentContainerId
                        inventory.locationId = null
                        inventory.save(flush: true, failOnError: true)

                    }
                }
            }
        }

        return [code: "success"]

    }


    def unConfirmShipmentLine(String companyId, String shipmentLineId) {

        ShipmentLine shipmentLine = ShipmentLine.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        Shipment shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentLine.shipmentId)
        String shipmentContainerId = null

        PackoutShipment packoutShipment = PackoutShipment.findByCompanyIdAndShipmentLineId(companyId, shipmentLineId)
        if (packoutShipment) {
            shipmentContainerId = packoutShipment.shipmentContainerId
            packoutShipment.delete(flush: true, failOnError: true)
        }



        def pickWorks = PickWork.findAllByCompanyIdAndShipmentLineId(companyId, shipmentLineId)

        if (pickWorks) {

            for (pickWork in pickWorks) {

                def inventories = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, pickWork.workReferenceNumber)

                if (inventories) {

                    for (inventory in inventories) {

                        inventory.associatedLpn = null
                        inventory.locationId = shipment.stagingLocationId
                        inventory.save(flush: true, failOnError: true)

                    }
                }
            }
        }

        Inventory inventory = Inventory.findByCompanyIdAndAssociatedLpn(companyId, shipmentContainerId)

        if (!inventory) {
            InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, shipmentContainerId)
            inventoryEntityAttribute.delete(flush: true, failOnError: true)
            println("deleted inventoryEntityAttribute")
        }

        return [code: "success"]

    }


    def closeoutShipment(String companyId, String shipmentId, String orderNumber, String carrierCode, String serviceLevel, String trackingNumber) {

        Shipment shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
        shipment.carrierCode = carrierCode
        shipment.serviceLevel = serviceLevel
        shipment.trackingNo = trackingNumber
        shipment.save(flush: true, failOnError: true)
        shippingService.completeShipment(companyId, shipmentId, null, orderNumber, null)
        return completeWave(companyId, shipment.waveNumber)
    }


    def confirmAllShipmentLines(String companyId, String username, String shipmentId, String shipmentContainerId) {
        def shipmentLines = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, shipmentId)

        for (shipmentLine in shipmentLines) {
            def pickReady = displayPackoutConfirm(companyId, shipmentLine.shipmentLineId)
            if (pickReady.results == true) {
                println("shipmentLine.shipmentLineId" + shipmentLine.shipmentLineId)
                confirmShipmentLine(companyId, username, shipmentLine.shipmentLineId, shipmentContainerId)
            }

        }
        return [code: "success"]

    }

    def checkValidContainerId(String companyId, String shipmentContainerId, String shipmentId) {
        Boolean isValidContainerId = false

        Inventory inventory = Inventory.findByCompanyIdAndAssociatedLpn(companyId, shipmentContainerId)

        if (inventory) {
            if (inventory.workReferenceNumber) {
                PickWork pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(inventory.workReferenceNumber)
                if (pickWork && pickWork.shipmentId == shipmentId) {
                    isValidContainerId = true
                }
            }
        } else {
            isValidContainerId = true
        }


        return [results: isValidContainerId]

    }

    def removeOrderFromWave(String companyId, String orderNumber) {
        Orders waveOrder = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
        String waveNumber = waveOrder.waveNumber
        Boolean isRemovedOrder = false
        Boolean isCancelWave = false

        if (waveOrder) {

            // Delete Wave shipment
            def waveShipmentLines = ShipmentLine.findAllByCompanyIdAndOrderNumber(companyId, orderNumber)
            if (waveShipmentLines.size() > 0) {
                def waveShipment = Shipment.findByCompanyIdAndShipmentId(companyId, waveShipmentLines[0].shipmentId)

                // Delete Pick Work
                if (waveShipment.shipmentStatus == ShipmentStatus.ALLOCATED) {
                    def pickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, waveShipment.shipmentId)
                    String pickListId = null

                    if (pickWorks.size() > 0) {
                        for (pickWork in pickWorks) {
                            pickListId = pickWork.pickListId
                            pickWork.delete(flush: true, failOnError: true)

                            //Delete Pick List
                            if (pickListId) {
                                def listPickWorks = PickWork.findAllByCompanyIdAndPickListId(companyId, pickListId)
                                if (listPickWorks.size() == 0) {
                                    PickList pickList = PickList.findByCompanyIdAndPickListId(companyId, pickListId)
                                    pickList.delete(flush: true, failOnError: true)
                                }

                            }

                        }
                    }

                }

                shipmentService.cancelShipment(companyId, waveShipment)


            }

            waveOrder.waveNumber = null
            waveOrder.save(flush: true, failOnError: true)
            isRemovedOrder = true

            // Delete Wave
            def waveOrders = Orders.findAllByCompanyIdAndWaveNumber(companyId, waveNumber)
            if (waveOrders.size() == 0) {
                Wave wave = Wave.findByCompanyIdAndWaveNumber(companyId, waveNumber)
                wave.delete(flush: true, failOnError: true)
                isCancelWave = true
            }

        }

        return [orderRemoved: isRemovedOrder, waveCanceled: isCancelWave]
    }

    def searchOrderForEditWave(companyId, waveNumber) {
        def sqlQuery = "SELECT DISTINCT o.*, TotalUOMCountByOrderNumber('${companyId}', o.order_number) as total_no_Of_uom, "
        sqlQuery += "(SELECT COUNT(*) FROM order_line WHERE order_number = o.order_number AND company_id = '${companyId}') as total_order_lines, "
        sqlQuery += "getInvLevelIconSummaryForOrder('${companyId}', o.order_number) as available_inventory_status "
        sqlQuery += "from orders as o "
        sqlQuery += "INNER JOIN order_line as ol on o.order_number = ol.order_number and ol.company_id = '${companyId}' "
        sqlQuery += "WHERE o.company_id = '${companyId}' AND o.wave_number = '${waveNumber}'"

        sqlQuery = sqlQuery + "ORDER BY o.created_date DESC "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows


    }

    def completeWave(String companyId, String waveNumber) {

        def unCompletedShipments = Shipment.findAllByCompanyIdAndWaveNumberAndShipmentStatusNotEqual(companyId, waveNumber, ShipmentStatus.COMPLETED)
        Wave wave = Wave.findByCompanyIdAndWaveNumber(companyId, waveNumber)

        if (unCompletedShipments.size() == 0) {
            wave.waveStatus = WaveStatus.COMPLETED
            wave.save(flush: true, failOnError: true)
        }
        return wave

    }

    def checkPackoutShipmentExist(String companyId, String shipmentId) {
        def packoutShipmentExistStrng = null
        def packoutShipmentData = PackoutShipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
        if (packoutShipmentData) {
            packoutShipmentExistStrng = 'COMPLETED'
        } else {
            def pickListData = PickWork.findByCompanyIdAndShipmentId(companyId, shipmentId)
            if (pickListData) {
                def unCompletedPickWork = PickWork.findByCompanyIdAndShipmentIdAndPickStatusNotEqual(companyId, shipmentId, com.foysonis.picking.PickWorkStatus.COMPLETED)
                if (unCompletedPickWork) {
                    packoutShipmentExistStrng = 'PENDING'
                } else {
                    packoutShipmentExistStrng = 'READY'
                }
            } else {
                packoutShipmentExistStrng = 'PENDING'
            }
        }
        return [status: packoutShipmentExistStrng]
    }

    def changeWaveStatusForPicking(String companyId, String waveNumber) {

        Wave wave = Wave.findByCompanyIdAndWaveNumber(companyId, waveNumber)

        if (wave.waveStatus == WaveStatus.ALLOCATED || wave.waveStatus == WaveStatus.PARTIALLY_PICKED) {

            def unCompletedPickWorks = PickWork.findAllByCompanyIdAndWaveNumberAndPickStatusNotEqual(companyId, waveNumber, PickWorkStatus.COMPLETED)
            if (unCompletedPickWorks.size() > 0) {
                wave.waveStatus = WaveStatus.PARTIALLY_PICKED

            } else {
                wave.waveStatus = WaveStatus.FULLY_PICKED
            }
        }

        wave.save(flush: true, failOnError: true)
        return wave

    }

//    def printShippingLabel(String companyId, String orderNumber, String shipmentId, String printerName) {

    def printShippingLabel(String companyId, String printerName, String shipmentId, String printOption) {

        printerService.setPrinter(printerName)

        def pickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        String zplCode = ""
        List<String> zplCodes = new ArrayList<String>()

        for(pickWork in pickWorks){
            if(printOption == PickTicketPrintOption.PICK){
                zplCode = printerService.printZPLPerPick(companyId, pickWork)
            }
            else if(printOption == PickTicketPrintOption.UNIT){

                for (int i = 0; i <pickWork.pickQuantity; i++) {
                    zplCode = printerService.printZPLPerUnit(companyId, pickWork)
                }
            }

            zplCodes.add(zplCode)
        }

        return [zplCodes: zplCodes]

    }

}