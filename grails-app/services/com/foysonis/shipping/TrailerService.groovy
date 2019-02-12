package com.foysonis.shipping

import com.foysonis.orders.Shipment
import com.foysonis.orders.ShipmentStatus
import grails.transaction.Transactional

@Transactional
class TrailerService {

    def createTrailer(companyId, trailerNumber, shipmentId) {

        //def openedTrailer = Trailer.findByCompanyIdAndTrailerNumberAndStatus(companyId, trailerNumber, 'OPEN')
        def openedTrailer = Trailer.find("from Trailer where companyId = '${companyId}' and trailerNumber = '${trailerNumber}' and status = 'OPEN' order by id desc")

        if(!openedTrailer){
            def trailer = Trailer.findByCompanyIdAndTrailerNumber(companyId, trailerNumber)
            if (trailer) {
                if (trailer.status == TrailerStatus.CLOSED) {
                    trailer.status = TrailerStatus.OPEN
                    trailer.save(flush: true, failOnError: true)
                }

                else if (trailer.status == TrailerStatus.DISPATCHED) {
                    Date getDispachedDate = trailer.dispatchedDate
                    def compareTime = null
                     use (groovy.time.TimeCategory) {
                         def currentDate = new Date()
                         def minus24h = currentDate - 24.hours
                         compareTime = minus24h < getDispachedDate
                        }
                    if (!compareTime) {
                        def newTrailer = new Trailer()
                        newTrailer.companyId = companyId
                        newTrailer.trailerNumber = trailerNumber
                        newTrailer.status = TrailerStatus.OPEN
                        newTrailer.save(flush: true, failOnError: true)   
                        def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
                        if (getShipment) {
                            getShipment.truckInstanceId = newTrailer.id 
                            getShipment.save(flush: true, failOnError: true)                       
                        }                                         
                    }
                    else{
                        def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
                        if (getShipment) {
                            getShipment.shipmentStatus = ShipmentStatus.STAGED
                            getShipment.truckInstanceId = null
                            getShipment.truckNumber = null 
                            getShipment.save(flush: true, failOnError: true)
                        } 
                        return [error: 'This Truck can not be assigned to this shipment as it is dispatched before 24 hours']
                    }
                }                
            }
            else{
                def newTrailer = new Trailer()
                newTrailer.companyId = companyId
                newTrailer.trailerNumber = trailerNumber
                newTrailer.status = TrailerStatus.OPEN
                newTrailer.save(flush: true, failOnError: true)    
                def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
                if (getShipment) {
                    getShipment.truckInstanceId = newTrailer.id 
                    getShipment.save(flush: true, failOnError: true)                       
                }                            
            } 
        }
        else{
            def getShipment = Shipment.findByCompanyIdAndShipmentId(companyId, shipmentId)
            if (getShipment) {
                getShipment.truckInstanceId = openedTrailer.id 
                getShipment.save(flush: true, failOnError: true)
            }
            return openedTrailer
        }        
    }

    def validateTruckNumber(companyId, trailerNumber){
        def openedTrailer = Trailer.findAllByCompanyIdAndTrailerNumberAndStatus(companyId, trailerNumber, TrailerStatus.OPEN)
        def dispatchedTrailer = Trailer.findAllByCompanyIdAndTrailerNumberAndStatus(companyId, trailerNumber, TrailerStatus.DISPATCHED)
        if (openedTrailer.size() > 0) {
            return []
        }
        else if(dispatchedTrailer.size() > 0){
                def getDispachedDate = dispatchedTrailer[0].dispatchedDate
                def compareTime = null
                 use (groovy.time.TimeCategory) {
                     def currentDate = new Date()
                     def minus24h = currentDate - 24.hours
                     compareTime = minus24h < getDispachedDate
                    }
                if (compareTime) {
                    return [type: 'error', error: 'This Shipment can not be assigned to the shipment as it is dispatched']                 
                }
                else{
                    return []
                }
        }
        else{
            return []
        }
    }
}
