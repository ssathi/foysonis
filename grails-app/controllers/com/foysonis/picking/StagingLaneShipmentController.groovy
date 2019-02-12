package com.foysonis.picking

import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_USER','ROLE_ADMIN'])
class StagingLaneShipmentController extends RestfulController<StagingLaneShipment> {

        def sessionFactory
        def stagingLaneShipmentService
        def allocationFailedMessageService

        static responseFormats = ['json', 'xml']

        StagingLaneShipmentController() {
            super(StagingLaneShipment)
        }

        def index = {}

        def getLocations = {
            respond stagingLaneShipmentService.getLocations(session.user.companyId, params['isStaging'], params.keyword)
        }

        def getLocationsByArea = {
            respond stagingLaneShipmentService.getLocationsByArea(session.user.companyId, params['isStaging'], params.keyword)
        }

        def getStagingAreas = {
            respond stagingLaneShipmentService.getStagingAreas(session.user.companyId, params['isStaging'])
        }

        def getShipment = {
            respond stagingLaneShipmentService.getShipment(session.user.companyId, params['locationId'])
        }

        def getShipmentCancelAllocation ={
            respond stagingLaneShipmentService.getShipmentCancelAllocation(session.user.companyId, params['shipmentId'])
        }

        //failedmsg
        def getFailedMessageByShipment = {
            respond allocationFailedMessageService.getFailedMessageByShipment(session.user.companyId, params['shipmentId'])
        }

        def getFailedMessageByShipmentForView = {
            respond allocationFailedMessageService.getFailedMessageByShipmentForView(session.user.companyId, params['shipmentId'])
        }

        //

        def getInventory = {
            respond stagingLaneShipmentService.getInventory(session.user.companyId, params['locationId'])
        }

    }
