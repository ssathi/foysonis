package com.foysonis.area

import com.foysonis.inventory.Inventory
import com.foysonis.inventory.InventoryEntityAttribute
import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class LocationService {
    def sessionFactory

    def getAllLocationsByArea(companyId, areaId){
        return Location.findAllByCompanyIdAndAreaId(companyId, areaId)
    }

    def deleteLocation(companyId, locationId){
        def location = Location.findWhere(companyId: companyId, locationId: locationId)
        location.delete()
        return location
    }


    def checkLocationIdExist(companyId, locationId){
        return Location.findAll("from Location as l where l.companyId = '${companyId}' AND (l.locationId = '${locationId}' OR l.locationBarcode = '${locationId}') ")
    }

    def checkLocationIdAndLocationBarcodeExist(companyId, locationBarcode, locationId){
        return Location.findAll("from Location as l where l.companyId = '${companyId}' AND l.locationId != '${locationId}' AND (l.locationId = '${locationBarcode}' OR l.locationBarcode = '${locationBarcode}') ")
    }

    def getCompanyActiveLocations(companyId) {
        return Location.findAllByCompanyIdAndIsBlocked(companyId, false)
    }

    def getCompanyAllLocations(companyId, keyword) {
        def keyLocationId = '%'+keyword+'%'
        //return Location.findAllByCompanyIdAndLocationIdLike(companyId, keyLocationId,[max: 10, sort: "locationId", order: "asc"])
        return Location.findAll("from Location as l where l.companyId = '${companyId}' AND (l.locationId LIKE '${keyLocationId}' OR l.locationBarcode  LIKE '${keyLocationId}') ORDER BY l.locationId asc ",[max: 10])
    }

    def getCompanyAllUnblockedLocations(companyId, keyword) {
        def keyLocationId = '%'+keyword+'%'
        //return Location.findAllByCompanyIdAndLocationIdLike(companyId, keyLocationId,[max: 10, sort: "locationId", order: "asc"])
        //return Location.findAll("from Location as l where l.companyId = '${companyId}' AND (l.locationId LIKE '${keyLocationId}' OR l.locationBarcode  LIKE '${keyLocationId}') AND l.isBlocked = false ORDER BY l.locationId asc ",[max: 10])
        def sqlQuery = "SELECT *, l.location_id as locationId FROM location as l INNER JOIN area as a ON l.area_id = a.area_id AND a.company_id = '${companyId}' WHERE l.company_id = '${companyId}' AND (l.location_id LIKE '${keyLocationId}' OR l.location_barcode  LIKE '${keyLocationId}') AND l.is_blocked = false ORDER BY l.location_id asc LIMIT 10"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }


    def getAreaForLocation(companyId, locationId) {
        def location = Location.findByCompanyIdAndLocationId(companyId, locationId)
        return Area.findByCompanyIdAndAreaId(companyId, location.areaId)
    }

//
    def blockLocation(companyId, receiptData){
        def location = Location.findByCompanyIdAndLocationId(companyId, receiptData.locationId)
        if (location) {
            location.isBlocked = true
            location.save(flush:true, failOnError:true)
        }
    }

    def unBlockLocation(companyId, receiptData){
        def location = Location.findByCompanyIdAndLocationId(companyId, receiptData.locationId)
        if (location) {
            location.isBlocked = false
            location.save(flush:true, failOnError:true)
        }
    }

    def checkInventoryForLocation(companyId, locationId) {
        def getLocationByInventory = Inventory.findAllByCompanyIdAndLocationId(companyId, locationId)
            if (getLocationByInventory.size()>0) {
                return getLocationByInventory
            }
            else {
                getLocationByInventory = InventoryEntityAttribute.findAllByCompanyIdAndLocationId(companyId, locationId)
                if (getLocationByInventory.size()>0) {
                    return getLocationByInventory
                }
                else{
                    return getLocationByInventory
                }
            }
    }

    def emptyPickableLocations(companyId){
        def locationMap = []
        def areas = Area.findAllByCompanyIdAndIsPickable(companyId, true)

        if(areas){
            for(area in areas){

                def pickableLocations = Location.findAllByCompanyIdAndAreaIdAndIsBlocked(companyId, area.areaId, false)

                if(pickableLocations){
                    for(location in pickableLocations){
                        def inventory = Inventory.findByCompanyIdAndLocationId(companyId, location.locationId)

                        if(inventory == null){
                            def inventoryEntityAttribute = InventoryEntityAttribute.findByCompanyIdAndLocationId(companyId, location.locationId)

                            if(inventoryEntityAttribute == null){
                                locationMap.push(location.locationId)
                            }

                        }
                    }
                }
            }


        }


        return locationMap

    }

    def checkPndLocationByLocationAndCompany(companyId, locationId){
        def sqlQuery = "SELECT * FROM location as l INNER JOIN area as a ON l.area_id = a.area_id AND a.company_id = '${companyId}' WHERE l.location_id = '${locationId}' AND a.is_pnd = true AND l.is_blocked = false and l.company_id = '${companyId}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def validateLocationForMovePallet(companyId, locationId) {
        def location = Location.findByCompanyIdAndLocationIdAndIsBlocked(companyId, locationId, false)
        if(location){
            return [locationId: locationId, allowToMove: true]
        } else {
            return [locationId: locationId, allowToMove: false]
        }
    }

    def checkLocationUnavailable(companyId){
        def errorMessage = null
        def unblockedLocations = Location.findAllByCompanyIdAndIsBlocked(companyId, false)
        if (!unblockedLocations)
            errorMessage = "There are no unblocked locations found"

        return errorMessage

    }
}

