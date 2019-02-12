package com.foysonis.jasperReport

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import com.foysonis.orders.Shipment
import groovy.sql.Sql

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class JasperReportController extends RestfulController<Shipment> {

	def sessionFactory

	static responseFormats = ['json', 'xml']

    JasperReportController() {
        super(Shipment)
    }	


    def getShipmentsByTruckforReport = {
        respond Shipment.findAllByCompanyIdAndTruckNumber(session.user.companyId, params.truckNumber)  
    }

    def getOrderInfoDataforReport = {
        
        def sqlQuery = "SELECT  odr.order_number, jco.additional_shipper_info, jco.pallet_slip, jco.pkgs, jco.weight FROM shipment AS sh INNER JOIN shipment_line as sl on sh.shipment_id = sl.shipment_id AND sh.company_id = '${session.user.companyId}' INNER JOIN orders as odr on sl.order_number = odr.order_number AND sl.company_id = '${session.user.companyId}' INNER JOIN customer as cus on cus.customer_id = odr.customer_id AND odr.company_id = '${session.user.companyId}' INNER JOIN company as com on com.company_id = sh.company_id LEFT JOIN jasper_customer_order as jco on jco.order_number = odr.order_number AND jco.company_id = '${session.user.companyId}' WHERE sh.shipment_id = '${params.shipmentId}' AND sh.company_id = '${session.user.companyId}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        respond rows

    }    

    def getCarrierInfoDataforReport = {

    	def shipment = Shipment.findAllByCompanyIdAndTruckNumber(session.user.companyId, params.truckNumber)

        def sqlQuery = "SELECT * FROM jasper_carrier_information as jci WHERE jci.company_id = '${session.user.companyId}' AND jci.shipment_id = '${params.shipmentId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        respond rows

    } 

    def getReportHeaderInfoByShipment = {
       respond ShipmentReportInfo.findByCompanyIdAndShipmentId(session.user.companyId, params.shipmentId)
    }

    def saveJasperInfoData = {
    	def jsonObject = request.JSON

        def shipmentReportInfo = ShipmentReportInfo.findByCompanyIdAndShipmentId(session.user.companyId, jsonObject.shipmentId)
        if (shipmentReportInfo) {
            shipmentReportInfo.scac = jsonObject.reportInfoByShipment.scac
            shipmentReportInfo.sealNumber = jsonObject.reportInfoByShipment.sealNumber
            shipmentReportInfo.driver = jsonObject.reportInfoByShipment.driver
            shipmentReportInfo.driverLic = jsonObject.reportInfoByShipment.driverLic
            shipmentReportInfo.tempLow = jsonObject.reportInfoByShipment.tempLow
            shipmentReportInfo.tempHigh = jsonObject.reportInfoByShipment.tempHigh
            shipmentReportInfo.loadedAt = jsonObject.reportInfoByShipment.loadedAt
            if (jsonObject.reportInfoByShipment.chargeTerms == 'prepaid') {
               shipmentReportInfo.prepaid = true
            }
            else{
                shipmentReportInfo.prepaid = false
            }
            if (jsonObject.reportInfoByShipment.chargeTerms == 'collect') {
               shipmentReportInfo.collect = true 
            }
            else{
                shipmentReportInfo.collect = false
            }
            if (jsonObject.reportInfoByShipment.chargeTerms == 'thirdParty') {
               shipmentReportInfo.thirdParty = true
            }
            else{
               shipmentReportInfo.thirdParty = false                
            }
            shipmentReportInfo.save(flush:true, failOnError:true)
             
        }

    	for(customerOrderInfo in jsonObject.customerOrderInfo) {
    		def jasperCustomerOrder = JasperCustomerOrder.findByCompanyIdAndOrderNumber(session.user.companyId, customerOrderInfo.orderNumber)

    		if (jasperCustomerOrder) {
    			jasperCustomerOrder.pkgs = customerOrderInfo.pkgs
    			jasperCustomerOrder.weight = customerOrderInfo.weight
    			if (!customerOrderInfo.palletSlip) {
    				jasperCustomerOrder.palletSlip = false
    			}
    			else{
    				jasperCustomerOrder.palletSlip = customerOrderInfo.palletSlip
    			} 
    			jasperCustomerOrder.additionalShipperInfo = customerOrderInfo.additionalShipperInfo

    			jasperCustomerOrder.save(flush:true, faillOnError:true)
    			respond jasperCustomerOrder
    		}
    		else{
    			jasperCustomerOrder = new JasperCustomerOrder()
    			jasperCustomerOrder.companyId = session.user.companyId
    			jasperCustomerOrder.orderNumber = customerOrderInfo.orderNumber
    			jasperCustomerOrder.pkgs = customerOrderInfo.pkgs
    			jasperCustomerOrder.weight = customerOrderInfo.weight
    			if (!customerOrderInfo.palletSlip) {
    				jasperCustomerOrder.palletSlip = false
    			}
    			else{
    				jasperCustomerOrder.palletSlip = customerOrderInfo.palletSlip
    			}    			
    			jasperCustomerOrder.additionalShipperInfo = customerOrderInfo.additionalShipperInfo

    			jasperCustomerOrder.save(flush:true, failOnError:true)
    			respond true
    		}
    	}  

    	def getAllJasperCarrierInfoByShipment = JasperCarrierInformation.findAllByCompanyIdAndShipmentId(session.user.companyId, jsonObject.shipmentId)

    	for(jasperCarrierInfo in getAllJasperCarrierInfoByShipment){
    		jasperCarrierInfo.delete(flush:true, failOnError:true)
    	}

    	for(carrierInfo in jsonObject.carrierInfo) {
    			def jasperCarrierInformation = new JasperCarrierInformation()
    			jasperCarrierInformation.companyId = session.user.companyId
    			jasperCarrierInformation.shipmentId = jsonObject.shipmentId


		        def carrierIdExist = JasperCarrierInformation.find("from JasperCarrierInformation as jci where jci.companyId='${session.user.companyId}' order by carrierId DESC")

		        if (!carrierIdExist) {
		            jasperCarrierInformation.carrierId = session.user.companyId + "000001"
		        }
		        else{
		            def carrierIdInteger = carrierIdExist.carrierId - session.user.companyId
		            def intIndex = carrierIdInteger.toInteger()
		            intIndex = intIndex + 1
		            def stringIndex = intIndex.toString().padLeft(6,"0")
		            jasperCarrierInformation.carrierId = session.user.companyId + stringIndex
		        }


    			jasperCarrierInformation.handlingUnitQty = carrierInfo.handlingUnitQty
    			jasperCarrierInformation.handlingUnitType = carrierInfo.handlingUnitType
    			jasperCarrierInformation.packageQty = carrierInfo.packageQty
    			jasperCarrierInformation.packageType = carrierInfo.packageType
    			jasperCarrierInformation.weight = carrierInfo.weight
    			jasperCarrierInformation.hm = carrierInfo.hm
    			jasperCarrierInformation.commodityDescription = carrierInfo.commodityDescription
    			jasperCarrierInformation.ltlNmfc = carrierInfo.ltlNmfc
    			jasperCarrierInformation.ltlClass = carrierInfo.ltlClass
    			jasperCarrierInformation.save(flush:true, failOnError:true)
    	} 


    }    


    def getBillOfLadingReport(params){

    	def shipment = Shipment.findAllByCompanyIdAndTruckNumber(session.user.companyId, params.truckNumber)

        def sqlQuery = "SELECT * FROM shipment AS sh INNER JOIN shipment_line as sl on sh.shipment_id = sl.shipment_id AND sh.company_id = '${session.user.companyId}' INNER JOIN orders as odr on sl.order_number = odr.order_number AND sl.company_id = '${session.user.companyId}' INNER JOIN customer as cus on cus.customer_id = odr.customer_id AND odr.company_id = '${session.user.companyId}' INNER JOIN company as com on com.company_id = sh.company_id LEFT JOIN jasper_customer_order as jco on jco.order_number = odr.order_number AND jco.company_id = '${session.user.companyId}' WHERE sh.shipment_id = '${shipment[0].shipmentId}' AND sh.company_id = '${session.user.companyId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows

    }
}
