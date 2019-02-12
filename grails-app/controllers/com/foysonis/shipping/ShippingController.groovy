package com.foysonis.shipping

import com.foysonis.orders.Shipment
import com.foysonis.orders.ShipmentLine
import com.foysonis.orders.OrderLine
import com.foysonis.picking.PickWork
import com.foysonis.jasperReport.ShipmentReportInfo
import com.foysonis.user.Company
import com.foysonis.orders.CustomerAddress
import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_USER','ROLE_ADMIN'])
class ShippingController extends RestfulController<Shipment> {

    def sessionFactory
    def shippingService
    def trailerService
    def springSecurityService
    def billingService

    static responseFormats = ['json', 'xml']

    ShippingController() {
        super(Shipment)
    }

    def index() {

        def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
        if (billingData) {
            def trialEndDate = null
            use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
            if (billingData.isTrial == true && trialEndDate < new Date()) {

                if(springSecurityService.currentUser.adminActiveStatus == true){
                    redirect(controller:"userAccount",action:"index")
                    return
                }
                else{
                    redirect(controller:"userAccount",action:"index")
                    return
                }


            }
            else if(springSecurityService.currentUser.isTermAccepted != true){
                redirect(controller:"userAccount",action:"index")
                return
            }
        }
        else if(springSecurityService.currentUser.isTermAccepted != true){
            redirect(controller:"userAccount",action:"index")
            return
        }
        session.user = springSecurityService.currentUser
        def pageTitle = "Shipping Dock";
        [pageTitle:pageTitle]
    }

    //active shipments

    def shipmentSearch () {
       respond shippingService.shipmentSearch(session.user.companyId,
                                                params.orderNumber,
                                                params.shipmentId,
                                                params.truckNumber,
                                                params.smallPackage,
                                                params.completedDateRange,
                                                params.completedDate,
                                                params.kittingOrderNumber)
    }

    def findAllShipmentLinesByShipmentId(){
        respond shippingService.findAllShipmentLinesByShipmentId(session.user.companyId, params.selectedShipmentId)
    }


    def findAllPickWorksByShipmentLine(){
        respond shippingService.findAllPickWorksByShipmentLine(session.user.companyId, params.selectedShipmentLine)
    }

    def findAssociatedLpnByReference(){
        respond shippingService.findAssociatedLpnByReference(session.user.companyId, params.selectedWorkReference)
    }

    def findAllPickWorksByShipment(){
        respond shippingService.findAllPickWorksByShipment(session.user.companyId, params.selectedShipment)
    }

    def findOderByShipment(){
        respond shippingService.findOderByShipment(session.user.companyId, params.selectedShipment)
    }

    def findShipment(){
        respond shippingService.findShipment(session.user.companyId, params.shipmentId)
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

        log.info("customerAddress  : " + customerAddress)


        respond shippingService.editShipmentWithNewShippingAddress(session.user.companyId,
                params['carrierCode'],
                params['isParcel'] ? params['isParcel'] : 'false',
                params['serviceLevel'],
                params['trackingNo'],
                params['truckNumber'],
                params['contactName'],
                params['shipmentId'],
                customerAddress,
                params['shipmentNotes']
        )
    }


    def editShipment() {
        respond shippingService.editShipment(session.user.companyId,
                            params['carrierCode'],
                            params['isParcel'] ? params['isParcel'] : 'false',
                            params['serviceLevel'],
                            params['trackingNo'],
                            params['truckNumber'],
                            params['contactName'],
                            params['shipmentId'],
                            params['shippingAddressId'],
                            params['shipmentNotes'])
    }

    def completeShipment() {
         respond shippingService.completeShipment(session.user.companyId,params.shipmentId,params.workReferenceNumber,params.orderNumber, params.noOfLabels)
    }

    def editShippedQty() {
        def jsonObject = request.JSON
        def shipmentLine = ShipmentLine.findByCompanyIdAndShipmentLineId(session.user.companyId, jsonObject.shipmentLineId)
        if (shipmentLine) {
            shipmentLine.properties = [shippedQuantity:jsonObject.shippedQuantity]
            shipmentLine.save(flush: true, failOnError: true)
            respond true
        }
    }

    def findOrderLine() {
        respond shippingService.findOrderLine(session.user.companyId, params.shipmentLineId)
    }

    def getTotalPickQty() {
        respond shippingService.getTotalPickQty(session.user.companyId, params.selectedShipmentLine)
    }

    def getLocations() {
        respond shippingService.getLocations(session.user.companyId, params['isStaging'])
    }

    def getShipment() {
        respond shippingService.getShipment(session.user.companyId, params['locationId'])
    }

    def loadShipment() {
        shippingService.loadShipment(session.user.companyId, params['truckNumber'], params['shipmentId'], params['noOfLabels'])
        respond trailerService.createTrailer(session.user.companyId, params['trailerNumber'], params['shipmentId'])
    }

    def voidShipment() {
        respond shippingService.voidShipment(session.user.companyId,params.shipmentId,params.workReferenceNumber,params.locationId,params.orderNumber)
    }


    def checkTruckNumberExist() { 
        respond shippingService.checkTruckNumberExist(session.user.companyId, params['truckNumber'])
    }

    def findAllShippedInventoryByShipmentLine() {
        respond shippingService.findAllShippedInventoryByShipmentLine(session.user.companyId, params.selectedShipmentLine)
    }

    def findAllInventoryByShipmentLine() {
        respond shippingService.findAllInventoryByShipmentLine(session.user.companyId, params.selectedShipmentLine)
    }

    //active trucks

    def truckSearch () {
        respond shippingService.truckSearch(session.user.companyId, params.truckNumber, params.dispatchedDateRange, params.dispatchedDate)
    }

    def findTruck(){
        respond shippingService.findTruck(session.user.companyId, params.id)
    }

    def closeTruck() {
        respond shippingService.closeTruck(session.user.companyId, params.id)
    }

    def openTruck() {
        respond shippingService.openTruck(session.user.companyId, params.id)
    }

    def dispatchTruck() {
        respond shippingService.dispatchTruck(session.user.companyId, params.id)
    }

    def validateTruckNumber = {
        respond trailerService.validateTruckNumber(session.user.companyId, params.truckNumber)
    }

    //BOL
    def getCompanyPrefix() {
        def sqlQuery = "SELECT * from company as c WHERE c.company_id = '${session.user.companyId}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        respond rows

    }

    def getSerializedNumberByCompany() {
        def sqlQuery = "SELECT * from bill_of_lading as bol WHERE bol.company_id = '${session.user.companyId}'"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        respond rows

    }

    def saveSerializedNumberByCompany() {
//        def billOfLading = new BillOfLading()
// //            def billOfLading = BillOfLading.findAllByCompanyIdAndSerializedNumber(session.user.companyId, params.serializedNumber)
// //        def billOfLading = BillOfLading.find("from BillOfLading as bol where bol.companyId='${session.user.companyId}'")

//        def serializedNumberExist = BillOfLading.find("from BillOfLading as bol where bol.companyId='${session.user.companyId}' order by serializedNumber DESC")
//        if (!serializedNumberExist) {
//            billOfLading.serializedNumber = "000"
// //                billOfLading.companyId = session.user.companyId
//        }
//        else{
//            def serializedNumberInteger = serializedNumberExist.serializedNumber
//            def intIndex = serializedNumberInteger.toInteger()
//            intIndex = intIndex + 1
//            def stringIndex = intIndex.toString().padLeft(3,"0")
//            billOfLading.serializedNumber = stringIndex
//        }

//        billOfLading.companyId = session.user.companyId
//        respond billOfLading.save(flush: true, failOnError: true)

        def shipments = Shipment.findAllByCompanyIdAndTruckNumber(session.user.companyId, params.truckNumber)

        if (shipments) {

            for(shipment in shipments) {

                def getShipmentReportInfo = ShipmentReportInfo.findByCompanyIdAndShipmentId(session.user.companyId, shipment.shipmentId)
                if (!getShipmentReportInfo) {

                    def shipmentReportInfo = new ShipmentReportInfo()

                    shipmentReportInfo.companyId = session.user.companyId
                    shipmentReportInfo.shipmentId = shipment.shipmentId
                    shipmentReportInfo.prepaid = false
                    shipmentReportInfo.collect = false
                    shipmentReportInfo.thirdParty = false

                    def serializedNumberExist = ShipmentReportInfo.find("from ShipmentReportInfo as sri where sri.companyId='${session.user.companyId}' order by serializedNumber DESC")
                    if (!serializedNumberExist) {
                        shipmentReportInfo.serializedNumber = "000"
                    }
                    else{
                       def serializedNumberInteger = serializedNumberExist.serializedNumber
                       def intIndex = serializedNumberInteger.toInteger()
                       intIndex = intIndex + 1
                       def stringIndex = intIndex.toString().padLeft(3,"0")
                       shipmentReportInfo.serializedNumber = stringIndex   
                    }

                    def getCompanyPrefix = Company.findByCompanyId(session.user.companyId)

                    def prefixAndSerial = getCompanyPrefix.gsiCompanyPrefix+shipmentReportInfo.serializedNumber
                    def stringList = prefixAndSerial.collect{ it }

                    def evenSum  = 0
                    def oddSum = 0
                    def checkDigit = 0

                    for (def i = 0; i < stringList.size(); i++) {

                        if ((i+1) % 2 != 0)
                        {
                            oddSum  += stringList[i].toInteger()
                        }

                        if ((i+1) % 2 == 0)
                        {
                            evenSum += stringList[i].toInteger()
                        }

                    }

                    def multipleByThree = evenSum*3
                    def totalSum = multipleByThree + oddSum
                    def reminder = totalSum % 10
                    def lastDigit = 10 - reminder

                    if(reminder == 0){
                        checkDigit = 0
                    }
                    else{
                        checkDigit = lastDigit
                    }

                    shipmentReportInfo.bolNumber = prefixAndSerial+checkDigit


                    respond shipmentReportInfo.save(flush: true, failOnError: true)

                }
                else{
                    respond getShipmentReportInfo
                }

            }

        }

        else{
            respond true
        }

    }

    def updateShipmentWithEasyPostData = {
        shippingService.updateShipmentWithEasyPostData(session.user.companyId, params.shipmentId, params.easyPostLabel,
                params.easyPostShipmentId, params.easyPostManifested, params.trackingCode)
    }
    
}
