package com.foysonis.inventory

import grails.transaction.Transactional
import com.foysonis.item.Item
import groovy.sql.Sql

@Transactional
class MoveInventoryService {

    def saveMovePalletHistory(String companyId, String fromLocationId, String toLocationId, String lPN, String username) {
        MoveInventory moveInventory = new MoveInventory()
        moveInventory.companyId = companyId
        moveInventory.moveType = InventoryMoveType.PALLET
        moveInventory.fromLocationId = fromLocationId
        moveInventory.lPN = lPN
        moveInventory.itemId = null
        moveInventory.itemDescription = null
        moveInventory.inventoryStatus = null
        moveInventory.quantity = null
        moveInventory.toPalletId = null
        moveInventory.toLocationId = toLocationId
        moveInventory.createdDate = new Date()
        moveInventory.userId = username
        moveInventory.save(flush: true, failOnError: true)

    }

    def saveMoveCaseToLocationHistory(String companyId, String fromLocationId, String toLocationId, String lPN, String username) {
        MoveInventory moveInventory = new MoveInventory()
        moveInventory.companyId = companyId
        moveInventory.moveType = InventoryMoveType.CASE
        moveInventory.fromLocationId = fromLocationId
        moveInventory.lPN = lPN
        moveInventory.itemId = null
        moveInventory.itemDescription = null
        moveInventory.inventoryStatus = null
        moveInventory.quantity = null
        moveInventory.toPalletId = null
        moveInventory.toLocationId = toLocationId
        moveInventory.createdDate = new Date()
        moveInventory.userId = username
        moveInventory.save(flush: true, failOnError: true)

    }

    def saveMoveCaseToPalletHistory(String companyId, String fromLocationId, String toPalletId, String lPN, String username) {
        MoveInventory moveInventory = new MoveInventory()
        moveInventory.companyId = companyId
        moveInventory.moveType = InventoryMoveType.CASE
        moveInventory.fromLocationId = fromLocationId
        moveInventory.lPN = lPN
        moveInventory.itemId = null
        moveInventory.itemDescription = null
        moveInventory.inventoryStatus = null
        moveInventory.quantity = null
        moveInventory.toPalletId = toPalletId
        moveInventory.toLocationId = null
        moveInventory.createdDate = new Date()
        moveInventory.userId = username
        moveInventory.save(flush: true, failOnError: true)

    }

    def saveMoveEntireLocationHistory(String companyId, String fromLocationId, String toLocationId, String username) {


        def inventoryEntityAttributes = InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, fromLocationId)

        if(inventoryEntityAttributes){

            for (iea in inventoryEntityAttributes){

                def lpnInventory = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, iea.lPN)

                if(lpnInventory){

                    for(lpnInv in lpnInventory){

                        Item item = Item.findByCompanyIdAndItemId(companyId, lpnInv.itemId)

                        MoveInventory moveInventory = new MoveInventory()
                        moveInventory.companyId = companyId
                        moveInventory.moveType = InventoryMoveType.LOCATION
                        moveInventory.fromLocationId = fromLocationId
                        moveInventory.lPN = lpnInv.associatedLpn
                        moveInventory.itemId = lpnInv.itemId
                        moveInventory.itemDescription = item.itemDescription
                        moveInventory.inventoryStatus = lpnInv.inventoryStatus
                        moveInventory.quantity = lpnInv.quantity
                        moveInventory.toPalletId = null
                        moveInventory.toLocationId = toLocationId
                        moveInventory.createdDate = new Date()
                        moveInventory.userId = username
                        moveInventory.save(flush: true, failOnError: true)
                    }
                }


                //Parent Lpn
                def childInventoryEntityAttributes = InventoryEntityAttribute.findAllByCompanyIdAndParentLpn(companyId, iea.lPN)

                if(childInventoryEntityAttributes){

                    for (childIea in childInventoryEntityAttributes){

                        def childInventory = Inventory.findAllByCompanyIdAndAssociatedLpn(companyId, iea.lPN)

                        if(childInventory){

                            for(childInv in childInventory){

                                Item item = Item.findByCompanyIdAndItemId(companyId, childInv.itemId)

                                MoveInventory moveInventory = new MoveInventory()
                                moveInventory.companyId = companyId
                                moveInventory.moveType = InventoryMoveType.LOCATION
                                moveInventory.fromLocationId = fromLocationId
                                moveInventory.lPN = childInv.associatedLpn
                                moveInventory.itemId = childInv.itemId
                                moveInventory.itemDescription = item.itemDescription
                                moveInventory.inventoryStatus = childInv.inventoryStatus
                                moveInventory.quantity = childInv.quantity
                                moveInventory.toPalletId = null
                                moveInventory.toLocationId = toLocationId
                                moveInventory.createdDate = new Date()
                                moveInventory.userId = username
                                moveInventory.save(flush: true, failOnError: true)
                            }
                        }
                    }
                }
            }
        }


        def inventory = Inventory.findAllByCompanyIdAndLocationId(companyId, fromLocationId)

        if(inventory){

            for(inv in inventory){

                Item item = Item.findByCompanyIdAndItemId(companyId, inv.itemId)

                MoveInventory moveInventory = new MoveInventory()
                moveInventory.companyId = companyId
                moveInventory.moveType = InventoryMoveType.LOCATION
                moveInventory.fromLocationId = fromLocationId
                moveInventory.lPN = null
                moveInventory.itemId = inv.itemId
                moveInventory.itemDescription = item.itemDescription
                moveInventory.inventoryStatus = inv.inventoryStatus
                moveInventory.quantity = inv.quantity
                moveInventory.toPalletId = null
                moveInventory.toLocationId = toLocationId
                moveInventory.createdDate = new Date()
                moveInventory.userId = username
                moveInventory.save(flush: true, failOnError: true)
            }
        }

    }

    def saveMoveEachHistory(String companyId, String fromLocationId, String itemId, String inventoryStatus, Integer quantity, String toLocationId, String username) {
        Item item = Item.findByCompanyIdAndItemId(companyId, itemId)
        MoveInventory moveInventory = new MoveInventory()
        moveInventory.companyId = companyId
        moveInventory.moveType = InventoryMoveType.EACH
        moveInventory.fromLocationId = fromLocationId
        moveInventory.lPN = null
        moveInventory.itemId = itemId
        moveInventory.itemDescription = item.itemDescription
        moveInventory.inventoryStatus = inventoryStatus
        moveInventory.quantity = quantity
        moveInventory.toPalletId = null
        moveInventory.toLocationId = toLocationId
        moveInventory.createdDate = new Date()
        moveInventory.userId = username
        moveInventory.save(flush: true, failOnError: true)

    }


}
