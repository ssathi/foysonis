package com.foysonis.inventory

import com.foysonis.item.HandlingUom
import com.foysonis.item.Item
import com.foysonis.item.ListValue
import com.foysonis.receiving.InventoryNotes

import groovy.sql.Sql
import grails.transaction.Transactional

@Transactional
class InventoryAdjustmentService {

		def sessionFactory
		def inventorySummaryService
		def entityLastRecordService

		def checkIsCaseTrackedOfItem(companyId, itemId) {
				return Item.findAllByCompanyIdAndItemIdAndIsCaseTracked(companyId, itemId, true)
		}

		def checkIsLotCodeTrackedOfItem(companyId, itemId) {
				return Item.findAllByCompanyIdAndItemIdAndIsLotTracked(companyId, itemId, true)
		}

		def checkIsExpiredOfItem(companyId, itemId) {
				return Item.findAllByCompanyIdAndItemIdAndIsExpired(companyId, itemId, true)
		}

		def checkLowestUomOfItemEach(companyId, itemId) {
				return Item.findAllByCompanyIdAndItemIdAndLowestUom(companyId, itemId, HandlingUom.EACH)
		}

		def getPalletsByLocation(companyId, locationId) {
				return InventoryEntityAttribute.findAllByCompanyIdAndLocationIdAndLevel(companyId, locationId, 'PALLET')
		}


		def inventoryEditAndAdjustment(inventoryData, companyId, username) {

				if (inventoryData.caseId != '' && inventoryData.handlingUom == HandlingUom.EACH) {
						Item inventoryItem = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)

						if (inventoryItem && inventoryItem.eachesPerCase && inventoryItem.eachesPerCase.toInteger() == inventoryData.quantity.toInteger()) {
								inventoryData.handlingUom = "CASE"
								inventoryData.quantity = 1
						}
				}

				def inventoryAdjustment = new InventoryAdjustment()

				Inventory inventory = Inventory.findByCompanyIdAndInventoryId(companyId, inventoryData.inventoryId)
				if (inventory) {

						Item item = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)

						inventory.properties = [quantity       : inventoryData.quantity,
																		handlingUom    : inventoryData.handlingUom,
																		lotCode        : inventoryData.lotCode,
																		inventoryStatus: inventoryData.inventoryStatus]



						inventoryAdjustment.properties = [itemId                 : inventoryData.itemId,
																							itemDescription        : item.itemDescription,
																							companyId              : companyId,
																							prevQty                : inventoryData.preQuantity,
																							qty                    : inventoryData.quantity,
																							uom                    : inventoryData.handlingUom,
																							locationId             : inventoryData.locationId,
																							palletId               : inventoryData.palletId,
																							caseId                 : inventoryData.caseId,
																							reasonCode             : inventoryData.reasonCode,
																							adjustmentDescription  : inventoryData.adjustmentDescription,
																							userId                 : username,
																							createdDate            : new Date(),
																							previousInventoryStatus: inventoryData.preInventoryStatus,
																							inventoryStatus        : inventoryData.inventoryStatus,
																							previousLotCode        : inventoryData.preLotCode,
																							lotCode                : inventoryData.lotCode,
																							previousExpirationDate : inventoryData.preExpirationDate,
																							action                 : "MODIFY"]

						def getReasonCode = ListValue.find("from ListValue where (companyId = '${companyId}' or companyId = 'ALL') and  description = '${inventoryData.reasonCode}' and optionGroup = 'ADJREASON' ")
						if (getReasonCode) {
								inventoryAdjustment.reasonCode = getReasonCode.optionValue
						}

						if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
								inventory.expirationDate = null;
								inventoryAdjustment.expirationDate = null;
						} else {
								def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
								inventory.expirationDate = convertedExpirationDate;
								inventoryAdjustment.expirationDate = convertedExpirationDate;
						}


						def adjustmentIdExist = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")

						if (!adjustmentIdExist) {
								inventoryAdjustment.adjustmentId = companyId + "000001"
						} else {
								def adjustmentIdInteger = adjustmentIdExist.adjustmentId - companyId
								def intIndex = adjustmentIdInteger.toInteger()
								intIndex = intIndex + 1
								def stringIndex = intIndex.toString().padLeft(6, "0")
								inventoryAdjustment.adjustmentId = companyId + stringIndex
						}


						inventoryAdjustment.save(flush: true, failOnError: true)
						inventory.save(flush: true, failOnError: true)

						if (inventoryData.itemNote && (inventoryData.caseId || inventoryData.palletId)) {
							def lpnValue = null
							if (inventoryData.caseId) {
								lpnValue = inventoryData.caseId
							}
							else if (inventoryData.palletId) {
								lpnValue = inventoryData.palletId
							}
							def inventoryNotes = InventoryNotes.findByCompanyIdAndLPN(companyId, lpnValue)
							if (inventoryNotes) {
									inventoryNotes.notes = inventoryData.itemNote
									inventoryNotes.save(flush: true, failOnError: true)
							} else {
									def inventoryNotesCreate = new InventoryNotes()
									inventoryNotesCreate.companyId = companyId
									inventoryNotesCreate.lPN = lpnValue
									inventoryNotesCreate.notes = inventoryData.itemNote
									inventoryNotesCreate.save(flush: true, failOnError: true)
							}

						}

						inventorySummaryService.updateEditInventory(companyId, inventoryData.itemId, inventoryData.preInventoryStatus, inventoryData.inventoryStatus, inventoryData.preQuantity.toInteger(), inventoryData.quantity.toInteger(), inventoryData.handlingUom)


				}

		}

		def checkInventoryLocationForDelete(companyId, locationId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM location as l INNER JOIN area as a ON l.area_id = a.area_id AND a.company_id = '${companyId}' WHERE l.location_id = '${locationId}'  AND l.company_id = '${companyId}';")
				return rows
		}

		def deleteInventory(adjustmentData, companyId, username) {

				Inventory inventory = Inventory.findByCompanyIdAndInventoryId(companyId, adjustmentData.inventory_id)
				InventoryNotes inventoryNote = InventoryNotes.findByCompanyIdAndLPN(companyId, adjustmentData.case_id)

				if (inventory) {
						Item item = Item.findByCompanyIdAndItemId(companyId, adjustmentData.item_id)

						def inventoryAdjustment = new InventoryAdjustment()

						inventoryAdjustment.properties = [itemId                 : adjustmentData.item_id,
																							itemDescription        : item.itemDescription,
																							companyId              : companyId,
																							prevQty                : adjustmentData.quantity,
																							qty                    : null,
																							uom                    : adjustmentData.handling_uom,
																							locationId             : adjustmentData.location_id,
																							palletId               : adjustmentData.pallet_id,
																							caseId                 : adjustmentData.case_id,
																							adjustmentDescription  : null,
																							userId                 : username,
																							createdDate            : new Date(),
																							previousInventoryStatus: adjustmentData.inventory_status,
																							inventoryStatus        : null,
																							previousLotCode        : adjustmentData.lot_code,
																							lotCode                : null,
																							previousExpirationDate : adjustmentData.expiration_date,
																							expirationDate         : null,
																							action                 : "DELETE"]


						def getReasonCode = ListValue.find("from ListValue where (companyId = '${companyId}' or companyId = 'ALL') and  description = '${adjustmentData.reasonCode}' and optionGroup = 'ADJREASON' ")
						if (getReasonCode) {
								inventoryAdjustment.reasonCode = getReasonCode.optionValue
						}

						def adjustmentIdExist = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")

						if (!adjustmentIdExist) {

								inventoryAdjustment.adjustmentId = companyId + "000001"
						} else {

								def adjustmentIdInteger = adjustmentIdExist.adjustmentId - companyId
								def intIndex = adjustmentIdInteger.toInteger()
								intIndex = intIndex + 1
								def stringIndex = intIndex.toString().padLeft(6, "0")
								inventoryAdjustment.adjustmentId = companyId + stringIndex
						}

						def inventoryAdjustmentForPallet = new InventoryAdjustment()

						inventoryAdjustmentForPallet.properties = [itemId                 : adjustmentData.item_id,
																											 itemDescription        : item.itemDescription,
																											 companyId              : companyId,
																											 prevQty                : null,
																											 qty                    : null,
																											 uom                    : null,
																											 locationId             : null,
																											 palletId               : adjustmentData.pallet_id,
																											 caseId                 : null,
																											 adjustmentDescription  : "Pallet deleted",
																											 userId                 : username,
																											 createdDate            : new Date(),
																											 previousInventoryStatus: null,
																											 inventoryStatus        : null,
																											 previousLotCode        : null,
																											 lotCode                : null,
																											 previousExpirationDate : null,
																											 expirationDate         : null,
																											 action                 : "DELETE"]

						getReasonCode = ListValue.find("from ListValue where (companyId = '${companyId}' or companyId = 'ALL') and  description = '${adjustmentData.reasonCode}' and optionGroup = 'ADJREASON' ")
						if (getReasonCode) {
								inventoryAdjustmentForPallet.reasonCode = getReasonCode.optionValue
						}

						//Update Inventory Summary

						inventorySummaryService.updateDecreasedInventory(companyId, adjustmentData.item_id, adjustmentData.inventory_status, adjustmentData.quantity, adjustmentData.handling_uom)


						if (adjustmentData.case_id != null && adjustmentData.pallet_id != null) {
								def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevel(companyId, adjustmentData.case_id, "CASE")
								if (inventoryEntityAttribute) {

										inventory.delete(flush: true, failOnError: true)
										inventoryEntityAttribute.delete(flush: true, failOnError: true)
										if (inventoryNote)
												inventoryNote.delete(flush: true, failOnError: true)
										inventoryAdjustment.save(flush: true, failOnError: true)
										def getParentLpn = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, adjustmentData.pallet_id)
										def checkParentLpnExist = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, adjustmentData.pallet_id)
										def checkParentLpnExistInInventory = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, adjustmentData.pallet_id)
										if (checkParentLpnExist.size() == 0 && checkParentLpnExistInInventory.size() == 0) {
												getParentLpn.delete(flush: true, failOnError: true)

												def adjustmentIdExistForPallet = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")
												if (!adjustmentIdExistForPallet) {

														inventoryAdjustmentForPallet.adjustmentId = companyId + "000001"

												} else {
														def inventoryAdjustmentIdInteger = adjustmentIdExistForPallet.adjustmentId - companyId
														def intIndex = inventoryAdjustmentIdInteger.toInteger()
														intIndex = intIndex + 1
														def stringIndex = intIndex.toString().padLeft(6, "0")
														inventoryAdjustmentForPallet.adjustmentId = companyId + stringIndex
												}




												inventoryAdjustmentForPallet.save(flush: true, failOnError: true)


										}

								}


						}

						if (adjustmentData.case_id != null && adjustmentData.pallet_id == null) {
								inventory.delete(flush: true, failOnError: true)
								inventoryAdjustment.save(flush: true, failOnError: true)
								if (inventoryNote)
										inventoryNote.delete(flush: true, failOnError: true)
								def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevel(companyId, adjustmentData.case_id, "CASE")
								if (inventoryEntityAttribute) {
										inventoryEntityAttribute.delete(flush: true, failOnError: true)

								}

						} else if (adjustmentData.case_id == null && adjustmentData.pallet_id != null) {
								inventory.delete(flush: true, failOnError: true)
								inventoryAdjustment.save(flush: true, failOnError: true)
								if (inventoryNote)
										inventoryNote.delete(flush: true, failOnError: true)
								def getParentLpn = InventoryEntityAttribute.findByCompanyIdAndLPN(companyId, adjustmentData.pallet_id)
								def checkParentLpnExist = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, adjustmentData.pallet_id)
								def checkParentLpnExistInInventory = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, adjustmentData.pallet_id)
								if (checkParentLpnExist.size() == 0 && checkParentLpnExistInInventory.size() == 0) {
										getParentLpn.delete(flush: true, failOnError: true)

										def adjustmentIdExistForPallet = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")
										if (!adjustmentIdExistForPallet) {

												inventoryAdjustmentForPallet.adjustmentId = companyId + "000001"

										} else {
												def inventoryAdjustmentIdInteger = adjustmentIdExistForPallet.adjustmentId - companyId
												def intIndex = inventoryAdjustmentIdInteger.toInteger()
												intIndex = intIndex + 1
												def stringIndex = intIndex.toString().padLeft(6, "0")
												inventoryAdjustmentForPallet.adjustmentId = companyId + stringIndex
										}

										inventoryAdjustmentForPallet.save(flush: true, failOnError: true)

								}


						} else if (adjustmentData.case_id == null && adjustmentData.pallet_id == null) {
								inventory.delete(flush: true, failOnError: true)
								inventoryAdjustment.save(flush: true, failOnError: true)
								if (inventoryNote)
										inventoryNote.delete(flush: true, failOnError: true)
						}


				}

				return adjustmentData
		}


		def inventorySave(companyId, username, inventoryData) {


				if (inventoryData.caseId != '' && inventoryData.handlingUom == HandlingUom.EACH) {
						Item inventoryItem = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)

						if (inventoryItem && inventoryItem.eachesPerCase && inventoryItem.eachesPerCase.toInteger() == inventoryData.quantity.toInteger()) {
								inventoryData.handlingUom = HandlingUom.CASE
								inventoryData.quantity = 1
						}
				}

				def inventoryForCase = new Inventory()

				//def inventoryIdExist2 = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
				//if (!inventoryIdExist2) {

				//inventoryForCase.inventoryId =  companyId + "000001"
				//}
				//else{

				//def inventoryIdInteger = inventoryIdExist2.inventoryId - companyId
				//def intIndex = inventoryIdInteger.toInteger()
				//intIndex = intIndex + 1

				//}

				inventoryForCase.properties = [companyId      : companyId,
																			 associatedLpn  : inventoryData.caseId,
																			 handlingUom    : inventoryData.handlingUom,
																			 inventoryStatus: inventoryData.inventoryStatus,
																			 itemId         : inventoryData.itemId,
																			 locationId     : null,
																			 quantity       : inventoryData.quantity,
																			 //expirationDate : convertedExpirationDate,
																			 lotCode        : inventoryData.lotCode
				]

				if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
						inventoryForCase.expirationDate = null;
				} else {
						def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
						inventoryForCase.expirationDate = convertedExpirationDate;
				}



				def invOutput = null
				if (inventoryData.palletId != '' && inventoryData.caseId == '') {

						invOutput = inventoryForPallet(companyId, inventoryData)
						inventoryEntityAttributeForPallet(companyId, username, inventoryData)
						inventoryAdjustmentSave(companyId, username, inventoryData)

				} else if (inventoryData.palletId == '' && inventoryData.caseId != '') {
						def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
						def stringIndex = intIndex.toString().padLeft(6, "0")
						inventoryForCase.inventoryId = companyId + stringIndex

						invOutput = inventoryForCase.save(flush: true, failOnError: true)
						inventoryEntityAttributeForCase(companyId, username, inventoryData)
						inventoryAdjustmentSave(companyId, username, inventoryData)
				} else if (inventoryData.palletId != '' && inventoryData.caseId != '') {

						invOutput = inventoryForPalletAndCase(companyId, inventoryData)
						inventoryEntityAttributeForPalletAndCase(companyId, username, inventoryData)
						def palletExist = InventoryEntityAttribute.findByCompanyIdAndLPNAndLevel(companyId, inventoryData.palletId, 'PALLET')
						if (!palletExist) {
								inventoryEntityAttributeForPallet(companyId, username, inventoryData)
						}
						inventoryAdjustmentSave(companyId, username, inventoryData)
				} else if (inventoryData.palletId == '' && inventoryData.caseId == '') {

						invOutput = inventoryWithoutCaseAndPallet(companyId, inventoryData, username)
						//inventoryAdjustmentSave(companyId, username, inventoryData)
				}

				if (inventoryData.itemNote && (inventoryData.caseId || inventoryData.palletId)) {
          def lpnValue = null
          if (inventoryData.caseId) {
            lpnValue = inventoryData.caseId
          }
          else if (inventoryData.palletId) {
            lpnValue = inventoryData.palletId
          }
					def inventoryNotes = InventoryNotes.findByCompanyIdAndLPN(companyId, lpnValue)
					if (inventoryNotes) {
							inventoryNotes.notes = inventoryData.itemNote
					} else {
							inventoryNotes = new InventoryNotes()
							inventoryNotes.companyId = companyId
							inventoryNotes.lPN = lpnValue           
							inventoryNotes.notes = inventoryData.itemNote
					}
					inventoryNotes.save(flush: true, failOnError: true)
				}


				inventorySummaryService.updateIncreasedInventory(companyId, inventoryData.itemId, inventoryData.inventoryStatus, inventoryData.quantity.toInteger(), inventoryData.handlingUom)
				return invOutput

		}


		def inventoryAdjustmentSave(companyId, username, inventoryData) {

				Item item = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)
				def inventoryAdjustment = new InventoryAdjustment(inventoryData)

				inventoryAdjustment.properties = [itemId         : inventoryData.itemId,
																					itemDescription: item.itemDescription,
																					companyId      : companyId,
																					qty            : inventoryData.quantity,
																					uom            : inventoryData.handlingUom,
																					locationId     : inventoryData.locationId,
																					palletId       : inventoryData.palletId,
																					reasonCode     : inventoryData.reasonCode,
																					userId         : username,
																					inventoryStatus: inventoryData.inventoryStatus,
																					caseId         : inventoryData.caseId,
																					lotCode        : inventoryData.lotCode,
																					//expirationDate : convertedExpirationDate,
																					createdDate    : new Date(),
																					action         : 'CREATED'
				]

				if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
						inventoryAdjustment.expirationDate = null;
				} else {
						def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
						inventoryAdjustment.expirationDate = convertedExpirationDate;
				}

				if (inventoryData.reasonCode != '') {
						def listvalueConfigValue = ListValue.find("from ListValue where (companyId = '${companyId}' or companyId = 'ALL') and  description = '${inventoryData.reasonCode}' and optionGroup = 'ADJREASON' ")
						inventoryAdjustment.reasonCode = listvalueConfigValue.optionValue
				}

				def adjustmentIdExist = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")


				if (!adjustmentIdExist) {

						inventoryAdjustment.adjustmentId = companyId + "000001"
				} else {

						def adjustmentIdInteger = adjustmentIdExist.adjustmentId - companyId
						def intIndex = adjustmentIdInteger.toInteger()
						intIndex = intIndex + 1
						def stringIndex = intIndex.toString().padLeft(6, "0")
						inventoryAdjustment.adjustmentId = companyId + stringIndex
				}

				inventoryAdjustment.save(flush: true, failOnError: true)

		}

		def inventoryEntityAttributeForPallet(companyId, username, inventoryData) {

				def inventoryEntityAttributeForPallet = new InventoryEntityAttribute(inventoryData)

				inventoryEntityAttributeForPallet.properties = [companyId         : companyId,
																												lastModifiedUserId: username,
																												lPN               : inventoryData.palletId,
																												locationId        : inventoryData.locationId,
																												level             : 'PALLET',
																												parentLpn         : null,
																												createdDate       : new Date(),
																												lastModifiedDate  : new Date(),
																												sscc              : inventoryData.sscc
				]

				inventoryEntityAttributeForPallet.save(flush: true, failOnError: true)
		}

		def inventoryWithoutCaseAndPallet(companyId, inventoryData, username) {

				if (!inventoryData.lotCode) {
						inventoryData.lotCode = null
				}

				def convertedExpirationDateForSearch = null
				if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
						convertedExpirationDateForSearch = null;
				} else {
						convertedExpirationDateForSearch = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
						//inventoryData.expirationDate = convertedExpirationDate;
						println convertedExpirationDateForSearch
				}

				def inventory = Inventory.findByCompanyIdAndItemIdAndLocationIdAndHandlingUomAndInventoryStatusAndLotCodeAndExpirationDate(companyId, inventoryData.itemId, inventoryData.locationId, inventoryData.handlingUom, inventoryData.inventoryStatus, inventoryData.lotCode, convertedExpirationDateForSearch)

				if (inventory) {

						Item item = Item.findByCompanyIdAndItemId(companyId, inventoryData.itemId)
						def inventoryAdjustment = new InventoryAdjustment()

						inventoryAdjustment.properties = [itemId                 : inventoryData.itemId,
																							itemDescription        : item.itemDescription,
																							companyId              : companyId,
																							prevQty                : inventory.quantity,
																							qty                    : inventory.quantity.toInteger() + inventoryData.quantity.toInteger(),
																							uom                    : inventoryData.handlingUom,
																							locationId             : inventoryData.locationId,
																							palletId               : inventoryData.palletId,
																							caseId                 : inventoryData.caseId,
																							reasonCode             : inventoryData.reasonCode,
																							adjustmentDescription  : inventoryData.adjustmentDescription,
																							userId                 : username,
																							createdDate            : new Date(),
																							previousInventoryStatus: inventoryData.preInventoryStatus,
																							inventoryStatus        : inventoryData.inventoryStatus,
																							previousLotCode        : inventoryData.preLotCode,
																							lotCode                : inventoryData.lotCode,
																							previousExpirationDate : inventoryData.preExpirationDate,
																							action                 : "MODIFY"]

						def getReasonCode = ListValue.find("from ListValue where (companyId = '${companyId}' or companyId = 'ALL') and  description = '${inventoryData.reasonCode}' and optionGroup = 'ADJREASON' ")
						if (getReasonCode) {
								inventoryAdjustment.reasonCode = getReasonCode.optionValue
						}

						if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
								inventory.expirationDate = null;
								inventoryAdjustment.expirationDate = null;
						} else {
								def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
								inventory.expirationDate = convertedExpirationDate;
								inventoryAdjustment.expirationDate = convertedExpirationDate;
						}




						def adjustmentIdExist = InventoryAdjustment.find("from InventoryAdjustment as inv where inv.companyId='${companyId}' order by adjustmentId DESC")

						if (!adjustmentIdExist) {
								inventoryAdjustment.adjustmentId = companyId + "000001"
						} else {
								def adjustmentIdInteger = adjustmentIdExist.adjustmentId - companyId
								def intIndex = adjustmentIdInteger.toInteger()
								intIndex = intIndex + 1
								def stringIndex = intIndex.toString().padLeft(6, "0")
								inventoryAdjustment.adjustmentId = companyId + stringIndex
						}


						inventoryAdjustment.save(flush: true, failOnError: true)



						inventory.quantity = inventory.quantity.toInteger() + inventoryData.quantity.toInteger()
				} else {
						inventory = new Inventory(inventoryData)

						inventory.properties = [companyId      : companyId,
																		associatedLpn  : inventoryData.palletId,
																		handlingUom    : inventoryData.handlingUom,
																		inventoryStatus: inventoryData.inventoryStatus,
																		itemId         : inventoryData.itemId,
																		locationId     : inventoryData.locationId,
																		quantity       : inventoryData.quantity,
																		//expirationDate : convertedExpirationDate,
																		lotCode        : inventoryData.lotCode
						]
						if (inventoryData.palletId) {
								inventory.associatedLpn = inventoryData.palletId;
						}
						if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
								inventory.expirationDate = null;
						} else {
								def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
								inventory.expirationDate = convertedExpirationDate;
						}

						//def inventoryIdExist = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
						// if (!inventoryIdExist) {

						//     inventory.inventoryId =  companyId + "000001"
						// }
						//else{

						// def inventoryIdInteger = inventoryIdExist.inventoryId - companyId
						// def intIndex = inventoryIdInteger.toInteger()
						//intIndex = intIndex + 1
						def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
						def stringIndex = intIndex.toString().padLeft(6, "0")
						inventory.inventoryId = companyId + stringIndex

						//}
						inventory.save(flush: true, failOnError: true)
						inventoryAdjustmentSave(companyId, username, inventoryData)
				}
				return inventory
		}

		def inventoryForPallet(companyId, inventoryData) {
				def inventoryForPallet = new Inventory()

				//def inventoryIdExist1 = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
				//if (!inventoryIdExist1) {

				//inventoryForPallet.inventoryId =  companyId + "000001"
				//}
				//else{

				//def inventoryIdInteger = inventoryIdExist1.inventoryId - companyId
				//def intIndex = inventoryIdInteger.toInteger()
				//intIndex = intIndex + 1
				def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
				def stringIndex = intIndex.toString().padLeft(6, "0")
				inventoryForPallet.inventoryId = companyId + stringIndex

				//}

				inventoryForPallet.properties = [companyId      : companyId,
																				 associatedLpn  : inventoryData.palletId,
																				 handlingUom    : inventoryData.handlingUom,
																				 inventoryStatus: inventoryData.inventoryStatus,
																				 itemId         : inventoryData.itemId,
																				 quantity       : inventoryData.quantity,
																				 //expirationDate : convertedExpirationDate,
																				 lotCode        : inventoryData.lotCode
				]
				if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
						inventoryForPallet.expirationDate = null;
				} else {
						def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
						inventoryForPallet.expirationDate = convertedExpirationDate;
				}
				inventoryForPallet.save(flush: true, failOnError: true)
				return inventoryForPallet
		}

		def inventoryForPalletAndCase(companyId, inventoryData) {

				def inventoryForPalletAndCase = new Inventory()

				//def inventoryIdExist3 = Inventory.find("from Inventory as i where i.companyId='${companyId}' order by inventoryId DESC")
				//if (!inventoryIdExist3) {

				//inventoryForPalletAndCase.inventoryId = companyId + "000001"
				//}
				//else{

				//def inventoryIdInteger = inventoryIdExist3.inventoryId - companyId
				//def intIndex = inventoryIdInteger.toInteger()
				//intIndex = intIndex + 1
				def intIndex = entityLastRecordService.getLastRecordId(companyId, "INVENTORY").lastRecordId
				def stringIndex = intIndex.toString().padLeft(6, "0")
				inventoryForPalletAndCase.inventoryId = companyId + stringIndex
				//}

				inventoryForPalletAndCase.properties = [companyId      : companyId,
																								associatedLpn  : inventoryData.caseId,
																								handlingUom    : inventoryData.handlingUom,
																								inventoryStatus: inventoryData.inventoryStatus,
																								itemId         : inventoryData.itemId,
																								quantity       : inventoryData.quantity,
																								//expirationDate : convertedExpirationDate,
																								lotCode        : inventoryData.lotCode
				]

				if (inventoryData.expirationDate == null || inventoryData.expirationDate == '') {
						inventoryForPalletAndCase.expirationDate = null;
				} else {
						def convertedExpirationDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", inventoryData.expirationDate)
						inventoryForPalletAndCase.expirationDate = convertedExpirationDate;
				}
				inventoryForPalletAndCase.save(flush: true, failOnError: true)
				return inventoryForPalletAndCase
		}

		def inventoryEntityAttributeForPalletAndCase(companyId, username, inventoryData) {

				def inventoryEntityAttributeForPalletAndCase = new InventoryEntityAttribute()

				inventoryEntityAttributeForPalletAndCase.properties = [companyId         : companyId,
																															 lastModifiedUserId: username,
																															 lPN               : inventoryData.caseId,
																															 level             : 'CASE',
																															 parentLpn         : inventoryData.palletId,
																															 createdDate       : new Date(),
																															 lastModifiedDate  : new Date(),
																															 sscc              : inventoryData.sscc
				]

				inventoryEntityAttributeForPalletAndCase.save(flush: true, failOnError: true)

		}

		def inventoryEntityAttributeForCase(companyId, username, inventoryData) {


				def inventoryEntityAttributeForCase = new InventoryEntityAttribute(inventoryData)

				inventoryEntityAttributeForCase.properties = [companyId         : companyId,
																											lastModifiedUserId: username,
																											lPN               : inventoryData.caseId,
																											locationId        : inventoryData.locationId,
																											level             : 'CASE',
																											parentLpn         : null,
																											createdDate       : new Date(),
																											lastModifiedDate  : new Date(),
																											sscc              : inventoryData.sscc
				]

				inventoryEntityAttributeForCase.save(flush: true, failOnError: true)

		}

		def getPallets(companyId, keyword) {
				def keyPalletId = '%' + keyword + '%'
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT distinct lpn as locationId FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND level = 'PALLET' AND lpn LIKE '${keyPalletId}' ORDER BY lpn asc LIMIT 10;")
				return rows
		}

		def getPalletsByLocationAndItem(companyId, itemId, locationId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i on i.associated_lpn = iea.lpn AND i.company_id = '${companyId}' WHERE i.item_id = '${itemId}' AND iea.location_id = '${locationId}' AND iea.level = 'PALLET' AND iea.company_id = '${companyId}';")
				def rows2 = sql.rows("SELECT iea2.* FROM inventory_entity_attribute as iea INNER JOIN inventory_entity_attribute as iea2 ON iea.parent_lpn = iea2.lpn AND iea.company_id = '${companyId}' INNER JOIN inventory as i on i.associated_lpn = iea.lpn AND i.company_id = '${companyId}' WHERE iea2.company_id = '${companyId}' AND i.item_id = '${itemId}' AND iea2.location_id = '${locationId}' AND iea2.level = 'PALLET';")
				//return rows
				def combinedRows = rows + rows2
				return combinedRows
		}

		def validatePalletIdByLocationAndItem(companyId, itemId, locationId, palletId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM inventory_entity_attribute as iea INNER JOIN inventory as i on i.associated_lpn = iea.lpn AND i.company_id = '${companyId}' WHERE i.item_id != '${itemId}' AND iea.location_id != '${locationId}' AND iea.company_id = '${companyId}' AND iea.lpn = '${palletId}';")
				def rows2 = sql.rows("SELECT iea2.* FROM inventory_entity_attribute as iea INNER JOIN inventory_entity_attribute as iea2 ON iea.parent_lpn = iea2.lpn AND iea.company_id = '${companyId}' INNER JOIN inventory as i on i.associated_lpn = iea.lpn AND i.company_id = '${companyId}' WHERE iea2.company_id = '${companyId}' AND (i.item_id != '${itemId}' OR iea2.location_id != '${locationId}') AND iea2.level = 'PALLET' AND iea2.lpn = '${palletId}';")
				//return rows
				def combinedRows = rows + rows2
				return combinedRows
		}

		def getCases(companyId, keyword) {
				def keyCaseId = '%' + keyword + '%'
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT distinct lpn as locationId FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND level = 'CASE' AND lpn LIKE '${keyCaseId}' ORDER BY lpn asc LIMIT 10;")
				return rows
		}

		def validateCase(companyId, caseId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = '${caseId}'")
				return rows
		}

		def validatePalletIdExistForCase(companyId, palletId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = '${palletId}' AND level = 'CASE'")
				return rows
		}

		def validatePallet(companyId, palletId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT * FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND lpn = '${palletId}'")
				return rows
		}

		def getCasesByLocation(companyId, locationId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT lpn as locationId FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND location_id = '${locationId}' AND level = 'CASE'")
				return rows
		}

		def getPallets1(companyId, locationId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT distinct lpn as locationId FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND location_id = '${locationId}' AND level = 'PALLET'")
				return rows
		}

		def getCasesByPallet(companyId, palletId) {
				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows("SELECT lpn as locationId FROM inventory_entity_attribute WHERE company_id = '${companyId}' AND parent_lpn = '${palletId}' AND level = 'CASE'")
				return rows
		}

		def getInventoryByInventoryId(companyId, palletId, caseId) {
				def sqlQuery = "SELECT i.item_id, lo.area_id AS grid_area_id,  it.item_description, i.quantity, i.handling_uom, i.inventory_id, i.lot_code, lv.description as inventory_status, i.inventory_status as inventory_status_option_value, i.expiration_date,inote.notes, CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END AS location_id, CASE WHEN iea.level = 'PALLET' THEN iea.lpn ELSE CASE WHEN ieap.level = 'PALLET' THEN ieap.lpn ELSE NULL END END AS pallet_id, CASE WHEN iea.level = 'CASE' THEN iea.lpn ELSE CASE WHEN ieap.level = 'CASE' THEN ieap.lpn ELSE NULL END END AS case_id FROM inventory as i INNER JOIN item as it ON i.item_id = it.item_id LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn LEFT JOIN inventory_notes as inote ON inote.lpn = (CASE WHEN iea.level = 'CASE' THEN iea.lpn ELSE CASE WHEN ieap.level = 'CASE' THEN ieap.lpn ELSE NULL END END)  LEFT JOIN list_value as lv ON i.inventory_status = lv.option_value AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' INNER JOIN location AS lo ON lo.company_id = '${companyId}' AND lo.location_id = (CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END)  WHERE i.company_id = '${companyId}' AND (i.associated_lpn LIKE '${palletId}' OR iea.lpn LIKE '${palletId}' OR iea.parent_lpn LIKE '${palletId}') OR (i.associated_lpn LIKE '${caseId}' OR iea.lpn LIKE '${caseId}' OR iea.parent_lpn LIKE '${caseId}') ORDER BY i.inventory_id DESC "

				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows(sqlQuery)
				return rows
		}


		def priorDayInventoryAdjusted(String companyId) {

				def sqlQuery = " SELECT ia.*, lv.description as previous_inventory_status_desc, lv1.description as inventory_status_desc  " +
								" FROM inventory_adjustment AS ia " +
								" LEFT JOIN list_value as lv ON lv.option_value = ia.previous_inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
								" LEFT JOIN list_value as lv1 ON lv1.option_value = ia.inventory_status AND lv1.option_group='INVSTATUS' AND lv1.company_id = '${companyId}'  " +
								" WHERE ia.company_id = '${companyId}' AND ia.created_date >= CURDATE() - INTERVAL 1 DAY AND ia.created_date < CURDATE() "

				log.info("sql : " + sqlQuery)

				def sql = new Sql(sessionFactory.currentSession.connection())
				return sql.rows(sqlQuery)
		}

		def inventoryAdjustedFromTo(companyId, fromDate, toDate) {
				def convertedFromDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate)
				def convertedToDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toDate)

				def fromDateFormat = convertedFromDate.format('yyyy-MM-dd')
				convertedToDate.set(hourOfDay: 23, minute: 59, second: 0)
				def toDateFormat = convertedToDate.format('yyyy-MM-dd HH:mm:ss')

				println fromDateFormat
				println toDateFormat

				def sqlQuery = " SELECT ia.*, lv.description as previous_inventory_status_desc, lv1.description as inventory_status_desc  " +
								" FROM inventory_adjustment AS ia " +
								" LEFT JOIN list_value as lv ON lv.option_value = ia.previous_inventory_status AND lv.option_group='INVSTATUS' AND lv.company_id = '${companyId}'  " +
								" LEFT JOIN list_value as lv1 ON lv1.option_value = ia.inventory_status AND lv1.option_group='INVSTATUS' AND lv1.company_id = '${companyId}'  " +
								" WHERE ia.company_id = '${companyId}' AND ia.created_date >= '${fromDateFormat}' AND ia.created_date < '${toDateFormat}' "

				log.info("sql : " + sqlQuery)

				def sql = new Sql(sessionFactory.currentSession.connection())
				return sql.rows(sqlQuery)


		}

		def getInventoryDataByIdAndCompany(companyId, inventoryId) {
				def sqlQuery = "SELECT i.item_id, it.item_description, i.quantity, i.handling_uom, i.inventory_id, i.lot_code, lv.description as inventory_status, i.inventory_status as inventory_status_option_value, i.expiration_date,inote.notes, CASE WHEN i.location_id IS NOT NULL THEN i.location_id ELSE CASE WHEN iea.location_id IS NOT NULL THEN iea.location_id ELSE ieap.location_id END END AS location_id, CASE WHEN iea.level = 'PALLET' THEN iea.lpn ELSE CASE WHEN ieap.level = 'PALLET' THEN ieap.lpn ELSE NULL END END AS pallet_id, CASE WHEN iea.level = 'CASE' THEN iea.lpn ELSE CASE WHEN ieap.level = 'CASE' THEN ieap.lpn ELSE NULL END END AS case_id FROM inventory as i INNER JOIN item as it ON i.item_id = it.item_id LEFT JOIN inventory_entity_attribute as iea ON i.associated_lpn = iea.lpn LEFT JOIN inventory_entity_attribute as ieap ON iea.parent_lpn = ieap.lpn LEFT JOIN inventory_notes as inote ON inote.lpn = iea.lpn LEFT JOIN list_value as lv ON i.inventory_status = lv.option_value AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' WHERE i.company_id = '${companyId}' AND i.inventory_id = '${inventoryId}'"

				def sql = new Sql(sessionFactory.currentSession.connection())
				def rows = sql.rows(sqlQuery)
				return rows
		}

}

