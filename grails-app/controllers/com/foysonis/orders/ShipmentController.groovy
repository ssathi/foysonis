package com.foysonis.orders

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_USER','ROLE_ADMIN'])
class ShipmentController extends RestfulController<Shipment> {
    def shipmentService
    def sessionFactory
    def springSecurityService

    static responseFormats = ['json', 'xml']

    ShipmentController() {
        super(Shipment)
    }

    def getPlannedShipment = {
        respond shipmentService.getPlannedShipment(session.user.companyId, params['customerId'])
    }

    def  saveShipment() {

        if(params['orderLineNumbers']) {
            respond shipmentService.assignMultipleOrderLineToNewShipment(session.user.companyId,
                    params['carrierCode'],
                    params['isParcel'] ? params['isParcel'] : 'false',
                    params['serviceLevel'],
                    params['trackingNo'],
                    params['truckNumber'],
                    params['orderNumber'],
                    params['orderLineNumbers'],
                    params['contactName'],
                    params['shippingAddressId'])

        }
        else{
            respond shipmentService.saveShipment(session.user.companyId,
                    params['carrierCode'],
                    params['isParcel'] ? params['isParcel'] : 'false',
                    params['serviceLevel'],
                    params['trackingNo'],
                    params['truckNumber'],
                    params['orderNumber'],
                    params['orderLineNumber'],
                    params['contactName'],
                    params['shippingAddressId'],
                    params['shipmentNotes'])
        }


    }

    def  assignToPlannedShipment() {
        if(params['orderLineNumbers']) {
            respond shipmentService.assignMultipleOrderLineToPlannedShipment(session.user.companyId,
                    params['shipmentId'],
                    params['orderNumber'],
                    params['orderLineNumbers'])
        }
        else{
            respond shipmentService.assignToPlannedShipment(session.user.companyId,
                    params['shipmentId'],
                    params['orderNumber'],
                    params['orderLineNumber'])
        }
    }

    def getShipmentIds(){
        respond shipmentService.getShipmentIds(session.user.companyId, params['orderNumber'])
    }

    def editShipment() {
        shipmentService.editShipment(session.user.companyId,
                params['carrierCode'],
                params['isParcel'] ? params['isParcel'] : 'false',
                params['serviceLevel'],
                params['trackingNo'],
                params['truckNumber'],
                params['shipmentId'],
                params['contactName'],
                params['shippingAddressId'],
                params['shipmentNotes'])
    }

    def editShipmentWithNewShippingAddress() {

        CustomerAddress customerAddress = new CustomerAddress()
        customerAddress.companyId = session.user.companyId
        customerAddress.customerId = params.customerId
        customerAddress.addressType = 'shipping'
        customerAddress.streetAddress = params.streetAddress
        customerAddress.city = params.city
        customerAddress.state = params.state
        customerAddress.postCode = params.postCode
        customerAddress.country = params.country
        customerAddress.isDefault = false


        shipmentService.editShipmentWithNewShippingAddress(session.user.companyId,
                params['carrierCode'],
                params['isParcel'] ? params['isParcel'] : 'false',
                params['serviceLevel'],
                params['trackingNo'],
                params['truckNumber'],
                params['shipmentId'],
                params['contactName'],
                params['shipmentNotes'],
                customerAddress)
    }


    def getAllShipmentData(){

        def sqlQuery = "SELECT sh.shipment_id, sh.is_parcel, sh.service_level, sh.shipment_status, sh.tracking_no, sh.truck_number, sh.creation_date, sh.completed_date, sh.truck_instance_id, sh.shipping_address_id, sh.contact_name AS contactName, sh.shipment_notes, sl.*, odr.*, cus.*, lv.description AS carrier_code, lv.option_value AS carrier_code_option_value, ca.*, sh.wave_number AS waveNumber FROM shipment AS sh INNER JOIN shipment_line as sl on sh.shipment_id = sl.shipment_id INNER JOIN customer_address as ca on ca.id = sh.shipping_address_id AND ca.address_type = 'shipping' AND ca.company_id = '${session.user.companyId}' INNER JOIN orders as odr on sl.order_number = odr.order_number INNER JOIN customer as cus on cus.customer_id = odr.customer_id LEFT JOIN list_value as lv ON lv.option_value = sh.carrier_code AND lv.option_group = 'CARRCODE' AND lv.company_id = '${session.user.companyId}' WHERE odr.order_number = '${params.orderNum}' AND sl.company_id = '${session.user.companyId}' group by sh.shipment_id"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        respond rows        
    }
    def getShipmentLineData(){
//        def sqlQuery = "SELECT sl.shipment_line_id, sl.order_number, sl.order_line_number, sl.item_id, sl.shippeduom, sl.shipped_quantity FROM shipment_line AS sl WHERE sl.company_id = '${session.user.companyId}' AND sl.shipment_id = '${params.shipmentId}'"

        def sqlQuery = "SELECT sl.*,ol.order_line_number,ol.display_order_line_number FROM shipment_line AS sl INNER JOIN order_line as ol on sl.order_line_number = ol.order_line_number  WHERE sl.company_id = '${session.user.companyId}' AND sl.shipment_id = '${params.shipmentId}'"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        respond rows          
    }

    def cancelShipment(){
       def jsonObject = request.JSON 
       respond shipmentService.cancelShipment(session.user.companyId, jsonObject)
    }  

    def cancelShipmentLine(){
       def jsonObject = request.JSON 
       respond shipmentService.cancelShipmentLine(session.user.companyId, jsonObject)
    }

    def getShipmentStatusCount = {
        respond shipmentService.getShipmentStatusCount(session.user.companyId)
    }


    def getShipmentReport(){
        return Shipment.findAllByCompanyId(session.user.companyId)
        //return ['rfda','afsadf','asdfsdfa','asdfsfd']
 
    }


    //
    def getShipmentByShipmentLine = {
        respond shipmentService.getShipmentByShipmentLine(session.user.companyId, params['shipmentLineId'])
    }
    //


    def saveShipmentWithNewShippingAddress = {

        def jsonObject = request.JSON
        CustomerAddress customerAddress = new CustomerAddress()
        customerAddress.companyId = session.user.companyId
        customerAddress.customerId = params.customerId
        customerAddress.addressType = 'shipping'
        customerAddress.streetAddress = params.streetAddress
        customerAddress.city = params.city
        customerAddress.state = params.state
        customerAddress.postCode = params.postCode
        customerAddress.country = params.country
        customerAddress.isDefault = false

        if(params['orderLineNumbers']) {
            respond shipmentService.assignMultipleOrderLineToNewShipmentWithNewAdress(session.user.companyId,
                    params['carrierCode'],
                    params['isParcel'] ? params['isParcel'] : 'false',
                    params['serviceLevel'],
                    params['trackingNo'],
                    params['truckNumber'],
                    params['orderNumber'],
                    params['orderLineNumbers'],
                    params['contactName'],
                    customerAddress)

        }
        else{
            respond shipmentService.saveShipmentWithNewShippingAddress(session.user.companyId,
                    params['carrierCode'],
                    params['isParcel'] ? params['isParcel'] : 'false',
                    params['serviceLevel'],
                    params['trackingNo'],
                    params['truckNumber'],
                    params['orderNumber'],
                    params['orderLineNumber'],
                    params['contactName'],
                    params['shipmentNotes'],
                    customerAddress)
        }
    }



    def priorDayInventoryShipped = {
        respond shipmentService.priorDayInventoryShipped(springSecurityService.currentUser.companyId)
    }

    def getPackoutShipmentContent(){
        respond shipmentService.getPackoutShipmentContent(session.user.companyId, params.shipmentId)
    }

    def getWaveShipments(){
        respond shipmentService.getWaveShipments(session.user.companyId, params.waveNumber)
    }
}
