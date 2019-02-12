package com.foysonis.picking

import com.foysonis.item.HandlingUom
import com.foysonis.kitting.KittingOrderStatus
import com.foysonis.orders.OrderStatus
import com.foysonis.orders.ShipmentStatus
import com.foysonis.orders.Wave
import grails.transaction.Transactional
import com.foysonis.orders.ShipmentLine
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.inventory.Inventory
import com.foysonis.item.Item
import com.foysonis.orders.ShipmentLine
import com.foysonis.orders.Shipment
import com.foysonis.orders.OrderLine
import com.foysonis.orders.Orders
import com.foysonis.inventory.InventorySummary
import com.foysonis.area.Location
import com.foysonis.receiving.InventoryNotes
import com.foysonis.kitting.KittingOrder
import com.foysonis.kitting.KittingOrderComponent

import groovy.sql.Sql


@Transactional
class PickingService {
    def sessionFactory
    def inventorySummaryService
    def entityLastRecordService

    //(pallet pick & Replens)
    def findPalletPick(companyId) {
        return PickWork.findAll("FROM PickWork WHERE companyId = '${companyId}' AND pickLevel = 'P' AND pickStatus != 'Pick Completed' ORDER BY workReferenceNumber ASC")
    }


    def findCompletedPalletPick(companyId) {
        return PickWork.findAllByCompanyIdAndPickLevelAndPickStatus(companyId, 'P', 'Pick Completed')
    }


    def confirmPalletLpnForPalletPick(companyId, username, workReferenceNumber, lpn, level, locationId, itemId, inventoryStatus, quantity, handlingUom) {
        def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
        def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, pickWork.orderLineNumber)
        if (allocationRuleData) {
            switch(allocationRuleData.attributeName) { 
             case "Lpn": 
                if (lpn != allocationRuleData.attributeValue) {
                    return [confirmedResult: false, error: "This lpn is invalid"]
                }
                else{
                    return palletLpnValidationForPalletPick(companyId, username, workReferenceNumber, lpn, level, locationId, itemId, inventoryStatus, quantity, handlingUom)                    
                }
                break; 
             default: 
                return [confirmedResult: false, error: "This Pallet is not in the source Location"]
                break; 
            }            
        }
        else {
            return palletLpnValidationForPalletPick(companyId, username, workReferenceNumber, lpn, level, locationId, itemId, inventoryStatus, quantity, handlingUom)             
        }

    }

    def palletLpnValidationForPalletPick(companyId, username, workReferenceNumber, lpn, level, locationId, itemId, inventoryStatus, quantity, handlingUom) {
        def warningMessage = null
        def isConfirmed = null
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevelAndLocationId(companyId, lpn, level, locationId)
        if (inventoryEntityAttribute) {
            def lpnAsParent = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, lpn)
            def inventory = Inventory.findByCompanyIdAndItemIdAndInventoryStatusAndAssociatedLpnAndQuantityAndHandlingUom(companyId, itemId, inventoryStatus, lpn, quantity, handlingUom)
            def countConfirm = 0
            if (lpnAsParent.size() > 0) {
                def qtyFromCaseInv = 0
                for (parentIea in lpnAsParent) {
                    def inventoryForParentLpn = Inventory.findByCompanyIdAndItemIdAndInventoryStatusAndAssociatedLpnAndHandlingUom(companyId, itemId, inventoryStatus, parentIea.lPN, handlingUom)
                    def inventoryNote = InventoryNotes.findByCompanyIdAndLPN(companyId, parentIea.lPN)
                    qtyFromCaseInv = qtyFromCaseInv + inventoryForParentLpn.quantity.toInteger()
                    println "inventoryForParentLpn.quantity.toInteger() --"+inventoryForParentLpn.quantity.toInteger()
                    println "qtyFromCaseInv --"+qtyFromCaseInv
                    if (inventoryForParentLpn) {
                        //validate pallet lpn for expiration
                        if (inventoryForParentLpn.expirationDate) {
                            if (new Date() > inventoryForParentLpn.expirationDate) {
                                // abort function
                                warningMessage = "Expired pallets cannot be picked"
                                isConfirmed = false
                            } else {
                                def sqlQuery = "SELECT * FROM inventory as i " +
                                        "INNER JOIN inventory_entity_attribute as iea ON iea.lpn = i.associated_lpn AND iea.company_id = '${companyId}' " +
                                        "WHERE i.company_id = '${companyId}' AND iea.level = '${level}' AND i.item_id = '${itemId}' AND i.inventory_status = '${inventoryStatus}' AND i.quantity = '${quantity}' AND iea.location_id = '${locationId}' AND i.handling_uom = '${handlingUom}' AND i.expiration_date < '${inventoryForParentLpn.expirationDate}' AND i.expiration_date > CURDATE() "
                                def sqlQuery2 = "SELECT iea.* FROM inventory as i " +
                                        "INNER JOIN inventory_entity_attribute as iea ON iea.lpn = i.associated_lpn AND iea.company_id = '${companyId}' " +
                                        "INNER JOIN inventory_entity_attribute as iea2 ON iea.parent_lpn = iea2.lpn AND iea2.company_id = '${companyId}' " +
                                        "WHERE i.company_id = '${companyId}' AND iea2.level = 'PALLET' AND i.item_id = '${itemId}' AND i.inventory_status = '${inventoryStatus}' AND i.quantity = '${quantity}' AND iea2.location_id = 'B-04-B-05' AND i.handling_uom = '${handlingUom}' AND i.expiration_date < '${inventoryForParentLpn.expirationDate}' AND i.expiration_date > CURDATE() "
                                def sql = new Sql(sessionFactory.currentSession.connection())
                                def inventoryByFirstExp = sql.rows(sqlQuery)
                                def parentIeaByFirstExp = sql.rows(sqlQuery2)
                                if (inventoryByFirstExp.size() == 0 && parentIeaByFirstExp.size() == 0) {
                                    //confirmation function
                                    inventoryEntityAttribute.locationId = username
                                    inventoryEntityAttribute.save(flush: true, failOnError: true)

                                    def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
                                    pickWork.palletLpn = lpn
                                    pickWork.lastUpdateUsername = username
                                    inventoryForParentLpn.workReferenceNumber = workReferenceNumber
                                    if (inventoryNote) {
                                        inventoryForParentLpn.pickedInventoryNotes = inventoryNote.notes
                                    }
                                    pickWork.save(flush: true, failOnError: true)
                                    inventoryForParentLpn.save(flush: true, failOnError: true)
                                    isConfirmed = true
                                    warningMessage = null
                                    break
                                } else {
                                    // abort function
                                    warningMessage = "Please pick a pallet on first expired first out basis"
                                    isConfirmed = false
                                }
                            }

                        } else {
                            if (qtyFromCaseInv == quantity.toInteger()) {
                                //confirmation function
                                inventoryEntityAttribute.locationId = username
                                inventoryEntityAttribute.save(flush: true, failOnError: true)

                                def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
                                pickWork.palletLpn = lpn
                                pickWork.lastUpdateUsername = username
                                inventoryForParentLpn.workReferenceNumber = workReferenceNumber
                                if (inventoryNote) {
                                    inventoryForParentLpn.pickedInventoryNotes = inventoryNote.notes
                                }
                                pickWork.save(flush: true, failOnError: true)
                                inventoryForParentLpn.save(flush: true, failOnError: true)
                                isConfirmed = true
                                warningMessage = null
                                break                                  
                            }
                            else{
                                warningMessage = "This Pallet has insufficient quantity"
                                isConfirmed = false
                            }

                        }
                        //end of pallet lpn expiration validation
                    }
                }
            } else if (inventory) {
                //validate pallet lpn for expiration
                if (inventory.expirationDate) {
                    if (new Date() > inventory.expirationDate) {
                        // abort function
                        warningMessage = "Expired pallets cannot be picked"
                        isConfirmed = false
                    } else {
                        def sqlQuery = "SELECT * FROM inventory as i " +
                                "INNER JOIN inventory_entity_attribute as iea ON iea.lpn = i.associated_lpn AND iea.company_id = '${companyId}' " +
                                "WHERE i.company_id = '${companyId}' AND iea.level = '${level}' AND i.item_id = '${itemId}' AND i.inventory_status = '${inventoryStatus}' AND i.quantity = '${quantity}' AND iea.location_id = '${locationId}' AND i.handling_uom = '${handlingUom}' AND i.expiration_date < '${inventory.expirationDate}' AND i.expiration_date > CURDATE() "
                        def sql = new Sql(sessionFactory.currentSession.connection())
                        def inventoryByFirstExp = sql.rows(sqlQuery)
                        if (inventoryByFirstExp.size() > 0) {
                            // abort function
                            warningMessage = "Please pick a pallet on first expired first out basis"
                            isConfirmed = false

                        } else {
                            //confirmation function
                            inventoryEntityAttribute.locationId = username
                            inventoryEntityAttribute.save(flush: true, failOnError: true)

                            def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
                            pickWork.palletLpn = lpn
                            pickWork.lastUpdateUsername = username
                            inventory.workReferenceNumber = workReferenceNumber
                            inventory.save(flush: true, failOnError: true)
                            pickWork.save(flush: true, failOnError: true)
                            isConfirmed = true
                            warningMessage = null
                        }
                    }

                } else {
                    //confirmation function
                    inventoryEntityAttribute.locationId = username
                    inventoryEntityAttribute.save(flush: true, failOnError: true)

                    def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
                    pickWork.palletLpn = lpn
                    pickWork.lastUpdateUsername = username
                    inventory.workReferenceNumber = workReferenceNumber
                    inventory.save(flush: true, failOnError: true)
                    pickWork.save(flush: true, failOnError: true)
                    isConfirmed = true
                    warningMessage = null
                }
                //end of pallet lpn expiration validation
            } else {
                warningMessage = "This Pallet is not in Source Location"
                isConfirmed = false
            }

        } else {
            warningMessage = "This Pallet is not in Source Location"
            isConfirmed = false

        }
        return [confirmedResult: isConfirmed, error: warningMessage]
    }


    def confirmDestinationLocationForPalletPick(companyId, workReferenceNumber, lpn, destinationLocationId, shipmentId) {
        def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumberAndDestinationLocationId(companyId, workReferenceNumber, destinationLocationId)
        if (pickWork) {
            pickWork.pickStatus = 'Pick Completed'
            pickWork.save(flush: true, failOnError: true)
        }

        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
        if (inventoryEntityAttribute) {
            inventoryEntityAttribute.locationId = destinationLocationId
            inventoryEntityAttribute.save(flush: true, failOnError: true)
        }

        //Change shipment Status
        def getTotalNumberOfCompletedPickWork = PickWork.findAllByCompanyIdAndShipmentIdAndPickStatus(companyId, shipmentId, 'Pick Completed')
        def getTotalNumberOfShipmentByPickWork = PickWork.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        def shipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)

        if (getTotalNumberOfShipmentByPickWork.size() == getTotalNumberOfCompletedPickWork.size()) {

            KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndOrderInfo(companyId, pickWork.orderLineNumber)
            if (kittingOrder && kittingOrder.kittingOrderStatus != KittingOrderStatus.CLOSED) {
                shipment.shipmentStatus = ShipmentStatus.KO_PROCESSING
            } else {
                shipment.shipmentStatus = ShipmentStatus.STAGED
            }

            shipment.save(flush: true, failOnError: true)

        } else {
            shipment.shipmentStatus = ShipmentStatus.ALLOCATED
            shipment.save(flush: true, failOnError: true)
        }

    }


    def findPickWorkStatus(companyId, workReferenceNumber) {
        return PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
    }


    def findActiveAndInProcessReplenishment(companyId) {
        return ReplenWork.findAll("FROM ReplenWork WHERE companyId = '${companyId}' AND replenWorkStatus = 'A' OR replenWorkStatus = 'I' ORDER BY replenReference ASC")
    }


    def findCompletedAndExpiredReplenishment(companyId) {
        return ReplenWork.findAll("FROM ReplenWork WHERE companyId = '${companyId}' AND replenWorkStatus = 'S' OR replenWorkStatus = 'E' ORDER BY replenReference ASC")
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


    def getInventoryByLocation(companyId, selectedLocation) {

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
                "      GROUP BY location_id_2 " +

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
                "      GROUP BY location_id_2  " +
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
                "      GROUP BY location_id_2 " +
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
                "     GROUP BY location_id_2  " +
                " ) " +

                " AS temp WHERE (location_id_2 =  grid_location_id AND pallet_id_2 = grid_pallet_id) GROUP BY i.item_id )  > 1 " +

                "THEN NULL  " +
                "ELSE (   " +
                " SELECT SUM(i2.quantity) as total_quantity  " +
                " FROM inventory as i2   " +
                " LEFT JOIN inventory_entity_attribute as iea2 ON i2.associated_lpn = iea2.lpn  " +
                " LEFT JOIN inventory_entity_attribute as ieap2 ON iea2.parent_lpn = ieap2.lpn  " +
                " WHERE ((i2.location_id IS NOT NULL AND i2.location_id = grid_location_id) OR (iea2.location_id IS NOT NULL AND iea2.location_id = grid_location_id) OR (ieap2.location_id IS NOT NULL AND ieap2.location_id = grid_location_id))  " +
                " AND   " +
                " (grid_pallet_id IS NULL OR ((iea2.level = 'PALLET' AND iea2.lpn = grid_pallet_id) OR (ieap2.level = 'PALLET' AND ieap2.lpn = grid_pallet_id)))  " +
                " AND (i2.handling_uom = grid_handling_uom)  " +
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
                "AS grid_case_id  " +
                "  " +
                "FROM inventory as i   " +
                "INNER JOIN item as it ON i.item_id = it.item_id   " +
                "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn   " +
                "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn   " +
                "WHERE i.company_id = '${companyId}'"


        if (selectedLocation) {
            sqlQuery = sqlQuery + " AND (i.location_id = '${selectedLocation}' OR iea.location_id = '${selectedLocation}' OR ieap.location_id = '${selectedLocation}')"
        }

        sqlQuery = sqlQuery + " GROUP By grid_location_id,  grid_pallet_id "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }


    def getLpnByLocation(companyId, selectedSourceLocation) {
        return InventoryEntityAttribute.findAllByCompanyIdAndLevelAndLocationId(companyId, 'PALLET', selectedSourceLocation)
    }


    def confirmLpn(companyId, username, replenReference, lpn) {
        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
        if (inventoryEntityAttribute) {
            inventoryEntityAttribute.locationId = username
            inventoryEntityAttribute.parentLpn = null
            inventoryEntityAttribute.save(flush: true, failOnError: true)
        }

        def replenWork = ReplenWork.findByCompanyIdAndReplenReference(companyId, replenReference)
        if (replenWork) {
            replenWork.replenWorkStatus = 'I'
            replenWork.assigningUserId = username
            replenWork.lpn = lpn
            replenWork.save(flush: true, failOnError: true)
        }

    }


    def confirmDestinationLocation(companyId, replenReference, destinationLocationId, lpn, workReferenceNumber) {

        def replenWork = ReplenWork.findByCompanyIdAndReplenReferenceAndDestinationLocationIdAndLpn(companyId, replenReference, destinationLocationId, lpn)
        if (replenWork) {
            replenWork.replenWorkStatus = 'S'
            replenWork.save(flush: true, failOnError: true)
        }

        def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
        if (inventoryEntityAttribute) {
            inventoryEntityAttribute.locationId = destinationLocationId
            inventoryEntityAttribute.save(flush: true, failOnError: true)
        }

        for (workReference in workReferenceNumber) {
            def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReference)
            if (pickWork) {
                pickWork.pickStatus = PickWorkStatus.READY_TO_PICK
                pickWork.save(flush: true, failOnError: true)
            }
        }
        return true
    }


    def findReplenishment(companyId, replenReference) {
        return ReplenWork.findByCompanyIdAndReplenReference(companyId, replenReference)
    }


    def findItem(companyId, selectedItem) {
        return Item.findByCompanyIdAndItemId(companyId, selectedItem)
    }


    def confirmCaseLpn(companyId, selectedLocation, selectedLpn) {
        return Inventory.findByCompanyIdAndLocationIdAndAssociatedLpn(companyId, selectedLocation, selectedLpn)
    }


    def confirmCaseLpnForCase(companyId, selectedLocation) {
        def sqlQuery = "SELECT iea.lpn, iea2.location_id FROM inventory_entity_attribute as iea, inventory_entity_attribute as iea2 WHERE iea.company_id = '${companyId}' AND iea.parent_lpn = iea2.lpn AND iea2.location_id ='${selectedLocation}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getLpnByLocationForCase(companyId, selectedSourceLocation) {
        return InventoryEntityAttribute.findAllByCompanyIdAndLevelAndLocationId(companyId, 'CASE', selectedSourceLocation)
    }


    def findPickWorksByReplensWork(companyId, selectedPickWork) {
        def sqlQuery = "SELECT * FROM replen_demand as rd INNER JOIN replen_work as rw ON rd.replen_reference = rw.replen_reference INNER JOIN pick_work as pw ON rd.work_reference_number = pw.work_reference_number WHERE rw.company_id = '${companyId}' AND rd.replen_reference = '${selectedPickWork}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    //get inventories
    def getInventoryByLpn(companyId, selectedLpn) {
        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea WHERE iea.company_id = '${companyId}' AND iea.lpn = '${selectedLpn}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getInventoryByAssociateLpn(companyId, selectedAssociateLpn) {
        def sqlQuery = "SELECT * FROM inventory as i WHERE i.company_id = '${companyId}' AND i.associated_lpn = '${selectedAssociateLpn}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getInventoryByPalletLpn(companyId, selectedWorkReference) {
        def sqlQuery = "SELECT pw.*,ol.item_id,ol.requested_inventory_status FROM pick_work as pw INNER JOIN order_line as ol ON pw.order_line_number = ol.order_line_number WHERE pw.company_id = '${companyId}' AND pw.work_reference_number = '${selectedWorkReference}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    //

    //

    def checkAllPickLevelEach(companyId, pickListId, pickLvl) {

        def result = [:]

        def sqlQuery = "SELECT * FROM pick_work WHERE company_id = '${companyId}' AND pick_list_id = '${pickListId}' AND pick_level = 'C' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        if (rows.size() > 0) {
            result.show = 'noAllEaches'
        } else {
            result.show = 'allEaches'
        }

        return result
    }


    def searchPickList(companyId, pickListStatus, pickListId, customerName) {

        def sqlQuery = "SELECT pl.*, cus.contact_name, cus.customer_id, (SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pl.pick_list_id AND company_id = '${companyId}') as total_pickworks, (SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pl.pick_list_id AND pick_status = '${PickWorkStatus.COMPLETED}' AND company_id = '${companyId}') AS completed_picks, (SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pl.pick_list_id AND pick_status = '${PickWorkStatus.PENDING_REPLEN}' AND company_id = '${companyId}') AS pending_replen FROM pick_list as pl INNER JOIN pick_work as pw ON pw.pick_list_id = pl.pick_list_id AND pw.company_id = '${companyId}' LEFT JOIN orders as ord ON ord.order_number = pw.order_number AND ord.company_id = '${companyId}' LEFT JOIN customer as cus ON ord.customer_id = cus.customer_id AND cus.company_id = '${companyId}' WHERE pl.company_id = '${companyId}'"

        if (pickListStatus) {
            sqlQuery = sqlQuery + " AND pl.pick_list_status = '${pickListStatus}'"
        }

        if (pickListId) {
            def searchKeyWord = '%' + pickListId + '%'
            sqlQuery = sqlQuery + " AND pl.pick_list_id LIKE '${searchKeyWord}'"
        }

        if (customerName) {
            def searchKeyWord = '%' + customerName + '%'
            sqlQuery = sqlQuery + " AND cus.contact_name LIKE '${searchKeyWord}'"
        }

        sqlQuery = sqlQuery + "GROUP BY pl.pick_list_id ORDER BY CASE WHEN pl.pick_list_status = '${PickListStatus.PARTIAL}' THEN 0 WHEN pl.pick_list_status = 'R' THEN 1 WHEN pl.pick_list_status = 'C' THEN 2 END, pl.created_date DESC"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }

    def getAllPickWorkByPickList(companyId, pickListId) {
        //return PickWork.findAll("from PickWork where companyId = '${companyId}' and pickListId = '${pickListId}' and (pickStatus = 'Ready to Pick' or pickStatus = 'Partially picked') order by pickSequence asc")
        def sqlQuery = "SELECT pw.pick_list_id AS pickListId, pw.work_reference_number AS workReferenceNumber, pw.source_location_id AS sourceLocationId, pw.pick_status AS pickStatus, pw.pick_quantity AS pickQuantity, pw.completed_quantity AS completedQuantity, pw.pick_quantity_uom AS pickQuantityUom, pw.order_line_number AS orderLineNumber, pw.destination_location_id AS destinationLocationId, pw.is_skipped AS isSkipped, cus.contact_name AS customerName, cus.company_name AS companyName, ord.notes, itm.item_id AS itemId, itm.item_description AS itemDescription, lv.description AS requestedInventoryStatus, lv.option_value AS reqInvStatusOptionVal, pw.pick_type as pickType, pw.wave_number  FROM pick_work as pw INNER JOIN orders as ord ON ord.order_number = pw.order_number AND ord.company_id ='${companyId}' INNER JOIN customer as cus ON ord.customer_id = cus.customer_id AND cus.company_id = '${companyId}' INNER JOIN location as loc ON loc.location_id = pw.source_location_id AND loc.company_id = '${companyId}'INNER JOIN area as ar ON loc.area_id = ar.area_id AND ar.company_id = '${companyId}' INNER JOIN order_line as ordln ON ordln.order_line_number = pw.order_line_number AND ordln.company_id = '${companyId}' INNER JOIN item as itm ON itm.item_id = ordln.item_id AND itm.company_id = '${companyId}' LEFT JOIN list_value as lv ON lv.option_value = ordln.requested_inventory_status AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' WHERE pw.company_id = '${companyId}' and pw.pick_list_id = '${pickListId}' and (pw.pick_status = '${PickWorkStatus.READY_TO_PICK}' or pw.pick_status = 'Partially picked') GROUP BY pw.work_reference_number order by pw.is_skipped, ar.allocation_order ASC, ar.area_id ASC, loc.travel_sequence ASC, loc.location_id ASC;"

        def sqlQuery2 = "SELECT pw.pick_list_id AS pickListId, pw.work_reference_number AS workReferenceNumber, pw.source_location_id AS sourceLocationId, pw.pick_status AS pickStatus, pw.pick_quantity AS pickQuantity, pw.completed_quantity AS completedQuantity, pw.pick_quantity_uom AS pickQuantityUom, pw.order_line_number AS orderLineNumber, pw.destination_location_id AS destinationLocationId, pw.is_skipped AS isSkipped,itm.item_id AS itemId, itm.item_description AS itemDescription, lv.description AS requestedInventoryStatus, lv.option_value AS reqInvStatusOptionVal, pw.pick_type as pickType, pw.wave_number FROM pick_work as pw INNER JOIN kitting_order as kord ON kord.kitting_order_number = pw.order_number AND kord.company_id ='${companyId}' INNER JOIN kitting_order_component as koc ON koc.id = pw.order_line_number AND koc.company_id = '${companyId}' INNER JOIN item as itm ON itm.item_id = koc.component_item_id AND itm.company_id = '${companyId}' LEFT JOIN list_value as lv ON lv.option_value = koc.component_inventory_status AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' INNER JOIN location as loc ON loc.location_id = pw.source_location_id AND loc.company_id = '${companyId}' INNER JOIN area as ar ON loc.area_id = ar.area_id AND ar.company_id = '${companyId}' WHERE pw.company_id = '${companyId}' and pw.pick_list_id = '${pickListId}' and (pw.pick_status = '${PickWorkStatus.READY_TO_PICK}' or pw.pick_status = '${PickWorkStatus.PARTIALLY_PICKED}') AND pw.pick_type = 'KITTING' GROUP BY pw.work_reference_number order by pw.is_skipped, ar.allocation_order ASC, ar.area_id ASC, loc.travel_sequence ASC, loc.location_id ASC;"

        def sql = new Sql(sessionFactory.currentSession.connection())

        if (sql.rows(sqlQuery).size() > 0) {
            return sql.rows(sqlQuery)
        } else {
            return sql.rows(sqlQuery2)
        }


    }

    def getPickWorkByPickList(companyId, pickListId) {
        return PickWork.findAll("from PickWork where companyId = '${companyId}' and pickListId = '${pickListId}'")
    }

    def getItemAndStatusByOrderLine(companyId, workReferenceNumber) {
        //return OrderLine.findByCompanyIdAndOrderLineNumber(companyId, orderLineNumber)
        def pickWorkData = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
        def orderLineNumber = pickWorkData.orderLineNumber
        def sqlQuery = "SELECT ol.order_number as orderNumber, ol.order_line_number as orderLineNumber, ol.display_order_line_number as displayOrderLineNumber, ol.item_id as itemId, ol.order_line_status as orderLineStatus, ol.ordered_quantity as orderedQuantity, ol.ordereduom as orderedUOM, lv.description as requestedInventoryStatus, lv.option_value as reqInvStatusOptionVal, it.item_description  AS itemDescription FROM order_line as ol LEFT JOIN list_value as lv ON ol.requested_inventory_status = lv.option_value AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' INNER JOIN item AS it ON ol.item_id = it.item_id AND it.company_id = '${companyId}' WHERE ol.company_id = '${companyId}' AND ol.order_line_number = '${orderLineNumber}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }


    def checkPalletIdAndCaseExist(companyId, lpn) {
        return InventoryEntityAttribute.findAllByCompanyIdAndLPN(companyId, lpn)
    }


    def startPalletListPicking(companyId, userId, inventoryEntityData) {

        def inventoryEntityAttribute = new InventoryEntityAttribute()

        inventoryEntityAttribute.properties = [companyId         : companyId,
                                               lPN               : inventoryEntityData.palletId,
                                               level             : 'PALLET',
                                               locationId        : userId,
                                               lastModifiedDate  : new Date(),
                                               createdDate       : new Date(),
                                               lastModifiedUserId: userId]

        inventoryEntityAttribute.save(flush: true, failOnError: true)

    }


    def startCaseListPicking(companyId, userId, inventoryEntityData) {

        def inventoryEntityAttribute = new InventoryEntityAttribute()

        inventoryEntityAttribute.properties = [companyId         : companyId,
                                               lPN               : inventoryEntityData.caseId,
                                               level             : 'CASE',
                                               locationId        : userId,
                                               lastModifiedDate  : new Date(),
                                               createdDate       : new Date(),
                                               lastModifiedUserId: userId]

        inventoryEntityAttribute.save(flush: true, failOnError: true)

    }


    def confirmPickWork(companyId, username, pickWorkData) {
        def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, pickWorkData.workReferenceNumber)
        def orderLine = null

        if (pickWork.pickType == PickWorkType.KITTING) {
            orderLine = [:]
            def kOComponent = KittingOrderComponent.findByCompanyIdAndKittingOrderNumberAndId(companyId, pickWork.orderNumber, pickWork.orderLineNumber)
            orderLine.itemId = kOComponent.componentItemId
            orderLine.requestedInventoryStatus = kOComponent.componentInventoryStatus
            orderLine.orderedUOM = kOComponent.componentUom
        } else {
            orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, pickWork.orderNumber, pickWork.orderLineNumber)
        }

        if (pickWorkData.pickFromType == 'LOCATION') {
            def inventoryList = Inventory.findAllByCompanyIdAndLocationIdAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWork.sourceLocationId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom, [sort: "quantity", order: "desc"])
            if (inventoryList.size() == 1) {
                return completePickWork(companyId, username, pickWorkData, pickWork, orderLine, pickWorkData.completedQty, null)
            } else {
                def toBePickedQty = pickWorkData.completedQty
                def pickDataToReturn = null
                for (inventoryData in inventoryList) {
                    def inventoryQty = inventoryData.quantity
                    println inventoryQty
                    if (toBePickedQty.toInteger() > inventoryData.quantity.toInteger()) {
                        pickDataToReturn = completePickWork(companyId, username, pickWorkData, pickWork, orderLine, inventoryQty, inventoryData.inventoryId)
                        toBePickedQty = toBePickedQty.toInteger() - inventoryQty.toInteger()
                    } else {
                        pickDataToReturn = completePickWork(companyId, username, pickWorkData, pickWork, orderLine, toBePickedQty, inventoryData.inventoryId)
                        break
                    }
                }
                return pickDataToReturn
            }

        } else {
            return completePickWork(companyId, username, pickWorkData, pickWork, orderLine, pickWorkData.completedQty, null)
        }
    }

    def completePickWork(companyId, username, pickWorkData, pickWorkObj, orderLineObj, qtyToComplete, inventoryIdForLoation) {

        //def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, pickWorkData.workReferenceNumber)
        //def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, pickWork.orderNumber, pickWork.orderLineNumber)

        def pickWork = pickWorkObj
        def orderLine = orderLineObj

        def getPickListId = pickWork.pickListId
        def itemRow = Item.findByCompanyIdAndItemId(companyId, orderLine.itemId)

        if (pickWork.completedQuantity == 0) {
            pickWork.completedQuantity = qtyToComplete.toInteger()
        } else {
            pickWork.completedQuantity = pickWork.completedQuantity + qtyToComplete.toInteger()
        }

        if (pickWork.pickQuantity == pickWork.completedQuantity) {
            pickWork.pickStatus = PickWorkStatus.COMPLETED
        } else if (pickWork.pickQuantity > pickWork.completedQuantity) {
            pickWork.pickStatus = PickWorkStatus.PARTIALLY_PICKED
        }


        def inventoryEdit = null
        def inventoryEntityAttrEdit = null

        if (pickWorkData.pickFromType == 'PALLET') {

            if (pickWork.pickQuantityUom == HandlingUom.EACH) {
                inventoryEdit = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatus(companyId, pickWorkData.pickFromPalletId, orderLine.itemId, orderLine.requestedInventoryStatus)
            } else {
                inventoryEdit = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWorkData.pickFromPalletId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
            }

            //inventoryEdit = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWorkData.pickFromPalletId, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedUOM)
        }

        if (pickWorkData.pickFromType == 'CASE') {
            if (itemRow.isCaseTracked == true && pickWork.pickQuantityUom == HandlingUom.EACH) {
                inventoryEdit = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatus(companyId, pickWorkData.pickFromCaseId, orderLine.itemId, orderLine.requestedInventoryStatus)

                if ((inventoryEdit.quantity.toInteger() == qtyToComplete.toInteger()) && (inventoryEdit.handlingUom == HandlingUom.EACH) && pickWorkData.pickToType != 'CARTON') {
                    def validateInventoryExist = inventoryEdit

                    if (validateInventoryExist) {
                        def inventoryNote = InventoryNotes.findByCompanyIdAndLPN(companyId, validateInventoryExist.associatedLpn)
                        validateInventoryExist.workReferenceNumber = pickWorkData.workReferenceNumber
                        if (inventoryNote) {
                            validateInventoryExist.pickedInventoryNotes = inventoryNote.notes
                        }
                        inventoryEntityAttrEdit = InventoryEntityAttribute.findByCompanyIdAndLPNAndLocationIdAndLevel(companyId, pickWorkData.pickFromCaseId, pickWork.sourceLocationId, 'CASE')
                        validateInventoryExist.save(flush: true, failOnError: true)

                        def completedQtyCalculated = qtyToComplete.toInteger()
                        upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, completedQtyCalculated)

                    }
                    inventoryEdit = null
                }
            } else if (itemRow.isCaseTracked == true && pickWork.pickQuantityUom == HandlingUom.CASE) {
                inventoryEdit = null
                def validateInventoryExist = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWorkData.pickFromCaseId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
                if (validateInventoryExist) {
                    def inventoryNote = InventoryNotes.findByCompanyIdAndLPN(companyId, validateInventoryExist.associatedLpn)
                    validateInventoryExist.workReferenceNumber = pickWorkData.workReferenceNumber
                    if (inventoryNote) {
                        validateInventoryExist.pickedInventoryNotes = inventoryNote.notes
                    }
                    inventoryEntityAttrEdit = InventoryEntityAttribute.findByCompanyIdAndLPNAndLocationIdAndLevel(companyId, pickWorkData.pickFromCaseId, pickWork.sourceLocationId, 'CASE')
                    if (!inventoryEntityAttrEdit) {
                        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory_entity_attribute as iea2 ON iea.parent_lpn = iea2.lpn AND iea2.company_id = '${companyId}' WHERE iea.company_id = '${companyId}' AND iea.lpn = '${pickWorkData.pickFromCaseId}' AND iea.level = 'CASE' AND iea2.location_id = '${pickWork.sourceLocationId}'"
                        def sql = new Sql(sessionFactory.currentSession.connection())
                        def parentInvEntityAttr = sql.rows(sqlQuery)
                        if (parentInvEntityAttr.size() > 0) {
                            inventoryEntityAttrEdit = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevelAndParentLpn(companyId, pickWorkData.pickFromCaseId, 'CASE', parentInvEntityAttr[0].lpn)
                            inventoryEntityAttrEdit.parentLpn = ''
                        }
                    }

                    validateInventoryExist.save(flush: true, failOnError: true)

                    def completedQtyCalculated = qtyToComplete.toInteger()
                    if (itemRow.lowestUom == HandlingUom.EACH) {
                        completedQtyCalculated = completedQtyCalculated * itemRow.eachesPerCase.toInteger()
                    }

                    upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, completedQtyCalculated)

                }

            } else {
                inventoryEdit = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWorkData.pickFromCaseId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
            }

        } else if (pickWorkData.pickFromType == 'LOCATION') {
            //inventoryEdit = Inventory.findByCompanyIdAndLocationIdAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWork.sourceLocationId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
            if (inventoryIdForLoation) {
                inventoryEdit = Inventory.findByCompanyIdAndInventoryId(companyId, inventoryIdForLoation)
            } else {
                inventoryEdit = Inventory.findByCompanyIdAndLocationIdAndItemIdAndInventoryStatusAndHandlingUom(companyId, pickWork.sourceLocationId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
            }
        }

        if (inventoryEdit) {

            if (itemRow.isCaseTracked == true && pickWork.pickQuantityUom == HandlingUom.EACH && inventoryEdit.quantity.toInteger() == 1 && inventoryEdit.handlingUom == HandlingUom.CASE) {

                inventoryEdit.quantity = (inventoryEdit.quantity.toInteger() * itemRow.eachesPerCase.toInteger()) - qtyToComplete.toInteger()
                inventoryEdit.handlingUom = orderLine.orderedUOM
                upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, qtyToComplete.toInteger())

            } else if (itemRow.isCaseTracked == false && pickWork.pickQuantityUom == HandlingUom.EACH && inventoryEdit.handlingUom == HandlingUom.CASE) {

                inventoryEdit.quantity = (inventoryEdit.quantity.toInteger() * itemRow.eachesPerCase.toInteger()) - qtyToComplete.toInteger()
                inventoryEdit.handlingUom = orderLine.orderedUOM

                upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, qtyToComplete.toInteger())

            } else {

                inventoryEdit.quantity = inventoryEdit.quantity - qtyToComplete.toInteger()

                if (itemRow.lowestUom == HandlingUom.EACH && pickWork.pickQuantityUom == HandlingUom.CASE) {

                    def completedQtyCalculated = qtyToComplete.toInteger() * itemRow.eachesPerCase.toInteger()
                    upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, completedQtyCalculated)

                } else {
                    upadateInventorySummary(companyId, orderLine.itemId, orderLine.requestedInventoryStatus, qtyToComplete.toInteger())
                }


            }

        }


        def isInventoryUpdated = false
        if (pickWorkData.pickToType == 'PALLET') {
            if (inventoryEntityAttrEdit) {
                inventoryEntityAttrEdit.locationId = null
                inventoryEntityAttrEdit.parentLpn = pickWorkData.pickToPalletId
            } else {
                //updateInventory = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId,pickWorkData.pickToPalletId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
                def pickCompletedQuantity = qtyToComplete.toInteger()
                def sqlQuery = "UPDATE inventory SET quantity = quantity + ${pickCompletedQuantity} WHERE company_id = '${companyId}' AND associated_lpn = '${pickWorkData.pickToPalletId}' AND item_id = '${orderLine.itemId}' AND inventory_status = '${orderLine.requestedInventoryStatus}' AND handling_uom = '${pickWork.pickQuantityUom}'"
                def sql = new Sql(sessionFactory.currentSession.connection())
                sql.execute(sqlQuery)
                if (sql.updateCount > 0)
                    isInventoryUpdated = true
            }

        } else if (pickWorkData.pickToType == 'CARTON') {
            //updateInventory = Inventory.findByCompanyIdAndAssociatedLpnAndItemIdAndInventoryStatusAndHandlingUom(companyId,pickWorkData.pickToCaseId, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
            def pickCompletedQuantity = qtyToComplete.toInteger()
            def sqlQuery = "UPDATE inventory SET quantity = quantity + ${pickCompletedQuantity} WHERE company_id = '${companyId}' AND associated_lpn = '${pickWorkData.pickToCaseId}' AND item_id = '${orderLine.itemId}' AND inventory_status = '${orderLine.requestedInventoryStatus}' AND handling_uom = '${pickWork.pickQuantityUom}'"
            def sql = new Sql(sessionFactory.currentSession.connection())
            sql.execute(sqlQuery)
            if (sql.updateCount > 0)
                isInventoryUpdated = true

        } else {
            if (inventoryEntityAttrEdit) {
                inventoryEntityAttrEdit.locationId = username
            } else {
                //updateInventory = Inventory.findByCompanyIdAndLocationIdAndItemIdAndInventoryStatusAndHandlingUom(companyId,username, orderLine.itemId, orderLine.requestedInventoryStatus, pickWork.pickQuantityUom)
                def pickCompletedQuantity = qtyToComplete.toInteger()
                def sqlQuery = "UPDATE inventory SET quantity = quantity + ${pickCompletedQuantity} WHERE company_id = '${companyId}' AND location_id = '${username}' AND item_id = '${orderLine.itemId}' AND inventory_status = '${orderLine.requestedInventoryStatus}' AND handling_uom = '${pickWork.pickQuantityUom}' AND work_reference_number = '${pickWorkData.workReferenceNumber}' "
                def sql = new Sql(sessionFactory.currentSession.connection())
                sql.execute(sqlQuery)
                if (sql.updateCount > 0)
                    isInventoryUpdated = true

            }

        }

        if (isInventoryUpdated == false) {
            if (inventoryEntityAttrEdit) {
                inventoryEntityAttrEdit.save(flush: true, failOnError: true)
            } else {

                def inventoryNote = InventoryNotes.findByCompanyIdAndLPN(companyId, inventoryEdit.associatedLpn)

                def createInventory = new Inventory()

                createInventory.properties = [companyId          : companyId,
                                              itemId             : orderLine.itemId,
                                              quantity           : qtyToComplete,
                                              handlingUom        : pickWork.pickQuantityUom,
                                              lotCode            : inventoryEdit.lotCode,
                                              expirationDate     : inventoryEdit.expirationDate,
                                              inventoryStatus    : orderLine.requestedInventoryStatus,
                                              workReferenceNumber: pickWorkData.workReferenceNumber]

                if (pickWorkData.pickToType == 'PALLET') {
                    createInventory.associatedLpn = pickWorkData.pickToPalletId
                    createInventory.locationId = null
                } else if (pickWorkData.pickToType == 'CARTON') {
                    createInventory.associatedLpn = pickWorkData.pickToCaseId
                    createInventory.locationId = null
                } else {
                    createInventory.associatedLpn = null
                    createInventory.locationId = username
                }

                //def inventoryIdExist = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
                //if (!inventoryIdExist) {

                //createInventory.inventoryId =  companyId + "00000001"
                //}
                //else{

                //def inventoryIdInteger = inventoryIdExist.inventoryId - companyId
                //def intIndex = inventoryIdInteger.toInteger()
                //intIndex = intIndex + 1
                def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
                def stringIndex = intIndex.toString().padLeft(6, "0")
                createInventory.inventoryId = companyId + stringIndex

                //}

                if (inventoryNote) {
                    createInventory.pickedInventoryNotes = inventoryNote.notes
                }

                createInventory.save(flush: true, failOnError: true)

            }

        }

        try {
            pickWork.save(flush: true, failOnError: true)
        } catch (Exception e1) {
            log.error("Internal error occurred while saving pick work." + e1 + " for company " + companyId)
        }


        if (inventoryEdit) {
            if (inventoryEdit.quantity == 0) {
                def getLpn = inventoryEdit.associatedLpn
                inventoryEdit.delete(flush: true, failOnError: true)
                //def getParentLpn = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, getLpn)
                def checkParentLpnExist = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, getLpn)
                // def checkParentLpnExistInInventory = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, getLpn)
                if (checkParentLpnExist.size() == 0) {
                    // 	getParentLpn.delete(flush: true, failOnError: true)
                    def sqlQuery = "DELETE FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = '${getLpn}' AND (SELECT count(1) FROM inventory  WHERE company_id =  '${companyId}' AND associated_lpn =  '${getLpn}') < 1"
                    def sql = new Sql(sessionFactory.currentSession.connection())
                    sql.execute(sqlQuery)
                }

            } else {
                inventoryEdit.save(flush: true, failOnError: true)
            }
        }
        //checkCompletedPickWorksForPickList(companyId, pickWork)

        return pickWork

    }

    def updateSkippedPickWork(companyId, workReferenceNumber) {
        def pickWorkData = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
        if (pickWorkData) {
            pickWorkData.isSkipped = true
            return pickWorkData.save(flush: true, failOnError: true)
        }
    }

    def upadateInventorySummary(companyId, itemId, inventoryStatus, pickComplQty) {
        def pickCompletedQty = pickComplQty.toInteger()
        def sqlQuery = "UPDATE inventory_summary SET total_quantity = total_quantity - ${pickCompletedQty} , committed_quantity = committed_quantity - ${pickCompletedQty} WHERE company_id = '${companyId}' AND item_id = '${itemId}' AND inventory_status = ${inventoryStatus}"
        def sql = new Sql(sessionFactory.currentSession.connection())
        sql.execute(sqlQuery)

    }

    def reAllocatePickWork(qtyForAllocation) {
        return false
    }

    def cancelPickWork(companyId, workReferenceNumber, reAllocatePick, cancelPickReason) {

        def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, workReferenceNumber)
        def getShipmentLineId = pickWork.shipmentLineId
        def getOrderLineNum = pickWork.orderLineNumber
        def getShipmentId = pickWork.shipmentId
        def getOrderNum = pickWork.orderNumber
        def getPrevPickQty = pickWork.pickQuantity
        def getPrevCompletedQty = pickWork.completedQuantity
        def getPickListId = pickWork.pickListId

        if (reAllocatePick) {
            if (pickWork.completedQuantity == 0) {

                createCancelledPick(companyId, pickWork, cancelPickReason)
                pickWork.delete(flush: true, failOnError: true)
                def isReAllocatable = reAllocatePickWork(getPrevPickQty)//reAllocate pick here
                if (isReAllocatable) {//reAllocation success
                    def getAllPickWorksByPickList = PickWork.findAllByCompanyIdAndPickListId(companyId, getPickListId)

                    if (getAllPickWorksByPickList.size() == 0) {
                        def getPickList = PickList.findByCompanyIdAndPickListId(companyId, getPickListId)
                        getPickList.delete(flush: true, failOnError: true)
                    }
                    return true
                } else {//reAllocation failed

                    def getPickWorkByShipmentLine = PickWork.findAllByCompanyIdAndShipmentLineId(companyId, getShipmentLineId)

                    if (getPickWorkByShipmentLine.size() > 0) {
                        def shipmentLineForQty = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                        shipmentLineForQty.shippedQuantity = shipmentLineForQty.shippedQuantity - getPrevPickQty
                        shipmentLineForQty.save(flush: true, failOnError: true)
                    } else if (getPickWorkByShipmentLine.size() == 0) {
                        def getShipmentLine = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                        def getOrderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, getOrderLineNum)

                        // Delete Shipment Line
                        getShipmentLine.delete(flush: true, failOnError: true)
                        //	Update Inventory Summary
                        inventorySummaryService.updateDecreasedCommittedQuantity(companyId, getOrderLine.itemId, getOrderLine.requestedInventoryStatus, getOrderLine.orderedQuantity, getOrderLine.orderedUOM)

                        def shipmentLineExistForShipmemt = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, getShipmentId)
                        if (shipmentLineExistForShipmemt.size() == 0) {
                            def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, getShipmentId)
                            getShipment.delete(flush: true, failOnError: true)
                            //return true
                        }

                        def getAllPickWorksByPickList = PickWork.findAllByCompanyIdAndPickListId(companyId, getPickListId)
                        if (getAllPickWorksByPickList.size() == 0) {
                            def getPickList = PickList.findByCompanyIdAndPickListId(companyId, getPickListId)
                            getPickList.delete(flush: true, failOnError: true)
                        }

                        def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, getOrderNum)
                        getOrderLine.orderLineStatus = 'UNPLANNED'
                        getOrder.orderStatus = OrderStatus.UNPLANNED
                        getOrderLine.save(flush: true, failOnError: true)
                        getOrder.save(flush: true, failOnError: true)
                    }

                    //return true


                }

            } else if (pickWork.completedQuantity > 0) {
                pickWork.pickQuantity = pickWork.completedQuantity
                pickWork.pickStatus = PickWorkStatus.COMPLETED
                pickWork.save(flush: true, failOnError: true)
                def qtyToBeAllocated = getPrevPickQty - getPrevCompletedQty
                def isReAllocatable = reAllocatePickWork(qtyToBeAllocated)//reAllocate pick here
                if (isReAllocatable) {//re-allocation success
                    def getAllPickWorksByPickList = PickWork.findAllByCompanyIdAndPickListId(companyId, getPickListId)

                    if (getAllPickWorksByPickList.size() == 0) {
                        def getPickList = PickList.findByCompanyIdAndPickListId(companyId, getPickListId)
                        getPickList.delete(flush: true, failOnError: true)
                    }
                } else {//re-allocation failed
                    pickWork.pickQuantity = pickWork.completedQuantity
                    pickWork.pickStatus = PickWorkStatus.COMPLETED
                    pickWork.save(flush: true, failOnError: true)
                    def shipmentLineForQty = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                    shipmentLineForQty.shippedQuantity = shipmentLineForQty.shippedQuantity - (getPrevPickQty - getPrevCompletedQty)
                    shipmentLineForQty.save(flush: true, failOnError: true)
//			            checkCompletedPickWorksForPickList(companyId, pickWork)
                    return true
                }


            }


        }

        // No Reallocate
        else {

            if (pickWork.completedQuantity == 0) {

                createCancelledPick(companyId, pickWork, cancelPickReason)

                pickWork.delete(flush: true, failOnError: true)

                def getPickWorkByShipmentLine = PickWork.findAllByCompanyIdAndShipmentLineId(companyId, getShipmentLineId)

                if (getPickWorkByShipmentLine.size() > 0) {
                    def shipmentLineForQty = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                    shipmentLineForQty.shippedQuantity = shipmentLineForQty.shippedQuantity - getPrevPickQty
                    shipmentLineForQty.save(flush: true, failOnError: true)
                    //	Update Inventory Summary
                    def getOrderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, getOrderLineNum)
                    inventorySummaryService.updateDecreasedCommittedQuantity(companyId, getOrderLine.itemId, getOrderLine.requestedInventoryStatus, getPrevPickQty, getOrderLine.orderedUOM)
                    return true
                } else {
                    def getShipmentLine = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                    def getOrderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, getOrderLineNum)

                    // Delete Shipment Line
                    getShipmentLine.delete(flush: true, failOnError: true)
                    //	Update Inventory Summary
                    inventorySummaryService.updateDecreasedCommittedQuantity(companyId, getOrderLine.itemId, getOrderLine.requestedInventoryStatus, getPrevPickQty, getOrderLine.orderedUOM)

                    def shipmentLineExistForShipmemt = ShipmentLine.findAllByCompanyIdAndShipmentId(companyId, getShipmentId)
                    if (shipmentLineExistForShipmemt.size() == 0) {
                        def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, getShipmentId)
                        getShipment.delete(flush: true, failOnError: true)
                        //return true
                    }

                    def getAllPickWorksByPickList = PickWork.findAllByCompanyIdAndPickListId(companyId, getPickListId)
                    if (getAllPickWorksByPickList.size() == 0) {
                        def getPickList = PickList.findByCompanyIdAndPickListId(companyId, getPickListId)
                        getPickList.delete(flush: true, failOnError: true)
                    }


                    def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, getOrderNum)
                    getOrderLine.orderLineStatus = 'UNPLANNED'
                    getOrder.orderStatus = OrderStatus.UNPLANNED
                    getOrderLine.save(flush: true, failOnError: true)
                    getOrder.save(flush: true, failOnError: true)
                }

                //return true
            } else if (pickWork.completedQuantity > 0) {
                pickWork.pickQuantity = pickWork.completedQuantity
                pickWork.pickStatus = PickWorkStatus.COMPLETED
                pickWork.save(flush: true, failOnError: true)
                def shipmentLineForQty = ShipmentLine.findByCompanyIdAndShipmentIdAndShipmentLineId(companyId, getShipmentId, getShipmentLineId)
                shipmentLineForQty.shippedQuantity = shipmentLineForQty.shippedQuantity - (getPrevPickQty - getPrevCompletedQty)
                shipmentLineForQty.save(flush: true, failOnError: true)
//		            checkCompletedPickWorksForPickList(companyId, pickWork)
                //	Update Inventory Summary

                def getOrderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, getOrderLineNum)
                inventorySummaryService.updateDecreasedCommittedQuantity(companyId, getOrderLine.itemId, getOrderLine.requestedInventoryStatus, (getPrevPickQty - pickWork.pickQuantity), getOrderLine.orderedUOM)

                return true

            }


        }

    }

    def checkCompletedPickWorksForPickList(companyId, pickWork) {
        def totalPickWorkInPickList = PickWork.findAllByCompanyIdAndPickListId(companyId, pickWork.pickListId)
        def totalCompletedPickWorks = PickWork.findAllByCompanyIdAndPickListIdAndPickStatus(companyId, pickWork.pickListId, PickWorkStatus.COMPLETED)

        if (totalPickWorkInPickList && totalCompletedPickWorks) {
            if (totalPickWorkInPickList.size() == totalCompletedPickWorks.size()) {
                def pickList = PickList.findByCompanyIdAndPickListId(companyId, pickWork.pickListId)
                pickList.pickListStatus = PickListStatus.COMPLETED
                pickList.completionDate = new Date()
                pickList.save(flush: true, failOnError: true)
            }
        }
    }

    def createCancelledPick(companyId, pickWork, cancelPickReason) {
        def cancelledPick = new CancelledPick()

        cancelledPick.properties = [
                companyId            : companyId,
                workReferenceNumber  : pickWork.workReferenceNumber,
                shipmentId           : pickWork.shipmentId,
                shipmentLineId       : pickWork.shipmentLineId,
                orderNumber          : pickWork.orderNumber,
                orderLineNumber      : pickWork.orderLineNumber,
                pickQuantity         : pickWork.pickQuantity,
                pickQuantityUom      : pickWork.pickQuantityUom,
                completedQuantity    : pickWork.completedQuantity,
                pickStatus           : pickWork.pickStatus,
                sourceLocationId     : pickWork.sourceLocationId,
                destinationLocationId: pickWork.destinationLocationId,
                destinationAreaId    : pickWork.destinationAreaId,
                pickCreationDate     : pickWork.pickCreationDate,
                lastUpdateDate       : pickWork.lastUpdateDate,
                lastUpdateUsername   : pickWork.lastUpdateUsername,
                pickListId           : pickWork.pickListId,
                pickSequence         : pickWork.pickSequence,
                palletLpn            : pickWork.palletLpn,
                reason               : cancelPickReason
        ]

        cancelledPick.save(flush: true, failOnError: true)
    }

    def checkPalletIdMatchesPicking(companyId, orderLineNumber, locationId, palletId, pickType) {

        def itemIdForInventory = null;
        def inventoryStatusForInventory = null;

        if (pickType == PickWorkType.KITTING) {
            def orderLine = KittingOrderComponent.findByCompanyIdAndId(companyId, orderLineNumber)
            itemIdForInventory = orderLine.componentItemId
            inventoryStatusForInventory = orderLine.componentInventoryStatus
        } else {
            def orderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, orderLineNumber)
            itemIdForInventory = orderLine.itemId
            inventoryStatusForInventory = orderLine.requestedInventoryStatus
        }

        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn WHERE iea.company_id = '${companyId}' AND i.company_id = '${companyId}' AND iea.lpn = '${palletId}' AND iea.level = 'PALLET' AND iea.location_id = '${locationId}' AND i.item_id = '${itemIdForInventory}' AND i.inventory_status = '${inventoryStatusForInventory}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def checkCaseIdMatchesPicking(companyId, orderLineNumber, locationId, caseId, pickType) {

        def itemIdForInventory = null;
        def inventoryStatusForInventory = null;

        if (pickType == PickWorkType.KITTING) {
            def orderLine = KittingOrderComponent.findByCompanyIdAndId(companyId, orderLineNumber)
            itemIdForInventory = orderLine.componentItemId
            inventoryStatusForInventory = orderLine.componentInventoryStatus
        } else {
            def orderLine = OrderLine.findByCompanyIdAndOrderLineNumber(companyId, orderLineNumber)
            itemIdForInventory = orderLine.itemId
            inventoryStatusForInventory = orderLine.requestedInventoryStatus
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn WHERE iea.company_id = '${companyId}' AND i.company_id = '${companyId}' AND iea.lpn = '${caseId}' AND iea.level = 'CASE' AND iea.location_id = '${locationId}' AND i.item_id = '${itemIdForInventory}' AND i.inventory_status = '${inventoryStatusForInventory}'"
        
        // def caseLpnData = sql.rows(sqlQuery)
        // if (caseLpnData.size() > 0) {
        //      return caseLpnData
        // }
        //else{
            def sqlQuery2 = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn INNER JOIN inventory_entity_attribute as iea2 ON iea.parent_lpn = iea2.lpn AND iea2.company_id = '${companyId}' WHERE iea.company_id = '${companyId}' AND i.company_id = '${companyId}' AND iea.lpn = '${caseId}' AND iea.level = 'CASE' AND iea2.location_id = '${locationId}' AND i.item_id = '${itemIdForInventory}' AND i.inventory_status = '${inventoryStatusForInventory}'" 
            //return sql.rows(sqlQuery2) 
        //}

        def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLineNumber)
        if (allocationRuleData) {
            switch(allocationRuleData.attributeName) { 
             case "Lpn": 
                if (caseId != allocationRuleData.attributeValue) {
                    return [[status:"allocationRuleFailed", message:"Invalid Case Id"]]
                }
                else{
                    def caseLpnData = sql.rows(sqlQuery)
                    if (caseLpnData.size() > 0) {
                        return caseLpnData
                    }
                    else{
                        return sql.rows(sqlQuery2)
                    }                     
                }
                break; 
             case "Lot Code": 
                sqlQuery += " AND i.lot_code = '${allocationRuleData.attributeValue}'"
                def caseLpnData = sql.rows(sqlQuery)
                if (caseLpnData.size() > 0) {
                    return caseLpnData
                }
                else{
                    sqlQuery2 += " AND i.lot_code = '${allocationRuleData.attributeValue}'"
                    return sql.rows(sqlQuery2)
                }
                break; 
             default: 
                return []
                break; 
            }            
        }
        else {
            def caseLpnData = sql.rows(sqlQuery)
            if (caseLpnData.size() > 0) {
                return caseLpnData
            }
            else{
                return sql.rows(sqlQuery2)
            }            
        }



    }

    def getPalletIdQtyForValidation(companyId, locationId, palletId) {

        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn WHERE iea.company_id = '${companyId}' AND i.company_id = '${companyId}' AND iea.lpn = '${palletId}' AND iea.level = 'PALLET' AND iea.location_id = '${locationId}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getCaseIdQtyForValidation(companyId, locationId, caseId) {

        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn WHERE iea.company_id = '${companyId}' AND i.company_id = '${companyId}' AND iea.lpn = '${caseId}' AND iea.level = 'CASE' AND iea.location_id = '${locationId}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getLocationForValidation(companyId, locationId, itemId, invStatus) {
        return Inventory.findAllByCompanyIdAndLocationIdAndItemIdAndInventoryStatus(companyId, locationId, itemId, invStatus)
    }

    def getPalletDataForValidation(companyId, locationId, itemId, invStatus) {
        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i ON iea.lpn = i.associated_lpn AND i.company_id = '${companyId}' WHERE iea.company_id = '${companyId}' AND iea.level = 'PALLET' AND iea.location_id = '${locationId}' AND i.item_id = '${itemId}' AND i.inventory_status = '${invStatus}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def checkItemCaseTracked(companyId, workReferenceNumber) {

        def sqlQuery = "SELECT * FROM pick_work as pw INNER JOIN order_line as ol ON pw.order_line_number = ol.order_line_number WHERE pw.company_id = '${companyId}' AND ol.company_id = '${companyId}' AND pw.work_reference_number =  '${workReferenceNumber}' "

        def sqlQuery2 = "SELECT * FROM pick_work as pw INNER JOIN kitting_order_component as koc ON pw.order_line_number = koc.id WHERE pw.company_id = '${companyId}' AND koc.company_id = '${companyId}' AND pw.work_reference_number =  '${workReferenceNumber}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def row = sql.rows(sqlQuery)

        if (row.size() > 0) {
            return Item.findAllByCompanyIdAndItemId(companyId, row[0].item_id)
        } else {
            def row2 = sql.rows(sqlQuery2)
            return Item.findAllByCompanyIdAndItemId(companyId, row2[0].component_item_id)
        }


    }

    def depositePicks(companyId, username, pickData) {

        def destinationLocationId = null
        def isLocationIdOrLocBarcode = Location.findByCompanyIdAndLocationBarcode(companyId, pickData.destinationLocation)
        if (isLocationIdOrLocBarcode) {
            destinationLocationId = isLocationIdOrLocBarcode.locationId
        } else {
            destinationLocationId = pickData.destinationLocation
        }



        def pickList = PickList.findByCompanyIdAndPickListId(companyId, pickData.pickListId)
        if (pickList) {
            def pickWorksData = PickWork.findAllByCompanyIdAndPickListId(companyId, pickData.pickListId)
            if (pickWorksData.size() > 0) {
                Shipment shipment = null
                for (singlePickWorkData in pickWorksData) {
                    def pickedInventoryData = Inventory.findAllByCompanyIdAndWorkReferenceNumber(companyId, singlePickWorkData.workReferenceNumber)
                    if (pickedInventoryData.size() > 0) {
                        for (singleInventoryData in pickedInventoryData) {
                            if (singleInventoryData.locationId == null) {
                                def dataInInventoryEntityAttr = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, singleInventoryData.associatedLpn)
                                if (dataInInventoryEntityAttr) {
                                    if (dataInInventoryEntityAttr.parentLpn == null) {
                                        dataInInventoryEntityAttr.locationId = destinationLocationId
                                        dataInInventoryEntityAttr.save(flush: true, failOnError: true)
                                    } else {
                                        def parentLpnDataInInvEntityAttr = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, dataInInventoryEntityAttr.parentLpn)
                                        parentLpnDataInInvEntityAttr.locationId = destinationLocationId
                                        parentLpnDataInInvEntityAttr.save(flush: true, failOnError: true)
                                    }
                                }
                            } else {
                                singleInventoryData.locationId = destinationLocationId
                                singleInventoryData.save(flush: true, failOnError: true)
                            }
                        }//end inventory loop

                    }

                    // def totalPickWorkForShipment = PickWork.findAllByCompanyIdAndShipmentId(companyId, singlePickWorkData.shipmentId)
                    // def totalCompletedPickWorks = PickWork.findAllByCompanyIdAndShipmentIdAndPickStatus(companyId, singlePickWorkData.shipmentId, "PICK COMPLETED")

                    def totalNotCompletedPickWorks = PickWork.findAll("FROM PickWork as pw WHERE pw.companyId = '${companyId}' AND pw.shipmentId = '${singlePickWorkData.shipmentId}' AND pw.orderLineNumber = '${singlePickWorkData.orderLineNumber}' AND pw.pickStatus != '${PickWorkStatus.COMPLETED}' AND pw.pickType = '${singlePickWorkData.pickType}'")

                    if (destinationLocationId == singlePickWorkData.destinationLocationId) {

                        //if (totalPickWorkForShipment && totalCompletedPickWorks) {
                        if (totalNotCompletedPickWorks.size() == 0) {
                            if (singlePickWorkData.pickType == PickWorkType.KITTING) {

                                PickWork pendingPickWork = PickWork.findByCompanyIdAndOrderNumberAndPickStatusNotEqual(companyId, singlePickWorkData.orderNumber, PickWorkStatus.COMPLETED)

                                if (!pendingPickWork) {
                                    def kittingOrder = KittingOrder.findByCompanyIdAndKittingOrderNumber(companyId, singlePickWorkData.orderNumber)
                                    kittingOrder.kittingOrderStatus = KittingOrderStatus.COMPONENT_READY
                                    kittingOrder.save(flush: true, failOnError: true)
                                }

                            } else {
                                shipment = Shipment.findByCompanyIdAndShipmentId(companyId, singlePickWorkData.shipmentId)

                                shipment.shipmentStatus = ShipmentStatus.STAGED

//									KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndOrderInfo(companyId, singlePickWorkData.orderLineNumber)
//									if(kittingOrder && kittingOrder.kittingOrderStatus != "CLOSED"){
//										shipment.shipmentStatus = 'KO PROCESSING'
//									}
//									else{
//										shipment.shipmentStatus = 'STAGED'
//									}

                                shipment.save(flush: true, failOnError: true)
                            }

                        }
                        //}

                    }


                    checkCompletedPickWorksForPickList(companyId, singlePickWorkData)


                }//end for loop

                if (shipment) {
                    def shipmentLines = ShipmentLine.findAllByCompanyIdAndShipmentIdAndKittingOrderQuantityGreaterThan(companyId, shipment.shipmentId, 0)

                    for (shipmentLine in shipmentLines) {
                        KittingOrder kittingOrder = KittingOrder.findByCompanyIdAndOrderInfo(companyId, shipmentLine.orderLineNumber)
                        if (kittingOrder && kittingOrder.kittingOrderStatus != KittingOrderStatus.CLOSED) {
                            shipment.shipmentStatus = ShipmentStatus.KO_PROCESSING
                            shipment.save(flush: true, failOnError: true)
                            break
                        }
                    }
                }


                return pickWorksData
            }
        }

        // def pickWork = PickWork.findByCompanyIdAndWorkReferenceNumber(companyId, pickData.workReferenceNumber)
        // def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, pickWork.orderNumber, pickWork.orderLineNumber)

        // def destinationLocationId =  pickData.destinationLocation

        // def pickedInventory = null
        // if (pickData.pickToType == 'PALLET') {
        // 	pickedInventory = InventoryEntityAttribute.findByCompanyIdAndLPNAndLocationIdAndLevel(companyId, pickData.pickToPalletId, username,'PALLET')
        // }
        // else if (pickData.pickToType == 'CARTON') {
        // 	pickedInventory = InventoryEntityAttribute.findByCompanyIdAndLPNAndLocationIdAndLevel(companyId, pickData.pickToCaseId, username ,'CASE')
        // }

        // else{
        // 	pickedInventory = Inventory.findByCompanyIdAndLocationIdAndItemIdAndInventoryStatusAndHandlingUom(companyId, username, orderLine.itemId, orderLine.requestedInventoryStatus, orderLine.orderedUOM)
        // }

        // if (pickedInventory) {
        // 	pickedInventory.locationId = destinationLocationId
        // 	pickedInventory.save(flush:true, failOnError: true)
        // }

        //        def totalPickWorkForShipment = PickWork.findAllByCompanyIdAndShipmentId(companyId, pickWork.shipmentId)
        //        def totalCompletedPickWorks = PickWork.findAllByCompanyIdAndShipmentIdAndPickStatus(companyId, pickWork.shipmentId, "PICK COMPLETED")

        //        if (pickData.destinationLocation == pickWork.destinationLocationId) {

        //         if (totalPickWorkForShipment && totalCompletedPickWorks) {
        //             if (totalPickWorkForShipment.size() == totalCompletedPickWorks.size()) {
        //                 def shipment = Shipment.findByCompanyIdAndShipmentId(companyId, pickWork.shipmentId)
        //                 shipment.shipmentStatus = "STAGED"
        //                 shipment.save(flush:true, failOnError:true)
        //             }
        //         }

        //        }

        // checkCompletedPickWorksForPickList(companyId, pickWork)

    }

    def validateDestinationLocation(companyId, destinationLocation) {

        def sqlQuery = "SELECT * FROM location as l INNER JOIN area as a on l.area_id = a.area_id WHERE l.company_id = '${companyId}'  AND a.company_id = '${companyId}' AND (((l.location_id = '${destinationLocation}' OR l.location_barcode = '${destinationLocation}' ) AND a.is_pnd = true) OR (l.location_barcode = '${destinationLocation}' AND a.is_staging = true))"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def row = sql.rows(sqlQuery)
        return row
    }

    def getAllPickListByPickListId(companyId, pickListId) {
        return PickWork.findAllByCompanyIdAndPickListId(companyId, pickListId)
    }

    def getPickStatusCount(companyId) {
        def sqlQuery = "SELECT COUNT(*) total, "
        sqlQuery += "SUM(CASE WHEN pick_status = '${PickWorkStatus.COMPLETED}' THEN 1 ELSE 0 END) completed, "
        sqlQuery += "SUM(CASE WHEN pick_status = '${PickWorkStatus.PARTIALLY_PICKED}' THEN 1 ELSE 0 END) partially_picked, "
        sqlQuery += "SUM(CASE WHEN pick_status = '${PickWorkStatus.PENDING_REPLEN}' THEN 1 ELSE 0 END) pending_replen, "
        sqlQuery += "SUM(CASE WHEN pick_status = '${PickWorkStatus.READY_TO_PICK}' THEN 1 ELSE 0 END) ready_to_pick "
        sqlQuery += "FROM pick_work "
        sqlQuery += " WHERE company_id = '${companyId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getTodayPerformedPicks(companyId) {
        def sqlQuery = "SELECT COUNT(*) as total_pick FROM pick_work "
        sqlQuery += "WHERE pick_status = '${PickWorkStatus.COMPLETED}' "
        sqlQuery += "AND DATE_FORMAT(last_update_date, '%Y-%m-%d')=curdate() "
        sqlQuery += "AND company_id = '${companyId}' "
        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getUserPicks(companyId, userPicksDuration) {
        def sqlQuery = "SELECT last_update_username, COUNT(last_update_username) AS total_count FROM pick_work "
        sqlQuery += "WHERE pick_status = '${PickWorkStatus.COMPLETED}' "
        sqlQuery += "AND last_update_date >= DATE_SUB(CURDATE(), INTERVAL ${userPicksDuration.toInteger()} DAY) AND last_update_date < (CURDATE() + 1) "
        sqlQuery += "AND company_id = '${companyId}' "
        sqlQuery += "GROUP BY last_update_username"
        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getPickListByKittingOrderNumber(companyId, orderNumber) {
        def sqlQuery = "SELECT pick_list_id FROM pick_work WHERE company_id = '${companyId}'  AND order_number = '${orderNumber}' AND pick_list_id IS NOT NULL LIMIT 0,1 "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def row = sql.rows(sqlQuery)
        return row
    }

    //pnd location
    def getPNDLocationByArea(companyId) {
        def sqlQuery = "SELECT * FROM location as l INNER JOIN area as a on l.area_id = a.area_id WHERE l.company_id = '${companyId}'  AND a.company_id = '${companyId}' AND a.is_pnd = true"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def row = sql.rows(sqlQuery)
        return row
    }

    def searchPickListForIOS(companyId, keyWord) {

        def sqlQuery = "SELECT DISTINCT pw.pick_list_id , pw.order_number, pw.shipment_id, cus.contact_name, " +
                "(SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pw.pick_list_id AND company_id = '${companyId}') as total_pickworks, " +
                "(SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pw.pick_list_id AND pick_status = '${PickWorkStatus.COMPLETED}' AND company_id = '${companyId}') AS completed_picks, " +
                "(SELECT COUNT(*) FROM pick_work WHERE pick_list_id = pw.pick_list_id AND pick_status = '${PickWorkStatus.PENDING_REPLEN}' AND company_id = '${companyId}') AS pending_replen " +
                " FROM pick_work AS pw " +
                " INNER JOIN orders AS ord ON ord.order_number = pw.order_number AND ord.company_id='${companyId}' " +
                " INNER JOIN customer AS cus ON cus.customer_id = ord.customer_id AND cus.company_id='${companyId}' " +
                " WHERE pw.company_id='${companyId}' AND pw.pick_list_id IS NOT NULL AND pw.pick_status != '${PickWorkStatus.COMPLETED}' "

        if (keyWord && keyWord != "") {
            keyWord = '%' + keyWord + '%'
            sqlQuery = sqlQuery + " AND (pw.order_number like '${keyWord}' OR  pw.shipment_id like '${keyWord}' OR cus.contact_name like '${keyWord}' OR cus.company_name like '${keyWord}' ) "
        }

        sqlQuery = sqlQuery + "GROUP BY pw.pick_list_id"

        println("Query search pick list " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def row = sql.rows(sqlQuery)
        return row
    }


    def priorDayInventoryPicked(String companyId) {

        def sqlQuery = "SELECT pw.*, lv.description AS inventory_status_desc, ol.item_id AS item_id " +
                "FROM pick_work AS pw " +
                "INNER JOIN order_line AS ol ON ol.order_line_number = pw.order_line_number AND ol.company_id = '${companyId}' " +
                "LEFT JOIN list_value as lv ON lv.option_value = ol.requested_inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
                "WHERE pw.company_id = '${companyId}' AND pw.last_update_date >= CURDATE() - INTERVAL 1 DAY AND pw.last_update_date < CURDATE() "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def createPickWork(PickWork pickWork) {
        pickWork.workReferenceNumber = pickWork.companyId + pickWork.pickLevel + pickWork.pickQuantity + Math.random()
        pickWork.completedQuantity = 0
        pickWork.pickCreationDate = new Date()
        pickWork.lastUpdateDate = new Date()
        pickWork.destinationAreaId = Location.findByCompanyIdAndLocationId(pickWork.companyId, pickWork.destinationLocationId).areaId

        if (pickWork.pickLevel != PickLevel.PALLET) {
            def pickListId = null
            // Check Pick List Available for this wave
            if (pickWork.waveNumber) {
                Wave wave = Wave.findByCompanyIdAndWaveNumber(pickWork.companyId, pickWork.waveNumber)

                def rows = getPickListIdForWavingPickWork(pickWork.companyId, wave.waveNumber, wave.picksPerList)
                if (rows.size() > 0) {
                    pickListId = rows[0].pickListId
                }

//				PickWork wavePickWork = PickWork.findByCompanyIdAndWaveNumber(pickWork.companyId, pickWork.waveNumber)
//				// TODO Maximum picks in a pick list
//				if(wavePickWork && wavePickWork.pickListId){
//					pickListId = wavePickWork.pickListId
//				}

            } else {
                // Check Pick List Available for this shipment
                def shipmentPickWork = PickWork.findByCompanyIdAndShipmentId(pickWork.companyId, pickWork.shipmentId)
                if (shipmentPickWork)
                    pickListId = shipmentPickWork.pickListId

            }

            // Assign Pick List ID
            pickWork.pickListId = pickListId ? pickListId : createPickList(pickWork.companyId).pickListId

        }

        //Change PickList Status
        if (pickWork.pickStatus == PickWorkStatus.PENDING_REPLEN) {
            def pickList = PickList.findByCompanyIdAndPickListId(pickWork.companyId, pickWork.pickListId)

            if (pickList) {
                pickList.pickListStatus = PickListStatus.PARTIAL
                pickList.save(flush: true, failOnError: true)
            }
        }

        pickWork.save(flush: true, failOnError: true)

        return pickWork
    }

    def createKittingPickWork(companyId, kittingOrderComponent, quantity, uom, sourceLocation, destinationLocation, locationTravelSequence, palletLpn, pickLevel, updatedUser, pickStatus) {
        def pickWork = new PickWork()
        pickWork.pickType = PickWorkType.KITTING
        pickWork.companyId = companyId
        pickWork.workReferenceNumber = companyId + pickLevel + quantity + Math.random()
        pickWork.shipmentId = "KITTINGPICKWORK"
        pickWork.shipmentLineId = "KITTINGPICKWORK"
        pickWork.orderNumber = kittingOrderComponent.kittingOrderNumber
        pickWork.orderLineNumber = kittingOrderComponent.id
        pickWork.pickQuantity = quantity
        pickWork.pickQuantityUom = uom
        pickWork.completedQuantity = 0
        pickWork.pickStatus = pickStatus
        pickWork.sourceLocationId = sourceLocation
        pickWork.destinationLocationId = destinationLocation
        pickWork.pickCreationDate = new Date()
        pickWork.lastUpdateDate = new Date()
        pickWork.lastUpdateUsername = updatedUser
        pickWork.pickSequence = locationTravelSequence
        pickWork.destinationAreaId = Location.findByCompanyIdAndLocationId(companyId, destinationLocation).areaId

        if (pickLevel != PickListStatus.PARTIAL) {
            // Check Pick List Available for this shipment
            def pickListId = null
            def kittingPickWork = PickWork.findByCompanyIdAndOrderNumber(companyId, kittingOrderComponent.kittingOrderNumber)
            if (kittingPickWork)
                pickListId = kittingPickWork.pickListId

            // Assign Pick List ID
            pickWork.pickListId = pickListId ? pickListId : createPickList(companyId).pickListId

        }

        //Change PickList Status
        if (pickStatus == PickWorkStatus.PENDING_REPLEN) {
            def pickList = PickList.findByCompanyIdAndPickListId(companyId, pickWork.pickListId)

            if (pickList) {
                pickList.pickListStatus = PickListStatus.PARTIAL
                pickList.save(flush: true, failOnError: true)
            }
        }

        pickWork.palletLpn = palletLpn
        pickWork.pickLevel = pickLevel

        inventorySummaryService.commitInventory(companyId, kittingOrderComponent.componentItemId, kittingOrderComponent.componentInventoryStatus, quantity, uom)

        pickWork.itemId = kittingOrderComponent.componentItemId
        pickWork.save(flush: true, failOnError: true)

        return pickWork

    }

    def createPickList(companyId) {
        def pickList = new PickList()
        pickList.companyId = companyId
        pickList.pickListId = Math.random() * 10000000
        pickList.pickListStatus = PickListStatus.READY_TO_PICK
        pickList.createdDate = new Date()
        pickList.lastUpdateDate = new Date()
        pickList.save(flush: true, failOnError: true)

        return pickList

    }

    def getTotalDepositedPickCountByPickList(companyId, pickListId) {
        def sqlQuery = "select count(pw.work_reference_number) as pickCount FROM pick_work as pw " +
                "INNER JOIN inventory as inv on inv.work_reference_number = pw.work_reference_number and inv.company_id = '${companyId}' " +
                "LEFT JOIN inventory_entity_attribute as iea on inv.associated_lpn = iea.lpn AND iea.company_id = '${companyId}' " +
                "LEFT JOIN inventory_entity_attribute as iea2 on iea.parent_lpn = iea2.lpn and iea2.company_id = '${companyId}' " +
                "WHERE inv.company_id = '${companyId}' and pw.pick_list_id = '${pickListId}' AND " +
                "(CASE WHEN inv.location_id IS null AND inv.associated_lpn is NOT null " +
                "THEN iea.location_id " +
                "ELSE (CASE " +
                "WHEN iea.location_id is null and iea.parent_lpn is NOT null " +
                "THEN iea2.location_id " +
                "ELSE inv.location_id " +
                "END) END)  = pw.destination_location_id "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getPickListIdForWavingPickWork(String companyId, String waveNumber, Integer picksPerList) {

        String sqlQuery = null
        if (picksPerList && picksPerList > 0) {
            sqlQuery = "SELECT pick_list_id AS pickListId " +
                    "FROM pick_work " +
                    "WHERE company_id  = '${companyId}' AND wave_number = '${waveNumber}' AND (SELECT COUNT(pick_list_id) FROM pick_work WHERE company_id  = '${companyId}'  AND wave_number = '${waveNumber}') < '${picksPerList}' " +
                    "GROUP BY pick_list_id; "
        } else {
            sqlQuery = "SELECT pick_list_id AS pickListId " +
                    "FROM pick_work " +
                    "WHERE company_id  = '${companyId}' AND wave_number = '${waveNumber}'  " +
                    "GROUP BY pick_list_id; "
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def getWavePickWorks(String companyId, String waveNumber){

        return  PickWork.findAllByCompanyIdAndWaveNumberAndPickListIdIsNotNull(companyId, waveNumber)
    }


}
