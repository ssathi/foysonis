package com.foysonis.orders

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql
import com.foysonis.inventory.InventorySummary

@Secured(['ROLE_USER','ROLE_ADMIN'])
class OrderController extends RestfulController<Orders> {

	def orderService
	def listValueService
	def sessionFactory
    def customerService
    def springSecurityService
    def billingService

    static responseFormats = ['json', 'xml']
 
    OrderController() {
        super(Orders)
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
        def pageTitle = "Orders & Shipments";
        [pageTitle:pageTitle]
    }

    def getAllcustomerIdByCompany = {
		respond customerService.getAllcustomerIdByCompany(session.user.companyId, params.keyPress)
    }

    def getAllcustomerIdByCompanyForNewOrder = {
        def customer = customerService.getAllcustomerIdByCompany(session.user.companyId, params.keyPress)
        customer.add([contactName:'+ New Customer'])
        respond customer
    }    

    def getAllOrders = {
    	respond orderService.getAllOrders(session.user.companyId)
    }

    def getAllValuesByCompanyIdAndGroup = {
        respond listValueService.getAllValuesByCompanyIdAndGroup(session.user.companyId, params['group'])
    }    

    def getAllOrderLinesByOrders = {
        respond orderService.getAllOrderLinesByOrders(session.user.companyId, params['orderNum'])
    }

    def getItems = {
        def keyword = '%'+params.keyword+'%'

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows("SELECT item_id as contactName, item_description as shippingStreetAddress FROM item WHERE company_id = '${session.user.companyId}' AND (item_id LIKE '${keyword}' OR upc_code LIKE '${keyword}' OR item_description LIKE '${keyword}') LIMIT 10 ")
        respond rows

//        def sql = new Sql(sessionFactory.currentSession.connection())
//        def rows = sql.rows("SELECT item_id as contactName FROM item WHERE company_id = '${session.user.companyId}'")
//        respond rows
    }    

    def getSelectedOrderData = {
    	respond orderService.getSelectedOrderData(session.user.companyId,params['orderNum'])
    }
  
    def getCustomerByOrder(){

        def sqlQuery = "SELECT * FROM orders as ords INNER JOIN customer as cus on ords.customer_id = cus.customer_id INNER JOIN customer_address as ca on ca.customer_id = cus.customer_id AND ca.address_type = 'shipping' AND ca.company_id = '${session.user.companyId}' AND ca.is_default = true WHERE ords.order_number = '${params.orderNum}' AND ords.company_id = '${session.user.companyId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        respond rows    	
    }


    def searchOrder =  {
        def orderSearchData = [:]
        orderSearchData.orderNumber = params.orderNumber
        orderSearchData.customerName = params.customerName
        orderSearchData.fromEarlyShipDate = params.fromEarlyShipDate
        orderSearchData.toEarlyShipDate = params.toEarlyShipDate
        orderSearchData.fromLateShipDate = params.fromLateShipDate
        orderSearchData.toLateShipDate = params.toLateShipDate
        orderSearchData.orderStatus = params.orderStatus
        orderSearchData.requestedShipSpeed = params.requestedShipSpeed
        orderSearchData.shipmentId = params.shipmentId
        orderSearchData.shipmentStatus = params.shipmentStatus
        orderSearchData.currentPageNum = params.currentPageNum
        orderSearchData.orderSearchForCount = false

        respond orderService.searchOrder(session.user.companyId, orderSearchData)

    }

    def searchOrderForCount =  {
        def orderSearchData = [:]
        orderSearchData.orderNumber = params.orderNumber
        orderSearchData.customerName = params.customerName
        orderSearchData.fromEarlyShipDate = params.fromEarlyShipDate
        orderSearchData.toEarlyShipDate = params.toEarlyShipDate
        orderSearchData.fromLateShipDate = params.fromLateShipDate
        orderSearchData.toLateShipDate = params.toLateShipDate
        orderSearchData.orderStatus = params.orderStatus
        orderSearchData.requestedShipSpeed = params.requestedShipSpeed
        orderSearchData.shipmentId = params.shipmentId
        orderSearchData.shipmentStatus = params.shipmentStatus
        orderSearchData.orderSearchForCount = true

        respond orderService.searchOrder(session.user.companyId, orderSearchData)

    }

    def findListValueDescription = {
    	respond orderService.findListValueDiscription(session.user.companyId, params['optionValue'], 'RSHSP')
    }

    def saveOrder = {
        def jsonObject = request.JSON
        respond orderService.saveOrder(jsonObject, session.user.companyId)
    }    

    def updateOrder = {
        def jsonObject = request.JSON
        respond orderService.updateOrder(jsonObject, session.user.companyId)
    }    

    def  saveOrderLine = {
    	def orderLineStatus = "UNPLANNED"
    	def displayOrderLineNumber = params['displayOrderLineNumber']
    	if (displayOrderLineNumber == ''|| displayOrderLineNumber==null) {
    		displayOrderLineNumber = null
    	}
    	else{
    		displayOrderLineNumber = params['displayOrderLineNumber']
    	}

        respond orderService.saveOrderLine(session.user.companyId, params['orderNumber'], displayOrderLineNumber, params['itemId'], params['orderedQuantity'].toInteger(), params['orderedUOM'], params['requestedInventoryStatus'], orderLineStatus, params['isCreateKittingOrder'], params['allocateByLpn'])
    }

    def  updateOrderLine = {
    	def orderLineStatus = "UNPLANNED"
    	def displayOrderLineNumber = params['displayOrderLineNumber']
    	if (displayOrderLineNumber == ''|| displayOrderLineNumber==null) {
    		displayOrderLineNumber = null
    	}
    	else{
    		displayOrderLineNumber = params['displayOrderLineNumber']
    	}

        respond orderService.updateOrderLine(session.user.companyId, params['orderNumber'], params['orderLineNumber'], displayOrderLineNumber, params['itemId'], params['orderedQuantity'].toInteger(), params['orderedUOM'], params['requestedInventoryStatus'], orderLineStatus, params['isCreateKittingOrder'], params['allocateByLpn'])
    }

    def deleteOrderLine = {
    	def jsonObject = request.JSON
    	respond orderService.deleteOrderLine(session.user.companyId, jsonObject)
    }

    def checkPlannedOrderLines = {
        respond orderService.checkPlannedOrderLines(session.user.companyId, params.orderNumber)
    } 

    def deleteOrder = {
        def jsonObject = request.JSON
        respond orderService.deleteOrder(session.user.companyId, jsonObject)
    }

    def getInventorySummaryForQty = {
        respond InventorySummary.findAllByCompanyIdAndItemIdAndInventoryStatus(session.user.companyId, params['itemId'], params['status'])
    }

    def getTotalOrderedQty = {
        def companyId = session.user.companyId
        def itemId = params.itemId
        def requestedInventoryStatus = params.status
        respond orderService.getTotalOrderedQty(companyId, itemId, requestedInventoryStatus)
    }

    def getLocations = {
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows("SELECT location_id as contactName FROM location WHERE company_id = '${session.user.companyId}'")
        respond rows
    }

    def getOrderStatusCount = {
        respond orderService.getOrderStatusCount(session.user.companyId)
    }
    def getEbayOrders = {
        respond orderService.getEbayOrders(session.user.companyId)
    }


}  
