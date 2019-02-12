package com.foysonis.picking

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class AllocationFailedMessageService {
    def sessionFactory

    def createAllocationFailedMessage(companyId, shipmentId, message){
        def allocationFailedMessage = new AllocationFailedMessage()
        allocationFailedMessage.companyId = companyId
        allocationFailedMessage.shipmentId = shipmentId
        allocationFailedMessage.message = message
        allocationFailedMessage.createdDate = new Date()

        allocationFailedMessage.save(flush: true, failOnError: true)
    }

    //
    def getFailedMessageByShipment(companyId, shipmentId) {
        return AllocationFailedMessage.findAll("FROM AllocationFailedMessage WHERE companyId = '${companyId}' AND shipmentId = '${shipmentId}' ORDER BY createdDate DESC ", [max: 1])
    }

    def getFailedMessageByShipmentForView(companyId, shipmentId) {
        return AllocationFailedMessage.findAll("FROM AllocationFailedMessage WHERE companyId = '${companyId}' AND shipmentId = '${shipmentId}' ORDER BY createdDate DESC ", [max: 5])
    }
    //

    def deleteAllocationFailedMsgByShipment(companyId, shipmentId){
        def allocationFailedMsgRaws = AllocationFailedMessage.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
        if (allocationFailedMsgRaws.size() > 0) {
            for(rowByShipment in allocationFailedMsgRaws) {
                rowByShipment.delete(flush:true, failOnError:true)
            }
        }
    }

}
