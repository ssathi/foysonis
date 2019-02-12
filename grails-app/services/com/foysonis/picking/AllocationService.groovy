package com.foysonis.picking

import com.foysonis.area.AreaPickLevel
import com.foysonis.area.Location
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.item.EntityAttribute
import com.foysonis.item.HandlingUom
import com.foysonis.kitting.BillMaterial
import com.foysonis.kitting.KittingOrderStatus
import com.foysonis.kitting.KittingOrderType
import com.foysonis.orders.ShipmentStatus
import com.foysonis.util.FoysonisLogger
import grails.transaction.Transactional
import com.foysonis.orders.ShipmentLine
import com.foysonis.orders.Shipment
import com.foysonis.orders.OrderLine
import com.foysonis.item.Item
import com.foysonis.area.AreaService
import com.foysonis.area.Area
import com.foysonis.area.LocationService
import groovy.sql.Sql
import com.foysonis.kitting.KittingOrderComponent
import com.foysonis.kitting.KittingOrder

@Transactional
class AllocationService {
    def sessionFactory
    def areaService
    def allocationFailedMessageService
    def locationService
    def inventorySummaryService
    def kittingOrderService
    def inventoryService
    def pickingService

    FoysonisLogger logger = FoysonisLogger.getLogger(AllocationService.class);


    def getAllPalletPicksByShipment(companyId, shipmentId) {
        def sqlQuery = "SELECT * FROM pick_work as pw INNER JOIN shipment_line as sl ON pw.shipment_line_id = sl.shipment_line_id AND sl.company_id = '${companyId}' WHERE pw.company_id = '${companyId}' AND pw.shipment_id = '${shipmentId}' AND pw.pick_level = '${PickLevel.PALLET}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }


    def getAllPickListDataByShipment(companyId, shipmentId) {

        def sqlQuery = "SELECT * FROM pick_work as pw INNER JOIN pick_list as pl ON pl.pick_list_id = pw.pick_list_id WHERE pw.company_id = '${companyId}' AND pw.shipment_id = '${shipmentId}' GROUP BY pl.pick_list_id;"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }


    def getPickWorkData(companyId, pickListId) {

        def sqlQuery = "SELECT pw.destination_area_id, pw.destination_location_id, pw.source_location_id, pw.order_number, pw.order_line_number, pw.shipment_line_id, sl.item_id, pw.pick_quantity, pw.pick_quantity_uom FROM pick_work as pw INNER JOIN shipment_line as sl ON pw.shipment_line_id = sl.shipment_line_id AND sl.company_id = '${companyId}' WHERE pw.company_id = '${companyId}' AND pw.pick_list_id = '${pickListId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }

    def getAllShipmentLinesByShipmentId(companyId, shipmentId) {
        return ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def getSelectedShipmentDataByShipmentId(companyId, shipmentId) {
        return Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def getReplenishmentWorkDataByShipment(shipmentId, companyId) {

        def sqlQuery = "SELECT * FROM pick_work as pw INNER JOIN replen_demand as rd on pw.work_reference_number = rd.work_reference_number INNER JOIN replen_work as rw ON rw.replen_reference = rd.replen_reference WHERE rd.company_id = '${companyId}' AND rw.company_id = '${companyId}' AND pw.company_id = '${companyId}' AND pw.shipment_id = '${shipmentId}' GROUP BY rd.replen_reference ;"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }


    def getPickWorkDataByReplenWork(replenReference, companyId) {

        def sqlQuery = "SELECT * FROM pick_work as pw INNER JOIN replen_demand as rd on pw.work_reference_number = rd.work_reference_number INNER JOIN replen_work as rw ON rw.replen_reference = rd.replen_reference WHERE rd.company_id = '${companyId}' AND rw.company_id = '${companyId}' AND pw.company_id = '${companyId}' AND rd.replen_reference = '${replenReference}'  GROUP BY rd.work_reference_number ;"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }

    def checkCompletedPicks(companyId, shipmentId) {

        return PickWork.findAllByCompanyIdAndShipmentIdAndPickStatus(companyId, shipmentId, PickWorkStatus.COMPLETED)
    }

    def cancelAllocation(companyId, shipmentId, orderNumber) {

        def getPickListId = []
        def getWorkReferenceId = []
        def getReplenReference = []

        def shipmentLineData = ShipmentLine.findAllByCompanyIdAndShipmentIdAndOrderNumber(companyId, shipmentId, orderNumber)
        if (shipmentLineData.size() > 0) {

            for (shipmentLine in shipmentLineData) {
                def pickWork = PickWork.findAllByCompanyIdAndShipmentIdAndShipmentLineIdAndOrderNumber(companyId, shipmentId, shipmentLine.shipmentLineId, orderNumber)
                if (pickWork.size() > 0) {

                    for (pickWorkData in pickWork) {
                        if (pickWorkData) {
                            getPickListId.add(pickWorkData.pickListId)
                            getWorkReferenceId.add(pickWorkData.workReferenceNumber)

                            def cancelledPick = new CancelledPick()

                            cancelledPick.properties = [
                                    companyId            : companyId,
                                    workReferenceNumber  : pickWorkData.workReferenceNumber,
                                    shipmentId           : pickWorkData.shipmentId,
                                    shipmentLineId       : pickWorkData.shipmentLineId,
                                    orderNumber          : pickWorkData.orderNumber,
                                    orderLineNumber      : pickWorkData.orderLineNumber,
                                    pickQuantity         : pickWorkData.pickQuantity,
                                    pickQuantityUom      : pickWorkData.pickQuantityUom,
                                    completedQuantity    : pickWorkData.completedQuantity,
                                    pickStatus           : pickWorkData.pickStatus,
                                    sourceLocationId     : pickWorkData.sourceLocationId,
                                    destinationLocationId: pickWorkData.destinationLocationId,
                                    destinationAreaId    : pickWorkData.destinationAreaId,
                                    pickCreationDate     : pickWorkData.pickCreationDate,
                                    lastUpdateDate       : pickWorkData.lastUpdateDate,
                                    lastUpdateUsername   : pickWorkData.lastUpdateUsername,
                                    pickListId           : pickWorkData.pickListId,
                                    pickSequence         : pickWorkData.pickSequence,
                                    palletLpn            : pickWorkData.palletLpn
                            ]

                            cancelledPick.save(flush: true, failOnError: true)

                            pickWorkData.delete(flush: true, failOnError: true)
                        }

                    }//end for

                    for (pickListId in getPickListId) {
                        def pickList = PickList.findByCompanyIdAndPickListId(companyId, pickListId)
                        if (pickList) {
                            pickList.delete(flush: true, failOnError: true)
                        }

                    }//end for

                }//end if

                if (getWorkReferenceId.size() > 0) {

                    for (referenceId in getWorkReferenceId) {
                        def replenDemand = ReplenDemand.findAllByCompanyIdAndWorkReferenceNumberAndItemId(companyId, referenceId, shipmentLine.itemId)
                        if (replenDemand.size() > 0) {
                            for (replenDemandData in replenDemand) {
                                getReplenReference.add(replenDemandData.replenReference)
                                replenDemandData.demandStatus = 'E'
                                replenDemandData.save(flush: true, failOnError: true)
                            }

                        }
                    }//end for

                }//end if

                if (getReplenReference.size() > 0) {

                    for (replenRef in getReplenReference) {
                        def getAllReplenDemand = ReplenDemand.findAll("from ReplenDemand where companyId = '${companyId}' AND replenReference = '${replenRef}' AND demandStatus != 'E'")
                        if (getAllReplenDemand.size() == 0) {
                            def replenWork = ReplenWork.find("from ReplenWork where companyId = '${companyId}' AND replenReference = '${replenRef}' AND itemId = '${shipmentLine.itemId}' AND  replenWorkStatus != 'COMPLETE'")
                            if (replenWork) {
                                replenWork.replenWorkStatus = 'CANCEL'
                                replenWork.save(flush: true, failOnError: true)
                            }

                        }
                    }

                }//end if


                return true
            }//end for


        }//end if


    }


    def searchShipment(searchData) {

        def sqlQuery = "SELECT * FROM shipment as sh INNER JOIN shipment_line as sl ON sh.shipment_id = sl.shipment_id WHERE sh.company_id = '${searchData.companyId}' AND sl.company_id = '${searchData.companyId}'"

        if (searchData.shipmentId) {
            //def findShipmentId = '%'+shipmentId+'%'
            sqlQuery = sqlQuery + " AND sh.shipment_id LIKE '${searchData.shipmentId}'"
        }

        if (searchData.orderNumber) {
            sqlQuery = sqlQuery + " AND sl.order_number LIKE '${searchData.orderNumber}'"
        }


        if (searchData.allocationStatus) {
            if (searchData.allocationStatus == 'ALLOCATED') {
                sqlQuery = sqlQuery + " AND sh.shipment_status = '${searchData.allocationStatus}'"
            } else {
                sqlQuery = sqlQuery + " AND sh.shipment_status != '${ShipmentStatus.ALLOCATED}' AND sh.shipment_status != '${ShipmentStatus.COMPLETED}'"
            }

        }

        if (searchData.fromShipmentCreation) {
            sqlQuery = sqlQuery + " AND sh.creation_date >= '${searchData.fromShipmentCreation}'"
        }


        if (searchData.toShipmentCreation) {
            sqlQuery = sqlQuery + " AND sh.creation_date <= '${searchData.toShipmentCreation}'"
        }

        if (!searchData.completedShipment) {
            sqlQuery = sqlQuery + " AND sh.shipment_status != '${ShipmentStatus.COMPLETED}'"
        }

        sqlQuery = sqlQuery + " GROUP BY sh.shipment_id;"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }

    //(pallet pick & Replens)

    def findPalletPick(companyId) {
        return PickWork.findAll("FROM PickWork WHERE companyId = '${companyId}' AND pickLevel = '${PickLevel.PALLET}' AND pickStatus != '${PickWorkStatus.COMPLETED}' ORDER BY workReferenceNumber ASC")
    }

    def findCompletedPalletPick(companyId) {
        return PickWork.findAllByCompanyIdAndPickLevelAndPickStatus(companyId, 'P', 'Pick Completed')
    }

    def findReplenishment(companyId) {
        return ReplenWork.findAllByCompanyIdAndReplenWorkStatus(companyId, 'A')
    }

    def findCompletedAndExpiredReplenishment(companyId) {
        return ReplenWork.findAll("FROM ReplenWork WHERE companyId = '${companyId}' AND replenWorkStatus != 'A' ORDER BY replenReference ASC")
    }

    def findCompletedReplenishment(companyId) {
        return ReplenWork.findAllByCompanyIdAndReplenWorkStatus(companyId, 'S')
    }

    def findExpiredReplenishment(companyId) {
        return ReplenWork.findAllByCompanyIdAndReplenWorkStatus(companyId, 'E')
    }

    def findPickWorks(companyId, selectedRowPick) {
        def sqlQuery = "SELECT * FROM replen_demand as rd INNER JOIN replen_work as rw ON rd.replen_reference = rw.replen_reference INNER JOIN pick_work as pw ON rd.work_reference_number = pw.work_reference_number WHERE rw.company_id = '${companyId}' AND rw.replen_reference = '${selectedRowPick}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def masterAllocationValidate(companyId, itemId, inventoryStatus) {
        def errorMessage = null

        //Check Inventory Available
        errorMessage = inventoryService.checkInventoryUnavailable(companyId, itemId, inventoryStatus)

        //Check Pickable Area Available
        errorMessage = errorMessage ? errorMessage : areaService.checkPickableAreaUnavailable(companyId)

        //Check Location Available
        errorMessage = errorMessage ? errorMessage : locationService.checkLocationUnavailable(companyId)

        return errorMessage

    }

    def masterAllocationValidateForTriggered(companyId, itemId, inventoryStatus) {
        def errorMessage = null

        //Check Pickable Area Available
        errorMessage = errorMessage ? errorMessage : areaService.checkPickableAreaUnavailable(companyId)

        //Check Location Available
        errorMessage = errorMessage ? errorMessage : locationService.checkLocationUnavailable(companyId)

        return errorMessage

    }

    def validateAllocation(companyId, locationId, areaPickLevel) {
        def errorMessage = null

        //Check Location Blocked
        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)
        if (location.isBlocked == true)
            errorMessage = "There are no unblocked locations for this item. The shipment line needs items to be in unblocked location"

        //Check Area Pickable
        def area = Area.findByCompanyIdAndAreaId(companyId, location.areaId)
        if (area.isPickable == false)
            errorMessage = "There are no areas that can be pickable for this item. The shipment line needs items to be in pickable area"

        //Check Area Pick Level
        def entityAttribute = EntityAttribute.findByCompanyIdAndEntityIdAndConfigKeyAndConfigGroupAndConfigValue(companyId, 'AREAS', area.areaId, 'PICKLEVEL', areaPickLevel)
        if (entityAttribute == null) {
            errorMessage = "There are no areas that allow " + areaPickLevel + " picks for this item. The shipment line needs items to be picked in " + areaPickLevel
        }

        return errorMessage

    }


    def prepareAllocation(companyId, shipmentId, destinationLocation, updatedUser, String waveNumber) {

        def shipmentLines = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        def allocationSucceed = true
        def allocationMessage = null
        def allocationMap = []


        String itemIdForPalletGroup = null
        String invStatusForPalletGroup = null
        String uomForPalletGroup = null
        String caseIdForPalletGroup = null
        String palletIdForGroup = null
        Boolean isAllocatePallet = false
        OrderLine orderLineForPalletGroup = null

        for (shipmentLine in shipmentLines) {

            orderLineForPalletGroup = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, shipmentLine.orderLineNumber)

            if (itemIdForPalletGroup == null) {
                itemIdForPalletGroup = orderLineForPalletGroup.itemId
            } else if (itemIdForPalletGroup != orderLineForPalletGroup.itemId) {
                break
            }

            if (invStatusForPalletGroup == null) {
                invStatusForPalletGroup = orderLineForPalletGroup.requestedInventoryStatus
            } else if (invStatusForPalletGroup != orderLineForPalletGroup.requestedInventoryStatus) {
                break
            }

            if (uomForPalletGroup == null) {
                uomForPalletGroup = orderLineForPalletGroup.orderedUOM
            } else if (uomForPalletGroup != orderLineForPalletGroup.orderedUOM) {
                break
            }

            AllocationRule allocationRule = AllocationRule.findByCompanyIdAndOrderLineNumberAndAttributeName(companyId, orderLineForPalletGroup.orderLineNumber, AllocationAttribute.LPN)
            if (allocationRule) {
                caseIdForPalletGroup = allocationRule.attributeValue
                InventoryEntityAttribute ieaForPallet = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, caseIdForPalletGroup)

                if (ieaForPallet.parentLpn) {
                    if (palletIdForGroup == null) {
                        palletIdForGroup = ieaForPallet.parentLpn
                    } else if (palletIdForGroup != ieaForPallet.parentLpn) {
                        break
                    }
                } else {
                    break
                }
            } else {
                break
            }



            isAllocatePallet = true


        }

        if (isAllocatePallet == true) {

            def caseIea = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, palletIdForGroup)
            InventoryEntityAttribute ieaPallet = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, palletIdForGroup)
            if (shipmentLines.size() == caseIea.size()) {

                //Create Pallet Pick

                allocationSucceed = true

                //Create pallet pick work
                PickWork pickWork = new PickWork()
                pickWork.pickType = PickWorkType.SALES
                pickWork.companyId = companyId
                pickWork.shipmentId = shipmentId
                pickWork.shipmentLineId = shipmentLines[0].shipmentLineId
                pickWork.orderNumber = orderLineForPalletGroup.orderNumber
                pickWork.orderLineNumber = orderLineForPalletGroup.orderLineNumber
                pickWork.pickQuantity = caseIea.size()
                pickWork.pickQuantityUom = 'CASE'
                pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                pickWork.sourceLocationId = ieaPallet.locationId
                pickWork.destinationLocationId = destinationLocation
                pickWork.lastUpdateUsername = updatedUser
                pickWork.pickSequence = null
                pickWork.palletLpn = null
                pickWork.pickLevel = PickLevel.PALLET
                pickWork.itemId = itemIdForPalletGroup
                pickingService.createPickWork(pickWork)

                //Update Allocation Rule
                AllocationRule updateAllocationRule = AllocationRule.findByCompanyIdAndOrderLineNumberAndAttributeName(companyId, orderLineForPalletGroup.orderLineNumber, AllocationAttribute.LPN)
                updateAllocationRule.attributeValue = palletIdForGroup
                updateAllocationRule.save(flush: true, failOnError: true)


            }

        } else {

            for (shipmentLine in shipmentLines) {


                allocationMessage = null
                allocationSucceed = true
                def orderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, shipmentLine.orderLineNumber)
                def requestedQuantity = shipmentLine.shippedQuantity
                def allocatedQuantity = 0
                def requiredQuantity = requestedQuantity
                def shipmentLineItem = Item.findByCompanyIdAndItemId(companyId, shipmentLine.itemId)
                def caseLevelPickQuantity = 0
                def physicalLocation = null

                //Check Inventory Available
                if (orderLine.isCreateKittingOrder == true) {
                    allocationMessage = masterAllocationValidateForTriggered(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)

                } else {
                    allocationMessage = masterAllocationValidate(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)
                }

                if (allocationMessage)
                    allocationSucceed = false

                if (allocationSucceed) {

                    //Allocate By attribute

                    if (requiredQuantity > 0) {
                        // Allocate By Lpn
                        AllocationRule allocationRule = AllocationRule.findByCompanyIdAndOrderLineNumberAndAttributeName(companyId, orderLine.orderLineNumber, AllocationAttribute.LPN)

                        if (allocationRule) {

                            InventoryEntityAttribute iea = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, allocationRule.attributeValue)

                            if (iea) {

                                if (iea.level == 'PALLET') {

                                    def caseInventories = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, iea.lPN)

                                    //Check for Item and Inv Status
                                    Inventory inventoryForItemAndStatus = Inventory.findByCompanyIdAndItemIdAndInventoryStatusAndAssociatedLpn(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, caseInventories[0].lPN)

                                    if (inventoryForItemAndStatus) {
                                        if (caseInventories.size() == shipmentLine.shippedQuantity) {
                                            //Create Pallet Pick

                                            allocationSucceed = true

                                            //Create pallet pick work
                                            PickWork pickWork = new PickWork()
                                            pickWork.pickType = PickWorkType.SALES
                                            pickWork.companyId = companyId
                                            pickWork.shipmentId = shipmentId
                                            pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                            pickWork.orderNumber = orderLine.orderNumber
                                            pickWork.orderLineNumber = orderLine.orderLineNumber
                                            pickWork.pickQuantity = shipmentLine.shippedQuantity
                                            pickWork.pickQuantityUom = shipmentLine.shippedUOM
                                            pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                            pickWork.sourceLocationId = iea.locationId
                                            pickWork.destinationLocationId = destinationLocation
                                            pickWork.lastUpdateUsername = updatedUser
                                            pickWork.pickSequence = null
                                            pickWork.palletLpn = null
                                            pickWork.pickLevel = PickLevel.PALLET
                                            pickWork.itemId = shipmentLine.itemId
                                            pickingService.createPickWork(pickWork)

                                            physicalLocation = iea.locationId
                                            //Update required Qty
                                            requiredQuantity = 0
                                        } else {
                                            allocationMessage = "Quantity is not matching with number of cases on this pallet"
                                            allocationSucceed = false
                                        }
                                    } else {
                                        allocationMessage = "Lpn is not related to order line item or inventory status"
                                        allocationSucceed = false
                                    }


                                } else {


                                    String sourceLocationId = null

                                    if (iea.parentLpn) {
                                        sourceLocationId = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, iea.parentLpn).locationId
                                    } else {
                                        sourceLocationId = iea.locationId
                                    }

                                    //Check for Item and Inv Status
                                    Inventory inventoryForItemAndStatus = Inventory.findByCompanyIdAndItemIdAndInventoryStatusAndAssociatedLpn(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, iea.lPN)

                                    if (inventoryForItemAndStatus) {

                                        if (shipmentLine.shippedUOM == 'CASE' && shipmentLine.shippedQuantity == 1) {
                                            // Create Pick List

                                            //Create case pick work
                                            PickWork pickWork = new PickWork()
                                            pickWork.pickType = PickWorkType.SALES
                                            pickWork.companyId = companyId
                                            pickWork.shipmentId = shipmentId
                                            pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                            pickWork.orderNumber = orderLine.orderNumber
                                            pickWork.orderLineNumber = orderLine.orderLineNumber
                                            pickWork.pickQuantity = shipmentLine.shippedQuantity
                                            pickWork.pickQuantityUom = shipmentLine.shippedUOM
                                            pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                            pickWork.sourceLocationId = sourceLocationId
                                            pickWork.destinationLocationId = destinationLocation
                                            pickWork.lastUpdateUsername = updatedUser
                                            pickWork.pickSequence = null
                                            pickWork.palletLpn = null
                                            pickWork.pickLevel = PickLevel.CASE
                                            pickWork.waveNumber = waveNumber
                                            pickWork.itemId = shipmentLine.itemId
                                            pickingService.createPickWork(pickWork)


                                        } else {
                                            allocationMessage = "You cannot allocate for this case id"
                                            allocationSucceed = false

                                        }

                                    } else {
                                        allocationMessage = "Lpn is not related to order line item or inventory status"
                                        allocationSucceed = false

                                    }


                                }

                            } else {
                                allocationMessage = "No inventory found with this LPN"
                                allocationSucceed = false

                            }
                            requiredQuantity = 0
                        }

                        // Pallet Pick


                    }


                    if (requiredQuantity > 0 && orderLine.isCreateKittingOrder == true && shipmentLine.kittingOrderQuantity > 0) {

//					Create Kitting Order
                        BillMaterial bom = BillMaterial.findByCompanyIdAndItemIdAndFinishedProductDefaultStatus(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)
                        KittingOrder kittingOrder = kittingOrderService.copyBOMDataToKittingOrder(companyId, bom, shipmentLine.orderLineNumber)

                        if (shipmentLine.shippedUOM == HandlingUom.CASE && shipmentLineItem.lowestUom == HandlingUom.EACH) {
                            kittingOrder.productionQuantity = shipmentLine.kittingOrderQuantity.toInteger() * shipmentLineItem.eachesPerCase.toInteger()
                        } else {
                            kittingOrder.productionQuantity = shipmentLine.kittingOrderQuantity.toInteger()
                        }

                        kittingOrder.orderInfo = shipmentLine.orderLineNumber
                        kittingOrder.kittingOrderType = KittingOrderType.TRIGGERED
                        kittingOrder.save(flush: true, failOnError: true)

                        requiredQuantity = requestedQuantity - shipmentLine.kittingOrderQuantity


                    }

                    if (requiredQuantity > 0) {
                        //Get Pallet Level Inventories
                        def palletLevelInventories = inventoryService.getPalletLevelInventory(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)

                        if (palletLevelInventories) {

                            // Get All Active Pallet Picks
                            def palletPicks = PickWork.findAll("FROM PickWork AS pw WHERE pw.companyId = ? AND pw.itemId = ? AND pw.pickQuantityUom = ? AND pw.pickStatus = ? AND pw.pickLevel = ?", companyId, shipmentLine.itemId, shipmentLine.shippedUOM, PickWorkStatus.READY_TO_PICK, PickLevel.PALLET)

                            for (palletLevelInventory in palletLevelInventories) {

                                //Check Is there any active pallet pick for this quantity in the location
                                def existPalletPick = palletPicks.find { p -> p.sourceLocationId == palletLevelInventory.locationId && p.pickQuantity == palletLevelInventory.quantity }


                                if (shipmentLine.shippedUOM == HandlingUom.EACH && palletLevelInventory.handlingUom == HandlingUom.CASE) {

                                    if ((palletLevelInventory.quantity * shipmentLineItem.eachesPerCase) <= requiredQuantity) {

                                        if (existPalletPick) {
                                            palletPicks.remove(existPalletPick)
                                        } else {

                                            //Check All Conditions
                                            allocationMessage = validateAllocation(companyId, palletLevelInventory.locationId, AreaPickLevel.PALLET)

                                            if (allocationMessage == null) {
                                                allocationSucceed = true
                                                allocatedQuantity = palletLevelInventory.quantity * shipmentLineItem.eachesPerCase

                                                //Allocate Pallet Level Inventory
                                                //Create pallet pick work
//										    pickingService.createPickWork(companyId,shipmentLine, orderLine, palletLevelInventory.quantity, palletLevelInventory.handlingUom, palletLevelInventory.locationId, destinationLocation, null, null, "P", updatedUser, "Ready to Pick")

                                                //Create pallet pick work
                                                PickWork pickWork = new PickWork()
                                                pickWork.pickType = PickWorkType.SALES
                                                pickWork.companyId = companyId
                                                pickWork.shipmentId = shipmentId
                                                pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                                pickWork.orderNumber = orderLine.orderNumber
                                                pickWork.orderLineNumber = orderLine.orderLineNumber
                                                pickWork.pickQuantity = palletLevelInventory.quantity
                                                pickWork.pickQuantityUom = palletLevelInventory.handlingUom
                                                pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                                pickWork.sourceLocationId = palletLevelInventory.locationId
                                                pickWork.destinationLocationId = destinationLocation
                                                pickWork.lastUpdateUsername = updatedUser
                                                pickWork.pickSequence = null
                                                pickWork.palletLpn = null
                                                pickWork.pickLevel = PickLevel.PALLET
                                                pickWork.itemId = shipmentLine.itemId
                                                pickingService.createPickWork(pickWork)

                                                physicalLocation = palletLevelInventory.locationId
                                                //Update required Qty
                                                requiredQuantity -= allocatedQuantity
                                            } else
                                                allocationSucceed = false

                                        }
                                    }

                                } else if (palletLevelInventory.quantity <= requiredQuantity) {

                                    if (existPalletPick) {
                                        palletPicks.remove(existPalletPick)
                                    } else {

                                        allocationMessage = validateAllocation(companyId, palletLevelInventory.locationId, AreaPickLevel.PALLET)

                                        if (allocationMessage == null) {
                                            allocationSucceed = true
                                            allocatedQuantity = palletLevelInventory.quantity

                                            //Allocate Pallet Level Inventory
//										pickingService.createPickWork(companyId,shipmentLine, orderLine, palletLevelInventory.quantity, palletLevelInventory.handlingUom, palletLevelInventory.locationId, destinationLocation, null, null, "P", updatedUser, "Ready to Pick")

                                            //Create pallet pick work
                                            PickWork pickWork = new PickWork()
                                            pickWork.pickType = PickWorkType.SALES
                                            pickWork.companyId = companyId
                                            pickWork.shipmentId = shipmentId
                                            pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                            pickWork.orderNumber = orderLine.orderNumber
                                            pickWork.orderLineNumber = orderLine.orderLineNumber
                                            pickWork.pickQuantity = palletLevelInventory.quantity
                                            pickWork.pickQuantityUom = palletLevelInventory.handlingUom
                                            pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                            pickWork.sourceLocationId = palletLevelInventory.locationId
                                            pickWork.destinationLocationId = destinationLocation
                                            pickWork.lastUpdateUsername = updatedUser
                                            pickWork.pickSequence = null
                                            pickWork.palletLpn = null
                                            pickWork.pickLevel = PickLevel.PALLET
                                            pickWork.itemId = shipmentLine.itemId
                                            pickingService.createPickWork(pickWork)

                                            physicalLocation = palletLevelInventory.locationId

                                            //Update required Qty
                                            requiredQuantity -= allocatedQuantity
                                        } else
                                            allocationSucceed = false

                                    }
                                }
                            }
                        }
                    }

                    if (requiredQuantity > 0) {

                        //Get Case Level Inventories
                        def caseLevelInventories = inventoryService.getCaseLevelInventories(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)

                        if (caseLevelInventories) {

                            for (caseLevelInventory in caseLevelInventories) {


                                if (requiredQuantity > 0 && caseLevelInventory.quantity > 0) {

                                    if (shipmentLine.shippedUOM == HandlingUom.EACH && caseLevelInventory.handlingUom == HandlingUom.CASE) {

                                        allocationMessage = validateAllocation(companyId, caseLevelInventory.locationId, AreaPickLevel.CASE)

                                        if (allocationMessage == null) {
                                            allocationSucceed = true

                                            allocatedQuantity = requiredQuantity < (caseLevelInventory.quantity * shipmentLineItem.eachesPerCase) ? requiredQuantity : (caseLevelInventory.quantity * shipmentLineItem.eachesPerCase)


                                            caseLevelPickQuantity = (allocatedQuantity / shipmentLineItem.eachesPerCase).toInteger()

                                            //Allocate Case Level Inventory
                                            //Create case pick work
                                            if (caseLevelPickQuantity > 0) {
                                                Integer allocatedCaseQuantity = caseLevelPickQuantity * shipmentLineItem.eachesPerCase
//											pickingService.createPickWork(companyId,shipmentLine, orderLine, caseLevelPickQuantity, caseLevelInventory.handlingUom , caseLevelInventory.locationId, destinationLocation, null, null, "C", updatedUser, "Ready to Pick")

                                                //Create case pick work
                                                PickWork pickWork = new PickWork()
                                                pickWork.pickType = PickWorkType.SALES
                                                pickWork.companyId = companyId
                                                pickWork.shipmentId = shipmentId
                                                pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                                pickWork.orderNumber = orderLine.orderNumber
                                                pickWork.orderLineNumber = orderLine.orderLineNumber
                                                pickWork.pickQuantity = caseLevelPickQuantity
                                                pickWork.pickQuantityUom = caseLevelInventory.handlingUom
                                                pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                                pickWork.sourceLocationId = caseLevelInventory.locationId
                                                pickWork.destinationLocationId = destinationLocation
                                                pickWork.lastUpdateUsername = updatedUser
                                                pickWork.pickSequence = null
                                                pickWork.palletLpn = null
                                                pickWork.pickLevel = PickLevel.CASE
                                                pickWork.waveNumber = waveNumber
                                                pickWork.itemId = shipmentLine.itemId
                                                pickingService.createPickWork(pickWork)

                                                requiredQuantity -= allocatedCaseQuantity
                                                allocatedQuantity -= allocatedCaseQuantity
                                            }
                                            if (allocatedQuantity > 0) {
//											 pickingService.createPickWork(companyId,shipmentLine, orderLine, allocatedQuantity, "EACH" , caseLevelInventory.locationId, destinationLocation, null, null, "E", updatedUser, "Ready to Pick")

                                                //Create pick work
                                                PickWork pickWork = new PickWork()
                                                pickWork.pickType = PickWorkType.SALES
                                                pickWork.companyId = companyId
                                                pickWork.shipmentId = shipmentId
                                                pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                                pickWork.orderNumber = orderLine.orderNumber
                                                pickWork.orderLineNumber = orderLine.orderLineNumber
                                                pickWork.pickQuantity = allocatedQuantity
                                                pickWork.pickQuantityUom = HandlingUom.EACH
                                                pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                                pickWork.sourceLocationId = caseLevelInventory.locationId
                                                pickWork.destinationLocationId = destinationLocation
                                                pickWork.lastUpdateUsername = updatedUser
                                                pickWork.pickSequence = null
                                                pickWork.palletLpn = null
                                                pickWork.pickLevel = PickLevel.EACH
                                                pickWork.waveNumber = waveNumber
                                                pickWork.itemId = shipmentLine.itemId
                                                pickingService.createPickWork(pickWork)

                                                requiredQuantity -= allocatedQuantity

                                            }
                                            physicalLocation = caseLevelInventory.locationId

                                        } else
                                            allocationSucceed = false


                                    } else {

                                        allocationMessage = validateAllocation(companyId, caseLevelInventory.locationId, AreaPickLevel.CASE)

                                        if (allocationMessage == null) {


                                            allocationSucceed = true
                                            allocatedQuantity = requiredQuantity < caseLevelInventory.quantity ? requiredQuantity : caseLevelInventory.quantity

                                            //Allocate Pallet Level Inventory
                                            //Create case pick work
//										pickingService.createPickWork(companyId,shipmentLine, orderLine, allocatedQuantity, caseLevelInventory.handlingUom ,caseLevelInventory.locationId, destinationLocation, null, null, "C", updatedUser, "Ready to Pick")
                                            //Create case pick work
                                            PickWork pickWork = new PickWork()
                                            pickWork.pickType = PickWorkType.SALES
                                            pickWork.companyId = companyId
                                            pickWork.shipmentId = shipmentId
                                            pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                            pickWork.orderNumber = orderLine.orderNumber
                                            pickWork.orderLineNumber = orderLine.orderLineNumber
                                            pickWork.pickQuantity = allocatedQuantity
                                            pickWork.pickQuantityUom = caseLevelInventory.handlingUom
                                            pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                            pickWork.sourceLocationId = caseLevelInventory.locationId
                                            pickWork.destinationLocationId = destinationLocation
                                            pickWork.lastUpdateUsername = updatedUser
                                            pickWork.pickSequence = null
                                            pickWork.palletLpn = null
                                            pickWork.pickLevel = PickLevel.CASE
                                            pickWork.waveNumber = waveNumber
                                            pickWork.itemId = shipmentLine.itemId
                                            pickingService.createPickWork(pickWork)

                                            physicalLocation = caseLevelInventory.locationId

                                            requiredQuantity -= allocatedQuantity


                                        } else
                                            allocationSucceed = false


                                    }


                                }

                            }


                        }
                    }

                    if (requiredQuantity > 0 && shipmentLine.shippedUOM == HandlingUom.EACH) {

                        //Get Each Level Inventories
                        def eachLevelInventories = inventoryService.getEachLevelInventories(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)

                        if (eachLevelInventories) {


                            for (eachLevelInventory in eachLevelInventories) {

                                if (requiredQuantity > 0) {

                                    allocationMessage = validateAllocation(companyId, eachLevelInventory.locationId, AreaPickLevel.EACH)
                                    if (allocationMessage == null) {
                                        allocatedQuantity = requiredQuantity < eachLevelInventory.quantity ? requiredQuantity : eachLevelInventory.quantity

                                        //Allocate Each Level Inventory
                                        //Create Each pick work
                                        if (allocatedQuantity > 0) {
//										pickingService.createPickWork(companyId,shipmentLine, orderLine, allocatedQuantity, eachLevelInventory.handlingUom , eachLevelInventory.locationId, destinationLocation, null, null, "E", updatedUser, "Ready to Pick")

                                            //Create each pick work
                                            PickWork pickWork = new PickWork()
                                            pickWork.pickType = PickWorkType.SALES
                                            pickWork.companyId = companyId
                                            pickWork.shipmentId = shipmentId
                                            pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                            pickWork.orderNumber = orderLine.orderNumber
                                            pickWork.orderLineNumber = orderLine.orderLineNumber
                                            pickWork.pickQuantity = allocatedQuantity
                                            pickWork.pickQuantityUom = eachLevelInventory.handlingUom
                                            pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                            pickWork.sourceLocationId = eachLevelInventory.locationId
                                            pickWork.destinationLocationId = destinationLocation
                                            pickWork.lastUpdateUsername = updatedUser
                                            pickWork.pickSequence = null
                                            pickWork.palletLpn = null
                                            pickWork.pickLevel = PickLevel.EACH
                                            pickWork.waveNumber = waveNumber
                                            pickWork.itemId = shipmentLine.itemId
                                            pickingService.createPickWork(pickWork)




                                            physicalLocation = eachLevelInventory.locationId

                                            requiredQuantity -= allocatedQuantity
                                        }
                                    } else
                                        allocationSucceed = false

                                }

                            }

                        }
                    }

                    if (requiredQuantity > 0 && shipmentLine.shippedUOM == HandlingUom.CASE) {

                        //Get Each Level Inventories
                        def eachLevelInventories = inventoryService.getEachLevelInventories(companyId, shipmentLine.itemId, orderLine.requestedInventoryStatus)

                        if (eachLevelInventories) {

                            for (eachLevelInventory in eachLevelInventories) {

                                if (requiredQuantity > 0) {

                                    def eachesPerCase = shipmentLineItem.eachesPerCase

                                    if (eachesPerCase && eachesPerCase > 0) {

                                        allocationMessage = validateAllocation(companyId, eachLevelInventory.locationId, AreaPickLevel.CASE)
                                        if (allocationMessage == null) {
                                            def requiredQuantityInEach = requiredQuantity * eachesPerCase


                                            if (requiredQuantityInEach <= eachLevelInventory.quantity) {

                                                allocatedQuantity = requiredQuantityInEach

                                                //Allocate Each Level Inventory
                                                //Create Each pick work
                                                if (allocatedQuantity > 0) {
//												pickingService.createPickWork(companyId,shipmentLine, orderLine, allocatedQuantity, eachLevelInventory.handlingUom , eachLevelInventory.locationId, destinationLocation, null, null, "E", updatedUser, "Ready to Pick")

                                                    //Create each pick work
                                                    PickWork pickWork = new PickWork()
                                                    pickWork.pickType = PickWorkType.SALES
                                                    pickWork.companyId = companyId
                                                    pickWork.shipmentId = shipmentId
                                                    pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                                    pickWork.orderNumber = orderLine.orderNumber
                                                    pickWork.orderLineNumber = orderLine.orderLineNumber
                                                    pickWork.pickQuantity = allocatedQuantity
                                                    pickWork.pickQuantityUom = eachLevelInventory.handlingUom
                                                    pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                                                    pickWork.sourceLocationId = eachLevelInventory.locationId
                                                    pickWork.destinationLocationId = destinationLocation
                                                    pickWork.lastUpdateUsername = updatedUser
                                                    pickWork.pickSequence = null
                                                    pickWork.palletLpn = null
                                                    pickWork.pickLevel = PickLevel.EACH
                                                    pickWork.waveNumber = waveNumber
                                                    pickWork.itemId = shipmentLine.itemId
                                                    pickingService.createPickWork(pickWork)


                                                    physicalLocation = eachLevelInventory.locationId

                                                    requiredQuantity -= (allocatedQuantity / eachesPerCase)


                                                }

                                            }

                                        } else
                                            allocationSucceed = false

                                    }


                                }

                            }

                        }
                    }

                    if (requiredQuantity > 0) {

                        //Check Replen for the Company

                        def entityAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigGroup(companyId, "AREAS", "RESERVEDAREA")

                        if (entityAttributes && entityAttributes.size() > 0) {
                            if (physicalLocation == null) {

                                //Find Empty Location
                                def emptyLocations = locationService.emptyPickableLocations(companyId)

                                if (emptyLocations.size() > 0) {

                                    physicalLocation = emptyLocations[0]

                                    // Create Pick Work for Replenishment
//								def replenPickWork = pickingService.createPickWork(companyId,shipmentLine, orderLine, requiredQuantity, shipmentLine.shippedUOM, physicalLocation, destinationLocation, null, null, "C", updatedUser, "Pending Replen")

                                    //Create each pick work
                                    PickWork pickWork = new PickWork()
                                    pickWork.pickType = PickWorkType.SALES
                                    pickWork.companyId = companyId
                                    pickWork.shipmentId = shipmentId
                                    pickWork.shipmentLineId = shipmentLine.shipmentLineId
                                    pickWork.orderNumber = orderLine.orderNumber
                                    pickWork.orderLineNumber = orderLine.orderLineNumber
                                    pickWork.pickQuantity = requiredQuantity
                                    pickWork.pickQuantityUom = shipmentLine.shippedUOM
                                    pickWork.pickStatus = PickWorkStatus.PENDING_REPLEN
                                    pickWork.sourceLocationId = physicalLocation
                                    pickWork.destinationLocationId = destinationLocation
                                    pickWork.lastUpdateUsername = updatedUser
                                    pickWork.pickSequence = null
                                    pickWork.palletLpn = null
                                    pickWork.pickLevel = PickLevel.CASE
                                    pickWork.waveNumber = waveNumber
                                    pickWork.itemId = shipmentLine.itemId
                                    pickingService.createPickWork(pickWork)

                                    // Replenishment
                                    def replenCompleted = prepareReplenishment(companyId, replenPickWork.workReferenceNumber, physicalLocation, shipmentLine.itemId, orderLine.requestedInventoryStatus, requiredQuantity, shipmentLine.shippedUOM)

                                    //allocationSucceed = replenCompleted
                                    if (replenCompleted) {
                                        allocationSucceed = true
                                        allocationMessage = "Allocation Succeed"
                                    } else {
                                        allocationSucceed = false
                                        allocationMessage = "No suitable pickable or reserve locations were found for this item"
                                    }

                                } else {
                                    allocationMessage = " There is no empty location found for the replenishment"
                                    allocationSucceed = false
                                }

                            } else {

                                allocationSucceed = false
                                allocationMessage = "No suitable pickable or reserve locations were found for this item"
                            }
                        } else {

                            allocationSucceed = false
                            allocationMessage = "No suitable pickable or reserve locations were found for this item"
                        }

                    }


                }

                if (allocationMessage != null) {
                    println("8888888")
                    def map = [shipmentLineId : shipmentLine.shipmentLineId,
                               allocaionStatus: allocationSucceed,
                               message        : "Shipment Line " + shipmentLine.shipmentLineId + ". For Item " + shipmentLine.itemId + " : " + allocationMessage]
                    allocationMap.add(map)
                }

            }

        }






        def allocationResult = null
        def allocationNotifyMessage = null
        if (allocationMap.find { it.allocaionStatus == false }) {

            rollBackAllocation(companyId, shipmentId)
            allocationResult = false
            allocationNotifyMessage = allocationMap.collect { map -> map.message }.join(", ")
            allocationFailedMessageService.createAllocationFailedMessage(companyId, shipmentId, allocationNotifyMessage)
        } else {

            allocationResult = true
            allocationNotifyMessage = "Allocation Succeed"
            def shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
            PickWork pickWork = PickWork.findByCompanyIdAndShipmentId(companyId, shipmentId)

            if (pickWork) {
                shipment.shipmentStatus = ShipmentStatus.ALLOCATED
            } else {
                shipment.shipmentStatus = ShipmentStatus.KO_PROCESSING
            }

            shipment.stagingLocationId = destinationLocation
            shipment.save(flush: true, failOnError: true)
        }


        return [allocationResult: allocationResult, message: allocationNotifyMessage]

    }

    def prepareKittingAllocation(companyId, kittingOrderNumber, destinationLocation, updatedUser) {

        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
        def kittingComponents = KittingOrderComponent.findAllByCompanyIdAndKittingOrderNumber(companyId, kittingOrderNumber)
        def allocationSucceed = true
        def allocationMessage = null
        def allocationMap = []

        for (component in kittingComponents) {

            allocationMessage = null
            allocationSucceed = true
            def requestedQuantity = component.componentQuantity * kittingOrder.productionQuantity
            def allocatedQuantity = 0
            def requiredQuantity = requestedQuantity
            def componentItem = Item.findByCompanyIdAndItemId(companyId, component.componentItemId)
            def caseLevelPickQuantity = 0
            def physicalLocation = null

            //Check Inventory Available
            allocationMessage = masterAllocationValidate(companyId, component.componentItemId, component.componentInventoryStatus)
            if (allocationMessage)
                allocationSucceed = false

            if (allocationSucceed) {

                //Get Pallet Level Inventories
                def palletLevelInventories = inventoryService.getPalletLevelInventory(companyId, component.componentItemId, component.componentInventoryStatus)

                if (palletLevelInventories) {

                    // Get All Active Pallet Picks
                    def palletPicks = PickWork.findAll("FROM PickWork AS pw WHERE pw.companyId = ? AND pw.pickQuantityUom = ? AND pw.pickStatus = ? AND pw.pickLevel = ?", companyId, component.componentUom, PickWorkStatus.READY_TO_PICK, PickLevel.PALLET)

                    for (palletLevelInventory in palletLevelInventories) {

                        //Check Is there any active pallet pick for this quantity in the location
                        def existPalletPick = palletPicks.find { p -> p.sourceLocationId == palletLevelInventory.locationId && p.pickQuantity == palletLevelInventory.quantity }


                        if (component.componentUom == HandlingUom.EACH && palletLevelInventory.handlingUom == HandlingUom.CASE) {

                            if ((palletLevelInventory.quantity * componentItem.eachesPerCase) <= requiredQuantity) {

                                if (existPalletPick) {
                                    palletPicks.remove(existPalletPick)
                                } else {

                                    //Check All Conditions
                                    allocationMessage = validateAllocation(companyId, palletLevelInventory.locationId, AreaPickLevel.PALLET)

                                    if (allocationMessage == null) {
                                        allocationSucceed = true
                                        allocatedQuantity = palletLevelInventory.quantity * componentItem.eachesPerCase

                                        //Allocate Pallet Level Inventory
                                        //Create pallet pick work
                                        pickingService.createKittingPickWork(companyId, component, palletLevelInventory.quantity, palletLevelInventory.handlingUom, palletLevelInventory.locationId, destinationLocation, null, null, PickLevel.PALLET, updatedUser, PickWorkStatus.READY_TO_PICK)
                                        physicalLocation = palletLevelInventory.locationId
                                        //Update required Qty
                                        requiredQuantity -= allocatedQuantity
                                    } else
                                        allocationSucceed = false

                                }
                            }

                        } else if (palletLevelInventory.quantity <= requiredQuantity) {

                            if (existPalletPick) {
                                palletPicks.remove(existPalletPick)
                            } else {

                                allocationMessage = validateAllocation(companyId, palletLevelInventory.locationId, AreaPickLevel.PALLET)

                                if (allocationMessage == null) {
                                    allocationSucceed = true
                                    allocatedQuantity = palletLevelInventory.quantity

                                    //Allocate Pallet Level Inventory
                                    //Create pallet pick work
                                    pickingService.createKittingPickWork(companyId, component, palletLevelInventory.quantity, palletLevelInventory.handlingUom, palletLevelInventory.locationId, destinationLocation, null, null, PickLevel.PALLET, updatedUser, PickWorkStatus.READY_TO_PICK)
                                    physicalLocation = palletLevelInventory.locationId

                                    //Update required Qty
                                    requiredQuantity -= allocatedQuantity
                                } else
                                    allocationSucceed = false

                            }
                        }
                    }
                }

                if (requiredQuantity > 0) {

                    //Get Case Level Inventories
                    def caseLevelInventories = inventoryService.getCaseLevelInventories(companyId, component.componentItemId, component.componentInventoryStatus)

                    if (caseLevelInventories) {

                        for (caseLevelInventory in caseLevelInventories) {

                            if (requiredQuantity > 0 && caseLevelInventory.quantity > 0) {

                                if (component.componentUom == HandlingUom.EACH && caseLevelInventory.handlingUom == HandlingUom.CASE) {

                                    allocationMessage = validateAllocation(companyId, caseLevelInventory.locationId, AreaPickLevel.CASE)

                                    if (allocationMessage == null) {
                                        allocationSucceed = true

                                        allocatedQuantity = requiredQuantity < (caseLevelInventory.quantity * componentItem.eachesPerCase) ? requiredQuantity : (caseLevelInventory.quantity * componentItem.eachesPerCase)


                                        caseLevelPickQuantity = (allocatedQuantity / componentItem.eachesPerCase).toInteger()

                                        //Allocate Case Level Inventory
                                        //Create case pick work
                                        if (caseLevelPickQuantity > 0) {
                                            Integer allocatedCaseQuantity = caseLevelPickQuantity * componentItem.eachesPerCase
                                            pickingService.createKittingPickWork(companyId, component, caseLevelPickQuantity, caseLevelInventory.handlingUom, caseLevelInventory.locationId, destinationLocation, null, null, PickLevel.CASE, updatedUser, PickWorkStatus.READY_TO_PICK)
                                            requiredQuantity -= allocatedCaseQuantity
                                            allocatedQuantity -= allocatedCaseQuantity
                                        }
                                        if (allocatedQuantity > 0) {
                                            pickingService.createKittingPickWork(companyId, component, allocatedQuantity, HandlingUom.EACH, caseLevelInventory.locationId, destinationLocation, null, null, PickLevel.EACH, updatedUser, PickWorkStatus.READY_TO_PICK)
                                            requiredQuantity -= allocatedQuantity

                                        }
                                        physicalLocation = caseLevelInventory.locationId

                                    } else
                                        allocationSucceed = false


                                } else {

                                    allocationMessage = validateAllocation(companyId, caseLevelInventory.locationId, AreaPickLevel.CASE)

                                    if (allocationMessage == null) {


                                        allocationSucceed = true
                                        allocatedQuantity = requiredQuantity < caseLevelInventory.quantity ? requiredQuantity : caseLevelInventory.quantity

                                        //Allocate Pallet Level Inventory
                                        //Create case pick work
                                        pickingService.createKittingPickWork(companyId, component, allocatedQuantity, caseLevelInventory.handlingUom, caseLevelInventory.locationId, destinationLocation, null, null, PickLevel.CASE, updatedUser, PickWorkStatus.READY_TO_PICK)
                                        physicalLocation = caseLevelInventory.locationId

                                        requiredQuantity -= allocatedQuantity


                                    } else
                                        allocationSucceed = false


                                }


                            }

                        }


                    }
                }

                if (requiredQuantity > 0 && component.componentUom == HandlingUom.EACH) {

                    //Get Each Level Inventories
                    def eachLevelInventories = inventoryService.getEachLevelInventories(companyId, component.componentItemId, component.componentInventoryStatus)

                    if (eachLevelInventories) {


                        for (eachLevelInventory in eachLevelInventories) {

                            if (requiredQuantity > 0) {

                                allocationMessage = validateAllocation(companyId, eachLevelInventory.locationId, AreaPickLevel.EACH)
                                if (allocationMessage == null) {
                                    allocatedQuantity = requiredQuantity < eachLevelInventory.quantity ? requiredQuantity : eachLevelInventory.quantity

                                    //Allocate Each Level Inventory
                                    //Create Each pick work
                                    if (allocatedQuantity > 0) {
                                        pickingService.createKittingPickWork(companyId, component, allocatedQuantity, eachLevelInventory.handlingUom, eachLevelInventory.locationId, destinationLocation, null, null, PickLevel.EACH, updatedUser, PickWorkStatus.READY_TO_PICK)
                                        physicalLocation = eachLevelInventory.locationId

                                        requiredQuantity -= allocatedQuantity
                                    }
                                } else
                                    allocationSucceed = false

                            }

                        }

                    }
                }

                if (requiredQuantity > 0 && component.componentUom == HandlingUom.CASE) {

                    //Get Each Level Inventories
                    def eachLevelInventories = inventoryService.getEachLevelInventories(companyId, component.componentItemId, component.componentInventoryStatus)

                    if (eachLevelInventories) {

                        for (eachLevelInventory in eachLevelInventories) {

                            if (requiredQuantity > 0) {

                                def eachesPerCase = componentItem.eachesPerCase

                                if (eachesPerCase && eachesPerCase > 0) {

                                    allocationMessage = validateAllocation(companyId, eachLevelInventory.locationId, AreaPickLevel.CASE)
                                    if (allocationMessage == null) {
                                        def requiredQuantityInEach = requiredQuantity * eachesPerCase


                                        if (requiredQuantityInEach <= eachLevelInventory.quantity) {

                                            allocatedQuantity = requiredQuantityInEach

                                            //Allocate Each Level Inventory
                                            //Create Each pick work
                                            if (allocatedQuantity > 0) {
                                                pickingService.createKittingPickWork(companyId, component, allocatedQuantity, eachLevelInventory.handlingUom, eachLevelInventory.locationId, destinationLocation, null, null, PickLevel.EACH, updatedUser, PickWorkStatus.READY_TO_PICK)
                                                physicalLocation = eachLevelInventory.locationId

                                                requiredQuantity -= (allocatedQuantity / eachesPerCase)


                                            }

                                        }

                                    } else
                                        allocationSucceed = false

                                }


                            }

                        }

                    }
                }

                if (requiredQuantity > 0) {

                    //Check Replen for the Company

                    def entityAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigGroup(companyId, "AREAS", "RESERVEDAREA")

                    if (entityAttributes && entityAttributes.size() > 0) {
                        if (physicalLocation == null) {

                            //Find Empty Location
                            def emptyLocations = locationService.emptyPickableLocations(companyId)

                            if (emptyLocations.size() > 0) {

                                physicalLocation = emptyLocations[0]

                                // Create Pick Work for Replenishment
                                def replenPickWork = pickingService.createKittingPickWork(companyId, component, requiredQuantity, component.componentUom, physicalLocation, destinationLocation, null, null, PickLevel.CASE, updatedUser, PickWorkStatus.PENDING_REPLEN)

                                // Replenishment
                                def replenCompleted = prepareReplenishment(companyId, replenPickWork.workReferenceNumber, physicalLocation, component.componentItemId, component.componentInventoryStatus, requiredQuantity, component.componentUom)

                                //allocationSucceed = replenCompleted
                                if (replenCompleted) {
                                    allocationSucceed = true
                                    allocationMessage = "Allocation Succeed"
                                } else {
                                    allocationSucceed = false
                                    allocationMessage = "No suitable pickable or reserve locations were found for this item"
                                }

                            } else {
                                allocationMessage = " There is no empty location found for the replenishment"
                                allocationSucceed = false
                            }

                        }
                    } else {

                        allocationSucceed = false
                        allocationMessage = "No suitable pickable or reserve locations were found for this item"
                    }

                }


            }

            if (allocationMessage != null) {
                def map = [componentId    : component.id,
                           allocaionStatus: allocationSucceed,
                           message        : "Kitting Order " + component.kittingOrderNumber + ". For Item " + component.componentItemId + " : " + allocationMessage]
                allocationMap.add(map)
            }

        }



        def allocationResult = null
        def allocationNotifyMessage = null
        if (allocationMap.find { it.allocaionStatus == false }) {

            rollBackKittingAllocation(companyId, kittingOrderNumber)
            allocationResult = false
            allocationNotifyMessage = allocationMap.collect { map -> map.message }.join(", ")
            allocationFailedMessageService.createAllocationFailedMessage(companyId, kittingOrderNumber, allocationNotifyMessage)
        } else {

            allocationResult = true
            allocationNotifyMessage = "Allocation Succeed"
            kittingOrder.kittingOrderStatus = KittingOrderStatus.ALLOCATED
            kittingOrder.save(flush: true, failOnError: true)
        }


        return [allocationResult: allocationResult, message: allocationNotifyMessage]

    }


    def rollBackAllocation(companyId, shipmentId) {

        def deletePickWorks = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        if (deletePickWorks) {
            for (deletePickWork in deletePickWorks) {
                if (deletePickWork.pickListId) {

                    def availablePickWorksForThisList = PickWork.findAllByCompanyIdAndPickListId(companyId, deletePickWork.pickListId)

                    if (availablePickWorksForThisList.size() <= 1) {
                        PickList deletePickList = PickList.findByCompanyIdAndPickListId(companyId, deletePickWork.pickListId)
                        if (deletePickList) {
                            deletePickList.delete()
                        }
                    }
                }
                deletePickWork.delete()
            }
        }

        //Rollback Kitting Orders
        String sqlQuery = "SELECT ko.kitting_order_number " +
                "FROM kitting_order AS ko " +
                "INNER JOIN shipment_line AS sl ON sl.order_line_number = ko.kitting_order_number AND sl.company_id = '${companyId}' " +
                "WHERE ko.company_id = '${companyId}' AND ko.kitting_order_type = '${KittingOrderType.TRIGGERED}' AND sl.shipment_id = '${shipmentId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        if (rows.size() > 0) {

            for (row in rows) {
                KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, row.kitting_order_number)
                kittingOrderService.deleteKittingOrder(companyId, kittingOrder)
            }

        }

    }

    def rollBackKittingAllocation(companyId, kittingOrderNumber) {
        def deletePickWorks = PickWork.findAllByCompanyIdAndOrderNumber(companyId, kittingOrderNumber)
        if (deletePickWorks) {
            for (deletePickWork in deletePickWorks) {
                if (deletePickWork.pickListId) {
                    def deletePickList = PickList.findByCompanyIdAndPickListId(companyId, deletePickWork.pickListId)
                    if (deletePickList)
                        deletePickList.delete()
                }
                KittingOrderComponent kittingOrderComponent = KittingOrderComponent.findByCompanyIdAndId(companyId, deletePickWork.orderLineNumber)
                inventorySummaryService.unCommitInventory(companyId, kittingOrderComponent.componentItemId, kittingOrderComponent.componentInventoryStatus, deletePickWork.pickQuantity, deletePickWork.pickQuantityUom)
                deletePickWork.delete()

            }
        }
    }


    def prepareReplenishment(companyId, pickWorkReference, destinationLocation, itemId, inventoryStatus, requiredQuantity, requiredUOM) {

        def allocatedReplenQty = 0

        // Check Existing ReplenWork
        def availableReplenWorks = checkExistingReplenWork(companyId, itemId, inventoryStatus, requiredUOM)

        if (availableReplenWorks) {

            for (availableReplenWork in availableReplenWorks) {

                if (availableReplenWork.available_quantity > 0) {

                    allocatedReplenQty = availableReplenWork.available_quantity < requiredQuantity ? availableReplenWork.available_quantity : requiredQuantity

                    // Create Replen Demand
                    def replenDemand = createReplenDemand(companyId, pickWorkReference, itemId, inventoryStatus, allocatedReplenQty, requiredUOM, availableReplenWork.replen_reference)

                    //Update PickWork Source Location
                    def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, pickWorkReference)
                    pickWork.sourceLocationId = availableReplenWork.destination_location_id
                    pickWork.save(flush: true, failOnError: true)


                }
                requiredQuantity -= allocatedReplenQty
            }
        }


        def replenCompleted = null

        if (requiredQuantity > 0)
            replenCompleted = processReplenishment(companyId, pickWorkReference, itemId, inventoryStatus, requiredQuantity, requiredUOM, destinationLocation)
        else
            replenCompleted = true


        return replenCompleted

    }

    def checkExistingReplenWork(companyId,
//								destinationLocation,
                                itemId, replenInventoryStatus, replenQuantityUom) {

        def sqlQuery = "SELECT (COALESCE(rw.replen_quantity,0) - (SELECT COALESCE(SUM(required_quantity),0)  " +
                "		FROM replen_demand " +
                "		WHERE company_id = '${companyId}' " +
                "		AND replen_reference = rw.replen_reference)) AS available_quantity, rw.* " +
                "FROM replen_work AS rw " +
                "WHERE rw.company_id = '${companyId}' " +
//				"AND rw.destination_location_id = '${destinationLocation}' " +
                "AND rw.item_id = '${itemId}' " +
                "AND rw.replen_inventory_status = '${replenInventoryStatus}' " +
                "AND rw.replen_quantity_uom = '${replenQuantityUom}' " +
                "AND rw.replen_work_status = 'A' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def createReplenDemand(companyId, pickWorkReference, itemId, inventoryStatus, quantity, quantityUom, replenReference) {

        def replenDemand = new ReplenDemand()
        replenDemand.companyId = companyId
        replenDemand.workReferenceNumber = pickWorkReference
        replenDemand.itemId = itemId
        replenDemand.requiredInventoryStatus = inventoryStatus
        replenDemand.requiredQuantity = quantity
        replenDemand.requiredQuantityUom = quantityUom
        replenDemand.demandStatus = "A"
        replenDemand.replenReference = replenReference
        replenDemand.save(flush: true, failOnError: true)

        return replenDemand

    }

    def processReplenishment(companyId, pickWorkReference, itemId, inventoryStatus, requiredQuantity, requiredUOM, destinationLocation) {

        def destinationAreaId = Location.findByCompanyIdAndLocationId(companyId, destinationLocation).areaId
        def replenishmentAreaIds = areaService.getReplenishmentAreas(companyId, destinationAreaId)
        def replenCompleted = false
        def replenDemandQty = requiredQuantity


        if (replenishmentAreaIds) {

            for (replenishmentAreaId in replenishmentAreaIds) {

                def replenishmentLocations = Location.findAll("FROM Location AS lo WHERE (lo.companyId = '${companyId}' AND lo.areaId = '${replenishmentAreaId[0]}' ) ORDER BY lo.travelSequence ASC ")

                if (replenishmentLocations) {

                    for (replenishmentLocation in replenishmentLocations) {

//						def palletLevelReplenishment = getPalletLevelReplenInventory(companyId, replenishmentLocation['locationId'], itemId, inventoryStatus, requiredQuantity, requiredUOM)
//
//						if(palletLevelReplenishment){
//
//							// Create Replen Work
//							def replenWork = createReplenWork(companyId, itemId, inventoryStatus, palletLevelReplenishment[0].total_quantity, palletLevelReplenishment[0].handling_uom, palletLevelReplenishment[0].physical_location_id, destinationLocation)
//							// Create Replen Demand
//							createReplenDemand(companyId, pickWorkReference, itemId, inventoryStatus, requiredQuantity, requiredUOM, replenWork.replenReference)
//							replenCompleted = true
//							break
//						}

                        while (requiredQuantity > 0) {

                            def palletLevelReplenishment = getPalletLevelReplenInventory(companyId, replenishmentLocation['locationId'], itemId, inventoryStatus, requiredQuantity, requiredUOM)

                            if (palletLevelReplenishment) {

                                // Create Replen Work
                                def replenWork = createReplenWork(companyId, itemId, inventoryStatus, palletLevelReplenishment[0].total_quantity, palletLevelReplenishment[0].handling_uom, palletLevelReplenishment[0].physical_location_id, destinationLocation)

                                requiredQuantity -= palletLevelReplenishment[0].total_quantity

                                if (requiredQuantity <= 0) {

                                    // Create Replen Demand
                                    createReplenDemand(companyId, pickWorkReference, itemId, inventoryStatus, replenDemandQty, requiredUOM, replenWork.replenReference)

                                    replenCompleted = true
                                    break
                                }
                            } else {
                                break
                            }
                        }

                        // get Case Level Replen For Each Pick
//						if(requiredUOM == "EACH"){
//
//							def caseLevelReplenishment = getCaseLevelReplenInventory(companyId, replenishmentLocation.locationId, itemId, inventoryStatus, requiredQuantity)
//
//							if(caseLevelReplenishment){
//								// Create Replen Demand
//								// Create Replen Work
//								replenCompleted = true
//								break
//							}
//						}
                    }
                }
            }
        }

        return replenCompleted

    }

    def getPalletLevelReplenInventory(companyId, locationId, itemId, inventoryStatus, requiredQuantity, requiredUOM) {

        def sqlQuery = ""
        if (requiredUOM == HandlingUom.CASE) {
            sqlQuery = "SELECT  DISTINCT i.*, i.quantity AS total_quantity, iea.location_id AS physical_location_id " +
                    "FROM inventory AS i " +
                    "LEFT JOIN inventory_entity_attribute AS iea ON i.associated_lpn = iea.lpn " +
                    "WHERE i.company_id = '${companyId}' " +
                    "AND iea.location_id = '${locationId}' " +
                    "AND i.item_id = '${itemId}' " +
                    "AND i.inventory_status = '${inventoryStatus}' " +
                    "AND handling_uom = '${HandlingUom.CASE}' " +
                    //"AND i.quantity > '${requiredQuantity}' " +
                    "ORDER BY total_quantity DESC " +
                    "LIMIT 0,1"
        } else {

            sqlQuery = "SELECT  DISTINCT i.*, " +
                    "SUM( " +
                    "CASE " +
                    "WHEN i.handling_uom = '${HandlingUom.CASE}' " +
                    "THEN (i.quantity * it.eaches_per_case) " +
                    "ELSE i.quantity " +
                    "END) AS total_quantity, " +
                    "iea.location_id AS physical_location_id " +

                    "FROM inventory AS i " +
                    "LEFT JOIN inventory_entity_attribute AS iea ON i.associated_lpn = iea.lpn " +
                    "INNER JOIN item AS it ON i.item_id = it.item_id " +

                    "WHERE i.company_id = '${companyId}' " +
                    "AND iea.location_id = '${locationId}' " +
                    "AND i.item_id = '${itemId}' " +
                    "AND i.inventory_status = '${inventoryStatus}' " +

                    "GROUP BY i.associated_lpn " +
                    //"HAVING total_quantity > '${requiredQuantity}' " +
                    "ORDER BY total_quantity DESC " +
                    "LIMIT 0,1"

        }
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def getCaseLevelReplenInventory(companyId, locationId, itemId, inventoryStatus, requiredQuantity) {

        def sqlQuery = "SELECT  DISTINCT i.*, i.quantity AS total_quantity " +
                "FROM inventory AS i " +
                "LEFT JOIN inventory_entity_attribute AS iea ON i.associated_lpn = iea.lpn " +
                "WHERE i.company_id = '${companyId}' " +
                "AND iea.location_id = '${locationId}' " +
                "AND i.item_id = '${itemId}' " +
                "AND i.inventory_status = '${inventoryStatus}' " +
                "AND handling_uom = '${HandlingUom.EACH}' " +
                "AND i.total_quantity > '${requiredQuantity}' " +
                "ORDER BY i.total_quantity ASC " +
                "LIMIT 0,1"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def createReplenWork(companyId, itemId, inventoryStatus, quantity, quantityUom, sourceLocationId, destinationLocationId) {
        def replenWork = new ReplenWork()
        replenWork.companyId = companyId
        replenWork.replenReference = Math.random() * quantity * 10000000
        replenWork.itemId = itemId
        replenWork.replenInventoryStatus = inventoryStatus
        replenWork.replenQuantityUom = quantityUom
        replenWork.replenQuantity = quantity
        replenWork.sourceLocationId = sourceLocationId
        replenWork.destinationLocationId = destinationLocationId
        replenWork.replenWorkStatus = "A"
        replenWork.replenWorkLevel = "P" //TODO
        replenWork.save(flush: true, failOnError: true)
        return replenWork
    }

    def createAllocationRule(companyId, orderLineNumber, attributeName, attributeValue) {
        def allocationRule = new AllocationRule()
        allocationRule.properties = [companyId      : companyId,
                                     orderLineNumber: orderLineNumber,
                                     attributeName  : attributeName,
                                     attributeValue : attributeValue]
        allocationRule.save(flush: true, failOnError: true)
    }

}
