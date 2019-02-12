package com.foysonis.receiving

import com.foysonis.area.Area
import com.foysonis.area.Location
import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import com.foysonis.item.EntityAttribute
import com.foysonis.item.HandlingUom
import com.foysonis.item.Item
import com.foysonis.user.Company
import grails.transaction.Transactional
import groovy.sql.Sql
import org.hibernate.StaleObjectStateException

@Transactional
class ReceivingService {
    def inventoryService
    def inventorySummaryService
    def sessionFactory


    def checkReceiptIdExist(companyId, receiptId) {
        return Receipt.findAllByCompanyIdAndReceiptId(companyId, receiptId)
    }

    def checkReceiptLineNumExist(companyId, receiptLineNum, receiptId) {
        return ReceiptLine.findAllByCompanyIdAndReceiptLineNumberAndReceiptId(companyId, receiptLineNum, receiptId)
    }

    def getReceiptLineNumbers(companyId, receiptId) {
        return ReceiptLine.findAllByCompanyIdAndReceiptId(companyId, receiptId)
    }

    def checkIsReceiptCompleted(companyId, receiptId) {
        return Receipt.findAllByCompanyIdAndReceiptIdAndCompleteDateIsNotNull(companyId, receiptId)
    }

    def checkLocationIdExist(companyId, locationId) {
        //def location = Location.findAllByCompanyIdAndLocationId(companyId, locationId)
        //if(!location)
        // location = Location.findAllByCompanyIdAndLocationBarcode(companyId, locationId)

        //return location
        def sqlQuery = "SELECT * FROM location as loc INNER JOIN area as a ON a.area_id = loc.area_id AND a.company_id = '${companyId}' WHERE loc.company_id = '${companyId}' AND (loc.location_id = '${locationId}' OR loc.location_barcode = '${locationId}')"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)

    }

    def completeReceipt(companyId, receiptData) {
        def receipt = Receipt.findByCompanyIdAndReceiptId(companyId, receiptData.receiptId)
        if (receipt) {
            receipt.completeDate = new Date()
            try {
                receipt.save(flush: true, failOnError: true)
            } catch (Exception e) {
                log.error("Error occurred " + e)
            }
        }
    }

    def reOpenReceipt(companyId, receiptData) {
        def receipt = Receipt.findByCompanyIdAndReceiptId(companyId, receiptData.receiptId)
        if (receipt) {
            receipt.completeDate = null
            try {
                receipt.save(flush: true, failOnError: true)
            } catch (Exception e) {
                log.error("Error occurred " + e)
            }
        }
    }

    def saveReceipt(receiptData, username, companyId) {

        Receipt receipt = new Receipt()

        def convertedReceiptDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", receiptData.receiptDate)
        receipt.properties = [receiptId       : receiptData.receiptId,
                              receiptDate     : convertedReceiptDate,
                              companyId       : companyId,
                              userId          : username,
                              inboundTruckId  : receiptData.inboundTruckId,
                              inboundProNumber: receiptData.inboundProNumber,
                              receiptType     : receiptData.receiptType,
                              customerId      : receiptData.customerId]




        for (receiptLineData in receiptData.receiptLine) {
            def receiptLine = new ReceiptLine()

            def receiptLineIdExist = ReceiptLine.find("from ReceiptLine as rcl where rcl.companyId='${companyId}' order by receiptLineId DESC")

            if (!receiptLineIdExist) {
                receiptLine.receiptLineId = companyId + "000001"
            } else {
                def receiptLineIdInteger = receiptLineIdExist.receiptLineId - companyId
                def intIndex = receiptLineIdInteger.toInteger()
                intIndex = intIndex + 1
                def stringIndex = intIndex.toString().padLeft(6, "0")
                receiptLine.receiptLineId = companyId + stringIndex
            }

            receiptLine.companyId = companyId
            receiptLine.receiptLineNumber = receiptLineData.receiptLineNumber
            receiptLine.receiptId = receiptData.receiptId
            receiptLine.itemId = receiptLineData.itemId
            receiptLine.expectedQuantity = receiptLineData.expectedQuantity.toInteger()
            receiptLine.uom = receiptLineData.uom

            if (receiptLine.expectedLotCode == '') {
                receiptLine.expectedLotCode = null
            } else {
                receiptLine.expectedLotCode = receiptLineData.expectedLotCode
            }

            if (receiptLineData.expectedExpirationDate == null || receiptLineData.expectedExpirationDate == '') {
                receiptLineData.expectedExpirationDate = null
            } else {
                def convertedReceiptLineDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", receiptLineData.expectedExpirationDate)
                receiptLine.expectedExpirationDate = convertedReceiptLineDate

            }

            receiptLine.save(flush: true, failOnError: true)
        }

        try {
            receipt.save(flush: true, failOnError: true)
        } catch (Exception e) {
            log.error("Error occurred " + e)
        }

    }


    def updateReceipt(receiptData, username, companyId) {

        def receipt = Receipt.findByCompanyIdAndReceiptId(companyId, receiptData.receiptId)

        if (receipt) {

            def convertedReceiptDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", receiptData.receiptDate)
            receipt.properties = [receiptDate     : convertedReceiptDate,
                                  userId          : username,
                                  inboundTruckId  : receiptData.inboundTruckId,
                                  inboundProNumber: receiptData.inboundProNumber,
                                  receiptType     : receiptData.receiptType,
                                  customerId      : receiptData.customerId]




            for (receiptLineData in receiptData.receiptLine) {

                if (receiptLineData.receiptLineId != null) {


                    def receiptLine = ReceiptLine.findByCompanyIdAndReceiptIdAndReceiptLineId(companyId, receiptData.receiptId, receiptLineData.receiptLineId)
                    if (receiptLine) {

                        receiptLine.receiptLineNumber = receiptLineData.receiptLineNumber
                        receiptLine.receiptId = receiptData.receiptId
                        receiptLine.itemId = receiptLineData.itemId
                        receiptLine.expectedQuantity = receiptLineData.expectedQuantity.toInteger()
                        receiptLine.uom = receiptLineData.uom

                        if (receiptLine.expectedLotCode == '') {
                            receiptLine.expectedLotCode = null
                        } else {
                            receiptLine.expectedLotCode = receiptLineData.expectedLotCode
                        }

                        if (receiptLineData.expectedExpirationDate == null || receiptLineData.expectedExpirationDate == '') {
                            receiptLineData.expectedExpirationDate = null
                        } else {
                            def convertedReceiptLineDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", receiptLineData.expectedExpirationDate)
                            receiptLine.expectedExpirationDate = convertedReceiptLineDate

                        }

                        receiptLine.save(flush: true, failOnError: true)

                    }

                } else {

                    def receiptLine = new ReceiptLine()
                    def receiptLineIdExist = ReceiptLine.find("from ReceiptLine as rcl where rcl.companyId='${companyId}' order by receiptLineId DESC")

                    if (!receiptLineIdExist) {
                        receiptLine.receiptLineId = companyId + "000001"
                    } else {
                        def receiptLineIdInteger = receiptLineIdExist.receiptLineId - companyId
                        def intIndex = receiptLineIdInteger.toInteger()
                        intIndex = intIndex + 1
                        def stringIndex = intIndex.toString().padLeft(6, "0")
                        receiptLine.receiptLineId = companyId + stringIndex
                    }

                    receiptLine.companyId = companyId
                    receiptLine.receiptLineNumber = receiptLineData.receiptLineNumber
                    receiptLine.receiptId = receiptData.receiptId
                    receiptLine.itemId = receiptLineData.itemId
                    receiptLine.expectedQuantity = receiptLineData.expectedQuantity.toInteger()
                    receiptLine.uom = receiptLineData.uom

                    if (receiptLine.expectedLotCode == '') {
                        receiptLine.expectedLotCode = null
                    } else {
                        receiptLine.expectedLotCode = receiptLineData.expectedLotCode
                    }

                    if (receiptLineData.expectedExpirationDate == null) {
                        receiptLineData.expectedExpirationDate = null
                    } else {
                        def convertedReceiptLineDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", receiptLineData.expectedExpirationDate)
                        receiptLine.expectedExpirationDate = convertedReceiptLineDate

                    }

                    try {
                        receiptLine.save(flush: true, failOnError: true)
                    } catch (Exception e1) {
                        log.error("Internal error occurred while saving receipt line." + e1 + " for company " + companyId)
                    }

                }
            }//end loop

            if (receiptData.removedReceiptLineIds.size() > 0) {
                for (removedReceiptLineIds in receiptData.removedReceiptLineIds) {
                    def receiptLineRemove = ReceiptLine.findByCompanyIdAndReceiptIdAndReceiptLineId(companyId, receiptData.receiptId, removedReceiptLineIds)
                    if (receiptLineRemove) {
                        receiptLineRemove.delete(flush: true, failOnError: true)
                    }
                }
            }

            receipt.save(flush: true, failOnError: true)

        }

    }


    def deleteReceipt(companyId, receiptData) {

        def receipt = Receipt.findByCompanyIdAndReceiptId(companyId, receiptData.receiptId)
        if (receipt) {

            def receiptLines = ReceiptLine.findAllByCompanyIdAndReceiptId(companyId, receiptData.receiptId)
            if (receiptLines) {
                for (receiptLine in receiptLines) {
                    receiptLine.delete(flush: true, failOnError: true)
                }
            }
            receipt.delete(flush: true, failOnError: true)

        }
        return receiptData
    }

    def saveReceiveInventory(companyId, receiptLineId, palletId, caseId, uom, quantity, lotCode, expirationDate, inventoryStatus, lastModifiedUserId, itemId, itemNotes, String userId) {

        def company = Company.findByCompanyId(companyId)
        if (company.isQuickbooksEnabled) {
            //TODO: Remove hard-coded vendor details.
            String vendor = "MayooranVendor"
            String customer = "Mayooran"
            String receiptType = "Customer Return"
            /*QuickBooksIntegrationService quickBooks = new QuickBooksIntegrationService();
            quickBooks.receiveInventory(itemId, quantity.toString(), vendor, customer, receiptType);*/
        }

        Item inventoryItem = Item.findByCompanyIdAndItemId(companyId, itemId)

        if (caseId && caseId != '' && uom == "EACH") {

            if (inventoryItem && inventoryItem.eachesPerCase && inventoryItem.eachesPerCase.toInteger() == quantity.toInteger()) {
                uom = "CASE"
                quantity = 1
            }
        }

        ReceiveInventory receiveInventory = new ReceiveInventory()

        def receiveInventoryIdExist = ReceiveInventory.find("from ReceiveInventory as ri where ri.companyId='${companyId}' order by receiveInventoryId DESC")

        if (!receiveInventoryIdExist) {
            receiveInventory.receiveInventoryId = companyId + "000001"
        } else {
            def receiveInventoryIdInteger = receiveInventoryIdExist.receiveInventoryId - companyId
            def intIndex = receiveInventoryIdInteger.toInteger()
            intIndex = intIndex + 1
            def stringIndex = intIndex.toString().padLeft(6, "0")
            receiveInventory.receiveInventoryId = companyId + stringIndex
        }



        receiveInventory.companyId = companyId
        receiveInventory.receiptLineId = receiptLineId
        receiveInventory.itemId = itemId
        receiveInventory.itemDescription = inventoryItem.itemDescription
        receiveInventory.palletId = palletId == "" ? null : palletId

        receiveInventory.caseId = caseId
        receiveInventory.uom = uom
        receiveInventory.quantity = quantity
        receiveInventory.lotCode = lotCode
        receiveInventory.isCompletedPutaway = false
        receiveInventory.createdDate = new Date()
        receiveInventory.locationId = null
        receiveInventory.userId = userId
        if (expirationDate == null) {
            receiveInventory.expirationDate = null
        } else {
            def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", expirationDate)
            receiveInventory.expirationDate = convertedExpirationDate
        }
        receiveInventory.inventoryStatus = inventoryStatus

        ReceiveInventory receiveInventoryExists = null

        if (palletId != null && caseId != null) {
            receiveInventoryExists = ReceiveInventory.findByCompanyIdAndReceiptLineIdAndPalletIdAndCaseId(companyId, receiptLineId, palletId, caseId)
        } else if (palletId != null) {
            receiveInventoryExists = ReceiveInventory.findByCompanyIdAndReceiptLineIdAndPalletIdAndIsCompletedPutaway(companyId, receiptLineId, palletId, true)
        } else if (caseId != null) {
            receiveInventoryExists = ReceiveInventory.findByCompanyIdAndReceiptLineIdAndCaseId(companyId, receiptLineId, caseId)
        }

        if (!receiveInventoryExists) {
            receiveInventory.save(flush: true, failOnError: true)

            //Insert into Inventory Data and Inventory Entity Attributes with TEMPLOCTION Id
            inventoryService.saveInventoryForReceive(companyId, lastModifiedUserId, palletId, caseId, uom, inventoryStatus, itemId, quantity, lotCode, expirationDate)

        }


        if (itemNotes) {
            def inventoryNotes = InventoryNotes.findByCompanyIdAndLPN(companyId, caseId)
            if (inventoryNotes) {
                inventoryNotes.notes = itemNotes
            } else {
                inventoryNotes = new InventoryNotes()
                inventoryNotes.companyId = companyId
                inventoryNotes.lPN = caseId
                inventoryNotes.notes = itemNotes
            }
            inventoryNotes.save(flush: true, failOnError: true)
        }

        return receiveInventory

    }

    def getNotesByCaseId(companyId, caseId) {
        def notesExist = InventoryNotes.findByCompanyIdAndLPN(companyId, caseId)
        if (notesExist) {
            return notesExist
        } else {
            return [notes: null]
        }

    }

    def checkIsInventoryExistForReceiptLine(companyId, receiptLineId) {
        return ReceiveInventory.findAllByCompanyIdAndReceiptLineId(companyId, receiptLineId)

    }

    def getInappropriateQuantityReceiptLine(companyId, receiptId) {

        def receipt = ReceiptLine.findAllByCompanyIdAndReceiptId(companyId, receiptId)
        def getInappQtyReceiptLine = []

        for (receiptData in receipt) {

            //render receiptData.receiptLineId+"<br/>"
            //render receiptData.expectedQuantity
            def sumOfInventoryQty = ReceiveInventory.executeQuery("SELECT SUM(ri.quantity) FROM ReceiveInventory as ri WHERE ri.companyId = '${companyId}' AND ri.receiptLineId = '${receiptData.receiptLineId}'")
            def sumOfRecevedInventoryQty = sumOfInventoryQty.join(",")
            if (sumOfRecevedInventoryQty == 'null') {
                sumOfRecevedInventoryQty = 0
            }

            if (receiptData.expectedQuantity > sumOfRecevedInventoryQty.toInteger()) {
                //render "matching <br/>"
                getInappQtyReceiptLine.add(sumOfRecevedInventoryQty.toInteger())
            }

            //render sumOfRecevedInventoryQty+"<br/><br/>"


        }//end Loop
        return getInappQtyReceiptLine
    }

    def validateQuantityWithReceiptLine(expectedQuantity, receiptLineId, companyId) {


        def validateQuantityList = []

        def sumOfRecevedInventoryQty = ReceiveInventory.executeQuery("SELECT SUM(ri.quantity) FROM ReceiveInventory as ri WHERE ri.companyId = '${companyId}' AND ri.receiptLineId = '${receiptLineId}'")

        if (sumOfRecevedInventoryQty.join(",") != 'null') {
            if (expectedQuantity.toInteger() < sumOfRecevedInventoryQty.join(",").toInteger()) {
                validateQuantityList.add(sumOfRecevedInventoryQty.join(","))

            }
        }
        return validateQuantityList
    }

    def savePutaway(companyId, lpn, caseId, locationId, receiveInventoryId) {

        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)

        if (location == null) {
            location = Location.findByCompanyIdAndLocationBarcode(companyId, locationId)

            if (location != null) {
                locationId = location.locationId
            } else {
                println("Location " + locationId + " is not found for " + companyId)
            }

        }

        Boolean isPutawayCompleted = false

        while (!isPutawayCompleted) {
            InventoryEntityAttribute inventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${lpn}' and iea.locationId = 'TEMPLOCATION' ")


            if (inventoryEntityAttribute && location) {

                def area = Area.findByCompanyIdAndAreaId(companyId, location.areaId)

                if (area.isBin) {
                    def inventoryByAssociatedLpn = null
                    if (caseId) {
                        inventoryByAssociatedLpn = Inventory.findByCompanyIdAndAssociatedLpn(companyId, caseId)
                    } else {
                        inventoryByAssociatedLpn = Inventory.findByCompanyIdAndAssociatedLpn(companyId, lpn)
                    }
                    if (inventoryByAssociatedLpn) {
                        def calculatedQty = 0
                        def itemData = Item.findByCompanyIdAndItemId(companyId, inventoryByAssociatedLpn.itemId)
                        if (inventoryByAssociatedLpn.handlingUom == 'CASE' && itemData.lowestUom == 'EACH') {
                            calculatedQty = inventoryByAssociatedLpn.quantity.toInteger() * itemData.eachesPerCase.toInteger()
                        } else if (inventoryByAssociatedLpn.handlingUom == 'EACH' && itemData.lowestUom == 'EACH') {
                            calculatedQty = inventoryByAssociatedLpn.quantity
                        }
                        inventoryByAssociatedLpn.handlingUom = 'EACH'
                        inventoryByAssociatedLpn.quantity = calculatedQty
                        inventoryByAssociatedLpn.associatedLpn = null
                        inventoryByAssociatedLpn.locationId = locationId
                        try {
                            inventoryByAssociatedLpn.save(flush: true, failOnError: true)
                        } catch (StaleObjectStateException e) {
                            log.error("Error occurred while saving inventory data to the table." + e + " for companyId " + companyId)
                        } catch (Exception e1) {
                            log.error("Internal error occurred while saving inventory data to the table." + e1 + " for company " + companyId)
                        }
                    }
                } else {

                    inventoryEntityAttribute.locationId = locationId
                    if (inventoryEntityAttribute.parentLpn) {
                        def parentInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.parentLpn ='${inventoryEntityAttribute.parentLpn}' and iea.lPN != '${lpn}' ")
                        if (!parentInventoryEntityAttribute) {
                            def invalidInventoryEntityAttribute = InventoryEntityAttribute.find("from InventoryEntityAttribute as iea where iea.companyId='${companyId}' and iea.lPN ='${inventoryEntityAttribute.parentLpn}' and iea.locationId = 'TEMPLOCATION' ")
                            if (invalidInventoryEntityAttribute)
                                invalidInventoryEntityAttribute.delete(flush: true, failOnError: true)
                        }

                    }
                    inventoryEntityAttribute.parentLpn = null
                    try {
                        inventoryEntityAttribute.save(flush: true, failOnError: true)
                    } catch (StaleObjectStateException e) {
                        log.error("Error occurred while saving inventoryEntityAttribute data to the table." + e + " for companyId " + companyId)
                    } catch (Exception e1) {
                        log.error("Internal error occurred while saving inventoryEntityAttribute data to the table." + e1 + " for company " + companyId)
                    }

                }

                //Update Inventory Summary

                if (area.isStorage) {
                    if (receiveInventoryId) {
                        def receiveInventory = ReceiveInventory.findByCompanyIdAndReceiveInventoryId(companyId, receiveInventoryId)
                        def receiptLine = ReceiptLine.findByCompanyIdAndReceiptLineId(companyId, receiveInventory.receiptLineId)
                        inventorySummaryService.updateIncreasedInventory(companyId, receiptLine.itemId, receiveInventory.inventoryStatus, receiveInventory.quantity, receiveInventory.uom)

                    } else {
                        def receiveInventories = ReceiveInventory.findAll("from ReceiveInventory as ri where ri.companyId = ? and ri.palletId = ? and ri.isCompletedPutaway != true", companyId, lpn)

                        for (receiveInventory in receiveInventories) {
                            def receiptLine = ReceiptLine.findByCompanyIdAndReceiptLineId(companyId, receiveInventory.receiptLineId)
                            inventorySummaryService.updateIncreasedInventory(companyId, receiptLine.itemId, receiveInventory.inventoryStatus, receiveInventory.quantity, receiveInventory.uom)
                        }
                    }
                }

                // Update ReceiveInventory isCompletedPutaway Status
                if (receiveInventoryId) {

                    def receiveInventory = ReceiveInventory.findByCompanyIdAndReceiveInventoryId(companyId, receiveInventoryId)
                    receiveInventory.isCompletedPutaway = true
                    receiveInventory.locationId = location.locationId
                    receiveInventory.save(flush: true, failOnError: true)

                } else {
                    if (caseId) {
                        ReceiveInventory.executeUpdate("update ReceiveInventory ri set ri.isCompletedPutaway= true where ri.companyId='${companyId}' and ri.caseId='${caseId}' ")
                    } else {
                        ReceiveInventory.executeUpdate("update ReceiveInventory ri set ri.isCompletedPutaway= true where ri.companyId='${companyId}' and ri.palletId='${lpn}' ")
                    }
                }
                if (area.isBin) {
                    if (caseId) {
                        def caseLpnToRemove = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, caseId)
                        def parentLpnOfCase = null
                        if (caseLpnToRemove) {
                            parentLpnOfCase = caseLpnToRemove.parentLpn
                            def checkInventoryForAssociateLpn = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, caseId)
                            if (checkInventoryForAssociateLpn.size() == 0) {
                                caseLpnToRemove.delete(flush: true, failOnError: true)
                            }
                        }
                        if (parentLpnOfCase) {
                            def secondaryInventoryEntityAttr = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, parentLpnOfCase)
                            if (secondaryInventoryEntityAttr.size() == 0) {
                                def parentLpnRowData = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, parentLpnOfCase)
                                if (parentLpnRowData) {
                                    parentLpnRowData.delete(flush: true, failOnError: true)
                                }
                            }
                        }
                    } else {
                        def inventoryByLpn = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, lpn)
                        if (inventoryByLpn.size() == 0) {
                            def lpnRowData = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
                            if (lpnRowData) {
                                lpnRowData.delete(flush: true, failOnError: true)
                            }
                        }
                    }
                }


            } else {
                isPutawayCompleted = true
            }

        }


        return true

    }


    def suggestLocationForPutAway(String companyId, String itemId, String expirationDate) {

        def suggestedLocation = null
        def suggestedLocationBarcode = null
        def suggestedError = null
        def suitableAreaIds = null

        def itemStorageAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigGroupAndConfigKey(companyId, 'ITEM', 'STRG', itemId)
        Item item = Item.findByCompanyIdAndItemId(companyId, itemId)

        //Find Suitable Area
        if (itemStorageAttributes) {

            def suitableAreas = EntityAttribute.findAll("from EntityAttribute as ea where ea.companyId = :companyId and ea.entityId = 'AREAS' and ea.configGroup = 'STRG' and ea.configValue in (:attributes) group by configKey having count(configKey) = :strgCount order by configKey",
                    [companyId: companyId, attributes: itemStorageAttributes['configValue'], strgCount: new Long(itemStorageAttributes.size())])

            //Find Suitable Location
            if (suitableAreas) {

                if (item.lowestUom.toUpperCase() == "CASE" || item.isCaseTracked == true) {

                    def areaWithoutBIN = Area.findAll("from Area as a  where a.companyId = '${companyId}' and a.areaId in ('${suitableAreas['configKey'].join("', '")}') and a.isBin != true order by a.areaId")
                    suitableAreaIds = areaWithoutBIN['areaId']
                } else {
                    suitableAreaIds = suitableAreas['configKey']
                }

                log.info("suitableAreaIds : " + suitableAreaIds)
            }

        } else {

            // Area with Storage Attributes
            def areaWithSTRG = EntityAttribute.findAll("from EntityAttribute as ea where ea.companyId = :companyId and ea.entityId = 'AREAS' and ea.configGroup = 'STRG' order by configKey",
                    [companyId: companyId])

            if (areaWithSTRG) {

                def areaWithoutSTRG = null
                if (item.lowestUom.toUpperCase() == "CASE" || item.lowestUom.toUpperCase() == "PALLET" || item.isCaseTracked == true) {
                    // Area without Storage Attributes
                    areaWithoutSTRG = Area.findAll("from Area as a where a.companyId = '${companyId}' and areaId not in ('${areaWithSTRG['configKey'].join("', '")}') and a.isBin != true and a.isStaging != true and a.isKitting != true order by areaId")
                } else {
                    // Area without Storage Attributes
                    areaWithoutSTRG = Area.findAll("from Area as a where a.companyId = '${companyId}' and areaId not in ('${areaWithSTRG['configKey'].join("', '")}') and a.isStaging != true and a.isKitting != true order by areaId")
                }

                if (areaWithoutSTRG)
                    suitableAreaIds = areaWithoutSTRG['areaId']
            }

        }

        if (suitableAreaIds) {
            def suitableAreaString = null
            for (suitableArea in suitableAreaIds) {
                if (suitableAreaString)
                    suitableAreaString = suitableAreaString + ", '" + suitableArea + "'"
                else
                    suitableAreaString = "'" + suitableArea + "'"
            }

            log.info("suitableAreaString : " + suitableAreaString)

            //Check for Partially Filled Location Order By Sequence Order
            def sqlQuery = "SELECT location_id " +
                    "FROM location " +
                    "WHERE company_id = '${companyId}' AND is_blocked != true AND area_id IN (${suitableAreaString}) AND location_id IN (" +

                    "SELECT DISTINCT " +
                    "CASE " +
                    "WHEN i.location_id IS NOT NULL " +
                    "THEN i.location_id " +
                    "ELSE " +
                    "    CASE " +
                    "    WHEN iea.location_id IS NOT NULL " +
                    "    THEN iea.location_id " +
                    "    ELSE ieap.location_id " +
                    "    END " +
                    "END AS location_id " +
                    "FROM inventory as i  " +
                    "INNER JOIN item as it ON i.item_id = it.item_id  " +
                    "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn  " +
                    "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn  " +
                    "WHERE i.company_id = '${companyId}' AND i.item_id = '${itemId}' "
//                    " ) " +
//                    "AND location_id NOT IN (" +
//
//                    "SELECT DISTINCT " +
//                            "CASE " +
//                            "WHEN i.location_id IS NOT NULL " +
//                            "THEN i.location_id " +
//                            "ELSE " +
//                            "    CASE " +
//                            "    WHEN iea.location_id IS NOT NULL " +
//                            "    THEN iea.location_id " +
//                            "    ELSE ieap.location_id " +
//                            "    END " +
//                            "END AS location_id " +
//                            "FROM inventory as i  " +
//                            "INNER JOIN item as it ON i.item_id = it.item_id  " +
//                            "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn  " +
//                            "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn  " +
//                            "WHERE i.company_id = '${companyId}' AND i.item_id != '${itemId}' "

//TODO
//            if(expirationDate != null){
//                sqlQuery += " AND ((DATE(i.expiration_date) < DATE(NOW())) OR (DATE(i.expiration_date) <  DATE('${expirationDate}') - INTERVAL 15 DAY) OR (DATE(i.expiration_date) >  DATE('${expirationDate}') + INTERVAL 15 DAY)) "
//            }

            sqlQuery += " ) ORDER BY travel_sequence "
            println("sqlQuery : " + sqlQuery)

            def sql = new Sql(sessionFactory.currentSession.connection())
            def rows = sql.rows(sqlQuery)

            //Partially Filled Location Found
            if (rows.size() > 0) {

                for (row in rows) {
                    if (validateMaxLoad(companyId, row['location_id'])) {
                        suggestedLocation = row['location_id']
                        break
                    }
                }


            }

            if (!suggestedLocation) {
                //Check for Empty Location
                def sqlQueryEmptyLocation = "SELECT location_id " +
                        "FROM location " +
                        "WHERE company_id = '${companyId}' AND is_blocked != true AND area_id IN (${suitableAreaString}) AND location_id NOT IN (" +

                        "SELECT " +
                        "CASE " +
                        "WHEN i.location_id IS NOT NULL " +
                        "THEN i.location_id " +
                        "ELSE " +
                        "    CASE " +
                        "    WHEN iea.location_id IS NOT NULL " +
                        "    THEN iea.location_id " +
                        "    ELSE " +
                        "       CASE " +
                        "       WHEN ieap.location_id IS NOT NULL " +
                        "       THEN ieap.location_id " +
                        "       ELSE '' " +
                        "       END " +
                        "    END " +
                        "END AS location_id " +
                        "FROM inventory as i  " +
                        "INNER JOIN item as it ON i.item_id = it.item_id  " +
                        "LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn  " +
                        "LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn  " +
                        "WHERE i.company_id = '${companyId}' " +
                        ") ORDER BY travel_sequence"

                def sqlEmptyLocation = new Sql(sessionFactory.currentSession.connection())
                def rowsEmptyLocation = sqlEmptyLocation.rows(sqlQueryEmptyLocation)

//                suggestedLocation = suitableAreaIds.join(", ")

                // Empty Location Found
                if (rowsEmptyLocation.size() > 0) {

                    suggestedLocation = rowsEmptyLocation['location_id'][0]

                } else {
                    suggestedError = "There are no suitable location found in the entire warehouse because, No locations found because all the locations are either full or there are no partial locations found for this item " + itemId
                }
            }

        } else {
            suggestedError = "There are no suitable location found in the entire warehouse because No area exist with the same storage restrictions as the item " + itemId

        }

        if (suggestedLocation) {
            def loc = Location.findByCompanyIdAndLocationId(companyId, suggestedLocation)
            if (loc)
                suggestedLocationBarcode = loc.locationBarcode
        }

        return [location: suggestedLocation, locationBarcode: suggestedLocationBarcode, error: suggestedError]
    }


    def validateMaxLoad(companyId, locationId) {
        def eachesCount = 0
        def casesCount = 0
        def palletsCount = 0

        //Get inventory Entity Attributes By Location Id
        def inventoryEntityAttributes = InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, locationId)

        if (inventoryEntityAttributes) {

            for (inventoryEntityAttribute in inventoryEntityAttributes) {
                def levelTwoInventoryEntityAttributes = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, inventoryEntityAttribute.lPN)

                if (levelTwoInventoryEntityAttributes) {

                    def levelTwoInventoryEntityAttributeString = null
                    for (lTIEA in levelTwoInventoryEntityAttributes) {
                        if (levelTwoInventoryEntityAttributeString)
                            levelTwoInventoryEntityAttributeString = levelTwoInventoryEntityAttributeString + ", '" + lTIEA['lPN'] + "'"
                        else
                            levelTwoInventoryEntityAttributeString = "'" + lTIEA['lPN'] + "'"
                    }


                    def levelTwoInventorySqlQuery = "select distinct sum(i.quantity) as totalQuantity, i.item_id, i.handling_uom from inventory as i where i.company_id= '${companyId}' and i.associated_lpn in (${levelTwoInventoryEntityAttributeString}) group by i.item_id, i.handling_uom order by i.item_id asc"
                    def sqlLevelTwoInventory = new Sql(sessionFactory.currentSession.connection())
                    def levelTwoInventories = sqlLevelTwoInventory.rows(levelTwoInventorySqlQuery)

                    if (levelTwoInventories.size() > 0) {

                        for (levelTwoInventory in levelTwoInventories) {
                            def item = Item.findByCompanyIdAndItemId(companyId, levelTwoInventory['item_id'])

                            if (levelTwoInventory['handling_uom'] == 'EACH') {
                                eachesCount = levelTwoInventory['totalQuantity']
                                casesCount = (eachesCount / item.eachesPerCase).toInteger()
                            } else if (levelTwoInventory['handling_uom'] == 'CASE') {
                                casesCount = levelTwoInventory['totalQuantity']
                            }
                            palletsCount = palletsCount + (casesCount / item.casesPerPallet).toInteger()
                        }
                    }

                }
            }

//            def levelOneInventories = Inventory.findAll('select distinct sum(i.quantity) as totalQuantity, i.itemId, i.handlingUom from Inventory as i where i.companyId= ? and i.associatedLpn in (?) group by i.itemId, i.handlingUom order by i.itemId asc',
//                    [companyId, inventoryEntityAttributes['lPN'].join(", ")])

            def levelOneInventoryEntityAttributeString = null
            for (lOIEA in inventoryEntityAttributes) {
                if (levelOneInventoryEntityAttributeString)
                    levelOneInventoryEntityAttributeString = levelOneInventoryEntityAttributeString + ", '" + lOIEA['lPN'] + "'"
                else
                    levelOneInventoryEntityAttributeString = "'" + lOIEA['lPN'] + "'"
            }

            def levelOneInventorySqlQuery = "select distinct sum(i.quantity) as totalQuantity, i.item_id, i.handling_uom from inventory as i where i.company_id= '${companyId}' and i.associated_lpn in (${levelOneInventoryEntityAttributeString}) group by i.item_id, i.handling_uom order by i.item_id asc"
            def sqlLevelOneInventory = new Sql(sessionFactory.currentSession.connection())
            def levelOneInventories = sqlLevelOneInventory.rows(levelOneInventorySqlQuery)

            if (levelOneInventories.size() > 0) {

                for (levelOneInventory in levelOneInventories) {

                    def item = Item.findByCompanyIdAndItemId(companyId, levelOneInventory['item_id'])

                    if (levelOneInventory['handling_uom'] == 'EACH') {
                        eachesCount = levelOneInventory['totalQuantity']
                        casesCount = (eachesCount / item.eachesPerCase).toInteger()
                    } else if (levelOneInventory['handling_uom'] == 'CASE') {
                        casesCount = levelOneInventory['totalQuantity']
                    }
                    palletsCount = palletsCount + (casesCount / item.casesPerPallet).toInteger()
                }


            }


        }


        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)

        def locationMaxLoad = EntityAttribute.findByCompanyIdAndEntityIdAndConfigKeyAndConfigGroup(companyId, 'AREAS', location.areaId, 'MAXLOAD')

        if (locationMaxLoad && locationMaxLoad.configValue.toInteger() > palletsCount)
            return true
        else
            return false

    }

    def getCaseReceiveInventory(companyId, palletId, receiptLineId) {
        def receiveInventory = null

        if (palletId) {
            receiveInventory = ReceiveInventory.findAllByCompanyIdAndPalletIdAndReceiptLineId(companyId, palletId, receiptLineId)
        }

        return receiveInventory
    }

    def getCaseReceivePendingPutawayInventory(companyId, palletId, receiptLineId) {

        def sqlQuery = "SELECT ri.pallet_id AS palletId, ri.case_id AS caseId, ri.quantity AS quantity, ri.uom AS uom, ri.lot_code AS lotCode, ri.expiration_date AS expirationDate, ri.inventory_status AS inventoryStatus, ri.receive_inventory_id AS receiveInventoryId, ri.receipt_line_id AS receiptLineId, ri.is_completed_putaway AS isCompletedPutaway, rl.item_id AS itemId" +
                " FROM receive_inventory AS ri INNER JOIN receipt_line as rl ON ri.receipt_line_id = rl.receipt_line_id  " +
                " WHERE ri.company_id = '${companyId}' AND rl.company_id = '${companyId}' AND ri.pallet_id = '${palletId}' AND rl.receipt_line_id = '${receiptLineId}' " +
                " ORDER BY ri.receive_inventory_id DESC"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows
    }


    def getReceiveInventoryForSearchRow(companyId, selectedRowReceiptLine) {

        def sqlQuery = "SELECT rl.receipt_line_id, " +
                "ri.pallet_id, " +
                "COUNT(ri.pallet_id) as pallet_item_count, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.case_id " +
                "END AS case_id, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.quantity " +
                "END AS quantity, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.uom " +
                "END AS uom, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.lot_code " +
                "END AS lot_code, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.lot_code " +
                "END AS lot_code, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.expiration_date " +
                "END AS expiration_date, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE " +
                "CASE WHEN ri.expiration_date IS NOT NULL AND ri.expiration_date <  NOW() " +
                "THEN 'EXPIRED' " +
                "ELSE (SELECT distinct lv.description FROM receive_inventory as ri2 LEFT JOIN list_value as lv ON ri2.inventory_status = lv.option_value WHERE lv.company_id = '${companyId}' AND lv.option_value = ri.inventory_status AND lv.option_group = 'INVSTATUS' ) " +
                "END " +
                "END AS inventory_status, " +
//                "CASE " +
//                "WHEN COUNT(ri.pallet_id) > 1 " +
//                "THEN null " +
//                "ELSE ri.is_completed_putaway " +
//                "END AS is_completed_putaway, " +
//                "CASE " +
//                "WHEN COUNT(ri.pallet_id) > 1 " +
//                "THEN " +
//                "CASE " +
//                "WHEN (SELECT COUNT(*) FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = ri.pallet_id AND location_id = 'TEMPLOCATION') > 0 " +
//                "THEN NULL " +
//                "ELSE true " +
//                "END " +
//                "ELSE ri.is_completed_putaway " +
                "ri.is_completed_putaway AS is_completed_putaway1, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.receive_inventory_id " +
                "END AS receive_inventory_id,inote.notes " +
                "FROM receipt_line as rl  " +
                "INNER JOIN receive_inventory as ri ON rl.receipt_line_id = ri.receipt_line_id  " +
                "LEFT JOIN inventory_notes as inote ON ri.case_id = inote.lpn " +
                "WHERE rl.company_id = '${companyId}'  " +
                "AND rl.receipt_line_id = '${selectedRowReceiptLine}'  " +
                "GROUP   BY  CASE WHEN (ri.pallet_id IS NOT  NULL AND ri.pallet_id != '') THEN ri.pallet_id  ELSE ri.case_id END " +
                "ORDER BY receive_inventory_id DESC"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getPendingPutawayInventory(companyId) {

        def sqlQuery = "SELECT rl.receipt_line_id, rl.item_id, rl.receipt_id, " +
                "ri.pallet_id, " +
                "COUNT(ri.pallet_id) as pallet_item_count, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.case_id " +
                "END AS case_id, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.quantity " +
                "END AS quantity, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.uom " +
                "END AS uom, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.lot_code " +
                "END AS lot_code, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.lot_code " +
                "END AS lot_code, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.expiration_date " +
                "END AS expiration_date, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE " +
                "CASE WHEN ri.expiration_date IS NOT NULL AND ri.expiration_date <  NOW() " +
                "THEN 'EXPIRED' " +
                "ELSE (SELECT distinct lv.description FROM receive_inventory as ri2 LEFT JOIN list_value as lv ON ri2.inventory_status = lv.option_value WHERE lv.company_id = '${companyId}' AND lv.option_value = ri.inventory_status AND lv.option_group = 'INVSTATUS' ) " +
                "END " +
                "END AS inventory_status, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.is_completed_putaway " +
                "END AS is_completed_putaway, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN " +
                "CASE " +
                "WHEN (SELECT COUNT(*) FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = ri.pallet_id AND location_id = 'TEMPLOCATION') > 0 " +
                "THEN NULL " +
                "ELSE true " +
                "END " +
                "ELSE ri.is_completed_putaway " +
                "END AS is_completed_putaway1, " +
                "CASE " +
                "WHEN COUNT(ri.pallet_id) > 1 " +
                "THEN null " +
                "ELSE ri.receive_inventory_id " +
                "END AS receive_inventory_id,inote.notes " +
                "FROM receipt_line as rl  " +
                "INNER JOIN receive_inventory as ri ON rl.receipt_line_id = ri.receipt_line_id  " +
                "LEFT JOIN inventory_notes as inote ON ri.case_id = inote.lpn " +
                "WHERE rl.company_id = '${companyId}'  AND ri.is_completed_putaway != true " +
                "GROUP   BY  CASE WHEN (ri.pallet_id IS NOT  NULL AND ri.pallet_id != '') THEN ri.pallet_id  ELSE ri.case_id END " +
                "ORDER BY rl.receipt_line_id DESC"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getReceiptsForGoogleData(companyId, receiptDuration) {
        def sqlQuery = "SELECT COUNT(complete_date) AS completed, (COUNT(*) - COUNT(complete_date)) AS opened FROM receipt WHERE company_id = '${companyId}' "

        if (receiptDuration) {
            sqlQuery += "AND receipt_date >= DATE_SUB(CURDATE(), INTERVAL ${receiptDuration.toInteger()} DAY) AND receipt_date < (CURDATE() + 1)"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())

        return sql.rows(sqlQuery)
    }

    def getReceivedOpenedLinesCount(companyId) {
        def sqlQuery = "SELECT  COUNT(DISTINCT rl.receipt_line_id) AS total_lines, COUNT(DISTINCT ri.receipt_line_id) AS received_lines, (COUNT(DISTINCT rl.receipt_line_id) - COUNT(DISTINCT ri.receipt_line_id)) AS open_for_receive  "
        sqlQuery += "FROM receipt_line AS rl "
        sqlQuery += "LEFT JOIN receive_inventory AS ri ON rl.receipt_line_id = ri.receipt_line_id "
        sqlQuery += "WHERE rl.company_id = '${companyId}' "

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getReceiptLineNumberForSearchRow(companyId, selectedRowReceipt) {

        def sqlQuery = "SELECT r.receipt_id, r.owner_id, r.complete_date, itm.item_description, rl.* from receipt as r INNER JOIN receipt_line as rl ON r.receipt_id = rl.receipt_id INNER JOIN item as itm ON itm.item_id = rl.item_id AND itm.company_id = '${companyId}' WHERE r.company_id = '${companyId}' AND rl.company_id = '${companyId}' AND r.receipt_id = \"${selectedRowReceipt}\" ORDER BY receipt_line_id ASC"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        if (rows.size() > 0) {
            for (def i = 0; i < rows.size(); i++) {
                def calculatedReceivedQty = calculateReceivedInventoryQty(companyId, rows[i].receipt_line_id, rows[i].item_id)
                rows[i].calculated_received_qty = calculatedReceivedQty.totalReceivedQty
            }
        }
        return rows
    }

    def searchResults(companyId, receiptId, receiptDate, toReceiptDate, status, receiptType, currentPageNum, totalRetrieveAmt, searchResultsForCount) {
        def sqlQuery = null
        if (searchResultsForCount == true) {
            sqlQuery = "SELECT COUNT(r.receipt_id) AS totalReceiptDataCount " +
                        "from receipt as r LEFT JOIN owner as own ON r.owner_id = own.owner_id AND own.company_id = '${companyId}' "+
                        "WHERE r.company_id = '${companyId}' "            
        }

        else{
            sqlQuery = "SELECT r.*, own.owner_name, " +
                    "CASE WHEN r.complete_date IS NOT NULL THEN 'Close' WHEN r.complete_date IS NULL THEN 'Open' END AS grid_status, " +
                    " GetReceiptStatus(r.company_id, r.receipt_id) AS leastReceivedQtyStatus " +
                    "from receipt as r LEFT JOIN owner as own ON r.owner_id = own.owner_id AND own.company_id = '${companyId}' "+
                    "WHERE r.company_id = '${companyId}' "            
        }



        if (receiptId) {
            def findReceiptId = '%' + receiptId + '%'
            sqlQuery = sqlQuery + " AND r.receipt_id LIKE '${findReceiptId}'"
        }

        if (receiptDate) {
            def findReceiptDate = receiptDate
            sqlQuery = sqlQuery + " AND r.receipt_date >= '${findReceiptDate}'"
        }

        if (toReceiptDate) {
            def findToReceiptDate = toReceiptDate
            sqlQuery = sqlQuery + " AND r.receipt_date <= '${findToReceiptDate}'"
        }

        if (receiptType) {
            sqlQuery = sqlQuery + " AND r.receipt_type = '${receiptType}'"
        }

        if (status == 'Open') {
            sqlQuery = sqlQuery + " AND r.complete_date IS NULL"
        }

        if (status == 'Close') {
            sqlQuery = sqlQuery + " AND r.complete_date IS NOT NULL"
        }

        if (searchResultsForCount == false) {
            def dataRetrieveAmt = 0
            if (currentPageNum.toInteger() > 0) {
                dataRetrieveAmt = (currentPageNum.toInteger() - 1) * totalRetrieveAmt.toInteger()
            }
            else{
                dataRetrieveAmt = 0
            }
            sqlQuery = sqlQuery + " ORDER BY grid_status DESC, r.receipt_id DESC "
            sqlQuery = sqlQuery + " LIMIT ${dataRetrieveAmt}, ${totalRetrieveAmt} "
        }


                 

        log.info("sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        def sqlTime = System.currentTimeMillis()
        log.info(" sqlTime : " + sqlTime)

        return rows

    }

    //dashboard
    def getPendingPallets(companyId) {
        def sqlQuery = "SELECT COALESCE(COUNT(ri.receive_inventory_id),0) AS total_pending_pallet FROM receive_inventory as ri WHERE ri.company_id = '${companyId}' AND ri.is_completed_putaway = 0 AND ri.pallet_id IS NOT NULL AND ri.case_id IS NULL "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getPendingCases(companyId) {
        def sqlQuery = "SELECT COALESCE(COUNT(ri.receive_inventory_id),0) AS total_pending_case FROM receive_inventory as ri WHERE ri.company_id = '${companyId}' AND ri.is_completed_putaway = 0 AND ri.pallet_id IS NULL AND ri.case_id IS NOT NULL "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getPendingCasesTotalCount(companyId) {
        def sqlQuery = "SELECT COALESCE(SUM(ri.quantity),0) AS total_case FROM receive_inventory as ri WHERE ri.company_id = '${companyId}' AND ri.is_completed_putaway = 0 AND ri.uom = 'CASE' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getPendingEachesTotalCount(companyId) {
        def sqlQuery = "SELECT COALESCE(SUM(ri.quantity),0) AS total_each FROM receive_inventory as ri WHERE ri.company_id = '${companyId}' AND ri.is_completed_putaway = 0 AND ri.uom = 'EACH' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getExpectedReceiveQuantityInCase(companyId) {
        def caseQuantity = 0
        def expectedCaseInventories = ReceiptLine.findAllByCompanyIdAndUom(companyId, "CASE")

        for (inventory in expectedCaseInventories) {
            caseQuantity += inventory.expectedQuantity
        }

        def expectedEachInventories = ReceiptLine.findAllByCompanyIdAndUom(companyId, "EACH")
        def inventoryItem = null
        for (inventory in expectedEachInventories) {
            inventoryItem = Item.findByCompanyIdAndItemId(companyId, inventory.itemId)
            if (inventoryItem && inventoryItem.eachesPerCase) {
                caseQuantity += inventory.expectedQuantity / inventoryItem.eachesPerCase
            }
        }

        return caseQuantity
    }

    def getReceivedQuantityInCase(companyId) {
        def caseQuantity = 0
        def receivedCaseInventories = ReceiveInventory.findAllByCompanyIdAndUom(companyId, "CASE")

        for (inventory in receivedCaseInventories) {
            caseQuantity += inventory.quantity
        }

        def receivedEachInventories = ReceiveInventory.findAllByCompanyIdAndUom(companyId, "EACH")
        def inventoryItem = null
        def receiptLine = null
        for (inventory in receivedEachInventories) {
            receiptLine = ReceiptLine.findByCompanyIdAndReceiptLineId(companyId, inventory.receiptLineId)

            if (receiptLine)
                inventoryItem = Item.findByCompanyIdAndItemId(companyId, receiptLine.itemId)

            if (inventoryItem && inventoryItem.eachesPerCase) {
                caseQuantity += inventory.quantity / inventoryItem.eachesPerCase
            }
        }

        return caseQuantity
    }

    def getReceiptLineCaseQuantity(companyId) {
        def receivedCases = getReceivedQuantityInCase(companyId)
        def yetToBeReceivedCases = getExpectedReceiveQuantityInCase(companyId) - receivedCases

        return [receivedCases: receivedCases.toInteger(), yetToBeReceivedCases: yetToBeReceivedCases.toInteger()]
    }


    def calculateReceivedInventoryQty(companyId, receiptLineId, itemId) {

        def totalReceivedQty = 0
        def receivedQtyStatus = null
        def itemRow = Item.findByCompanyIdAndItemId(companyId, itemId)
        def receiptLineRow = ReceiptLine.findByCompanyIdAndReceiptLineId(companyId, receiptLineId)


        def getReceiveInventory = ReceiveInventory.findAllByCompanyIdAndReceiptLineId(companyId, receiptLineId)
        def totalQty = 0
        if (itemRow.lowestUom == 'EACH') {
            for (inv in getReceiveInventory) {


                if (inv.uom == 'EACH') {
                    totalQty = totalQty.toInteger() + inv.quantity.toInteger()
                } else if (inv.uom == 'CASE') {
                    totalQty = totalQty.toInteger() + (inv.quantity.toInteger() * itemRow.eachesPerCase.toInteger())
                } else {
                    totalQty = totalQty.toInteger() + (inv.quantity.toInteger() * itemRow.eachesPerCase.toInteger() * itemRow.casesPerPallet.toInteger())
                }
            }
            totalReceivedQty = totalQty
        } else if (itemRow.lowestUom == 'CASE') {
            for (inv in getReceiveInventory) {

                if (inv.uom == 'CASE') {
                    totalQty = totalQty.toInteger() + inv.quantity.toInteger()
                } else {
                    totalQty = totalQty.toInteger() + (inv.quantity.toInteger() * itemRow.casesPerPallet.toInteger())
                }
            }
            totalReceivedQty = totalQty
        } else {
            for (inv in getReceiveInventory) {

                totalQty = totalQty.toInteger() + inv.quantity.toInteger()
            }
            totalReceivedQty = totalQty
        }


        if (totalReceivedQty == null) {
            totalReceivedQty = 0
        }

        if ((totalReceivedQty.toInteger()) == 0) {
            receivedQtyStatus = 'notReceived'
        } else if ((receiptLineRow.expectedQuantity.toInteger()) > totalReceivedQty) {
            receivedQtyStatus = 'partiallyReceived'
        } else if ((receiptLineRow.expectedQuantity.toInteger()) < totalReceivedQty) {
            receivedQtyStatus = 'overReceived'
        } else if ((receiptLineRow.expectedQuantity.toInteger()) == totalReceivedQty) {
            receivedQtyStatus = 'equal'
        }

        return [receiptLineId: receiptLineRow.receiptLineId, totalReceivedQty: totalReceivedQty, receivedQtyStatus: receivedQtyStatus]

    }

    def validatePalletIdForReceiving(companyId, palletId, receiptLineId, level) {
        def palletExistData = InventoryEntityAttribute.findAll("FROM InventoryEntityAttribute WHERE companyId = '${companyId}' AND (lPN = '${palletId}' OR parentLpn = '${palletId}') AND level = '${level}'")
        if (palletExistData.size() > 0) {
            if (palletExistData[0].locationId == 'TEMPLOCATION') {
                def receiptLineCompare = ReceiveInventory.findAllByCompanyIdAndPalletIdAndReceiptLineId(companyId, palletId, receiptLineId)
                if (receiptLineCompare.size() > 0 && receiptLineCompare[0].uom != HandlingUom.PALLET) {
                    return [receiptLine: receiptLineCompare[0].receiptLineId, palletId: palletId, allowToReceive: true]
                } else {
                    return [palletId: palletId, allowToReceive: false]
                }
            } else {
                return [palletId: palletId, allowToReceive: false]
            }
        } else {
            return [palletId: palletId, allowToReceive: true]
        }

    }

    def validatePalletIdForPutaway(companyId, palletId) {
        def isCompletedPutawayForPalletId = ReceiveInventory.findByCompanyIdAndPalletIdAndIsCompletedPutaway(companyId, palletId, false)
        def isCompletedPutawayForCaseId = ReceiveInventory.findByCompanyIdAndCaseIdAndIsCompletedPutaway(companyId, palletId, false)
        if (isCompletedPutawayForPalletId) {
            return [palletId: palletId, allowToPutaway: true]
        } else if (isCompletedPutawayForCaseId) {
            return [palletId: palletId, allowToPutaway: true]
        } else {
            return [palletId: palletId, allowToPutaway: false]
        }
    }

    def isCaseByLPN(companyId, lpn) {
        def inv = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, lpn)
        if (inv.level == "PALLET") {
            return [isCase: false]
        } else {
            return [isCase: true]
        }
    }

    def priorDayInventoryReceived(String companyId) {

        def sqlQuery = "SELECT ri.*, lv.description AS inventory_status_desc, rl.item_id AS item_id " +
                "FROM receive_inventory AS ri " +
                "INNER JOIN receipt_line as rl ON rl.receipt_line_id = ri.receipt_line_id AND rl.company_id = '${companyId}'  " +
                "LEFT JOIN list_value as lv ON lv.option_value = ri.inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
                "WHERE ri.company_id = '${companyId}' AND ri.created_date >= CURDATE() - INTERVAL 1 DAY AND ri.created_date < CURDATE() "
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def inventoryReceivedFromTo(companyId, fromDate, toDate) {
        def convertedFromDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate)
        def convertedToDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toDate)

        def fromDateFormat = convertedFromDate.format('yyyy-MM-dd')
        convertedToDate.set(hourOfDay: 23, minute: 59, second: 0)
        def toDateFormat = convertedToDate.format('yyyy-MM-dd HH:mm:ss')
        println fromDateFormat
        println toDateFormat

        def sqlQuery = "SELECT ri.*, lv.description AS inventory_status_desc, rl.item_id AS item_id, rl.receipt_id as receipt_id " +
                "FROM receive_inventory AS ri " +
                "INNER JOIN receipt_line as rl ON rl.receipt_line_id = ri.receipt_line_id AND rl.company_id = '${companyId}'  " +
                "LEFT JOIN list_value as lv ON lv.option_value = ri.inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
                "WHERE ri.company_id = '${companyId}' "

        if (fromDate && toDate) {
            sqlQuery += "AND ri.created_date >= '${fromDateFormat}' AND ri.created_date <= '${toDateFormat}'"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)


    }
}

