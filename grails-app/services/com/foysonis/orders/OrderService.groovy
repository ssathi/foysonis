package com.foysonis.orders

import com.foysonis.item.HandlingUom
import grails.transaction.Transactional
import org.apache.commons.lang.RandomStringUtils
import com.foysonis.item.ListValue
import com.foysonis.item.Item
import com.foysonis.picking.AllocationAttribute
import com.foysonis.picking.AllocationRule
import groovy.sql.Sql



import com.ebay.sdk.ApiAccount;
import com.ebay.sdk.ApiContext;
import com.ebay.sdk.ApiCredential;
import com.ebay.sdk.ApiException;
import com.ebay.sdk.SdkException;
import com.ebay.sdk.call.GetOrdersCall;
import com.ebay.soap.eBLBaseComponents.AddressType;
import com.ebay.soap.eBLBaseComponents.BuyerPaymentMethodCodeType;
import com.ebay.soap.eBLBaseComponents.CheckoutStatusType;
import com.ebay.soap.eBLBaseComponents.CompleteStatusCodeType;
import com.ebay.soap.eBLBaseComponents.DetailLevelCodeType;
import com.ebay.soap.eBLBaseComponents.ExternalTransactionType;
import com.ebay.soap.eBLBaseComponents.ItemType;
import com.ebay.soap.eBLBaseComponents.OrderStatusCodeType;
import com.ebay.soap.eBLBaseComponents.OrderType;
import com.ebay.soap.eBLBaseComponents.SiteCodeType;
import com.ebay.soap.eBLBaseComponents.TransactionArrayType;
import com.ebay.soap.eBLBaseComponents.TransactionType;
import com.ebay.soap.eBLBaseComponents.UserType;
import com.ebay.soap.eBLBaseComponents.VariationType;


@Transactional
class OrderService {

	def sessionFactory
	def allocationService

    def getAllOrders(companyId){
    	return Orders.findAllByCompanyId(companyId)
    }

    def getAllOrderLinesByOrders(companyId, orderNumber){
        //return OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderNumber,[sort: "displayOrderLineNumber", order: "asc"])

		def sqlQuery = "SELECT ol.order_number as orderNumber, ol.order_line_number as orderLineNumber, ol.display_order_line_number as displayOrderLineNumber, ol.item_id as itemId, ol.order_line_status as orderLineStatus, ol.ordered_quantity as orderedQuantity, ol.ordereduom as orderedUOM, lv.description as requestedInventoryStatus, ol.requested_inventory_status as inventoryStatusOptionValue, ol.is_create_kitting_order AS isCreateKittingOrder, allr.attribute_value as allocationAttrValue  FROM order_line as ol LEFT JOIN list_value as lv ON ol.requested_inventory_status = lv.option_value AND lv.option_group = 'INVSTATUS' AND lv.company_id = '${companyId}' LEFT JOIN allocation_rule as allr ON allr.order_line_number = ol.order_line_number AND allr.company_id = '${companyId}' WHERE ol.company_id = '${companyId}' AND ol.order_number = '${orderNumber}' GROUP BY ol.order_line_number ORDER BY ol.display_order_line_number;"
		def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }    

    def getSelectedOrderData(companyId, orderNumber){
    	return Orders.findAllByCompanyIdAndOrderNumber(companyId, orderNumber)
    }

    def findListValueDiscription(companyId, optionValue, optionGroup){
    	return ListValue.findAllByCompanyIdAndOptionGroupAndOptionValue(companyId,optionGroup,optionValue)
    }

    def planOrderLine(companyId, orderNumber, orderLineNumber){
    	def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, orderNumber, orderLineNumber)
    	if (orderLine) {
    		orderLine.orderLineStatus = 'PLANNED'
    		orderLine.save(flush:true, failOnError:true)
    	}

		//Change Order Status
		def orderLines = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderNumber)
		def allPlanned = true
		for(ol in orderLines){
			if(ol.orderLineStatus != 'PLANNED'){
				allPlanned = false
				break;
			}
		}
		if(allPlanned){
			def order = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
			order.orderStatus = OrderStatus.PLANNED
			order.save(flush:true, failOnError:true)
		}
    	
    }

    def saveOrder(orderData, companyId) {

    	def order = Orders.findByCompanyIdAndOrderNumber(companyId,orderData.orderNumber)

    	//def customer = Customer.findByCompanyIdAndContactName(companyId,orderData.customerId)
    	if(order){ 

    		order.properties = [customerId: orderData.customerId ]
    		order.notes = orderData.orderNote.take(3000)

	       	if (orderData.earlyShipDate == null || orderData.earlyShipDate == '') {
	        	order.earlyShipDate = null
	        }
	        else{
	        	def convertedEarlyShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", orderData.earlyShipDate)
	        	order.earlyShipDate = convertedEarlyShipDate
	        }

	        if (orderData.lateShipDate == null ||orderData.lateShipDate == '') {
	        	order.lateShipDate = null
	        }  
	        else{
	        	def convertedLateShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", orderData.lateShipDate)
	        	order.lateShipDate = convertedLateShipDate
	        }      
	        
	        order.orderStatus = OrderStatus.UNPLANNED

    	}

    	else{


	        order = new Orders()
	      
	        order.properties = [companyId:companyId,
	                            customerId: orderData.customerId,
								createdDate: new Date()]

	        order.notes = orderData.orderNote.take(255)

   			order.requestedShipSpeed = orderData.requestedShipSpeed
	        
	        if (orderData.orderNumber == '') {
	        	int randomStringLength = 10
				String charset = (('0'..'9')).join()
				String randomString = RandomStringUtils.random(randomStringLength, charset.toCharArray())

				order.orderNumber = randomString
	        }

	        else {
	        	order.orderNumber = orderData.orderNumber
	        }

	       	if (orderData.earlyShipDate == null || orderData.earlyShipDate == '') {
	        	order.earlyShipDate = null
	        }
	        else{
	        	def convertedEarlyShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", orderData.earlyShipDate)
	        	order.earlyShipDate = convertedEarlyShipDate
	        }

	        if (orderData.lateShipDate == null ||orderData.lateShipDate == '') {
	        	order.lateShipDate = null
	        }  
	        else{
	        	def convertedLateShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", orderData.lateShipDate)
	        	order.lateShipDate = convertedLateShipDate
	        }      
	        
	        order.orderStatus = OrderStatus.UNPLANNED

    	}

    	def getAllOrderLines = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderData.orderNumber)
    	if (getAllOrderLines.size() > 0) {
    		for(orderLines in getAllOrderLines) {
    			def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLines.orderLineNumber)
				if (allocationRuleData) {
					allocationRuleData.delete(flush: true, failOnError: true)
				}
    			orderLines.delete(flush:true, failOnError:true)
    		}
    		
    	}

        for(orderLineData in orderData.orderLine) {

        	def orderLine = new OrderLine()

	        def orderLineNumberExist = OrderLine.find("from OrderLine as ol where ol.companyId='${companyId}' order by orderLineNumber DESC")

	        if (!orderLineNumberExist) {
	            orderLine.orderLineNumber = companyId + "000001"
	        }
	        else{
	            def orderLineNumberInteger = orderLineNumberExist.orderLineNumber - companyId
	            def intIndex = orderLineNumberInteger.toInteger()
	            intIndex = intIndex + 1
	            def stringIndex = intIndex.toString().padLeft(6,"0")
	            orderLine.orderLineNumber = companyId + stringIndex
	        }

	        orderLine.companyId = companyId
	        orderLine.orderNumber = orderData.orderNumber
	        orderLine.displayOrderLineNumber = orderLineData.displayOrderLineNumber
	        orderLine.itemId = orderLineData.itemId
	        orderLine.orderedQuantity = orderLineData.orderedQuantity.toInteger()
	        orderLine.orderedUOM = orderLineData.orderedUOM
			orderLine.requestedInventoryStatus = orderLineData.requestedInventoryStatus
			orderLine.isCreateKittingOrder = orderLineData.isCreateKittingOrder
	        orderLine.orderLineStatus = "UNPLANNED"
			orderLine.kittingOrderQuantity = 0
			if (orderLineData.allocateByLpn) {
				allocationService.createAllocationRule(companyId, orderLine.orderLineNumber, AllocationAttribute.LPN, orderLineData.allocateByLpn)
			}

	        orderLine.save(flush: true, failOnError: true)        	
        }

        order.save(flush: true, failOnError: true)


    }


    def saveOrderLine(companyId, orderNumber, displayOrderLineNumber, itemId, orderedQuantity, orderedUOM, requestedInventoryStatus, orderLineStatus, isCreateKittingOrder, allocateByLpn){

    	def getOrder = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)

    	if (getOrder.orderStatus != OrderStatus.CLOSED) {
		    def orderLine = new OrderLine()

		    def orderLineNumberExist = OrderLine.find("from OrderLine as ol where ol.companyId='${companyId}' order by orderLineNumber DESC")

		    if (!orderLineNumberExist) {
		        orderLine.orderLineNumber = companyId + "000001"
		    }
		    else{
		        def orderLineNumberInteger = orderLineNumberExist.orderLineNumber.toUpperCase() - companyId.toUpperCase()
		        def intIndex = orderLineNumberInteger.toInteger()
		        intIndex = intIndex + 1
		        def stringIndex = intIndex.toString().padLeft(6,"0")
		        orderLine.orderLineNumber = companyId + stringIndex
		    }

		    orderLine.companyId = companyId
		    orderLine.orderNumber = orderNumber
		    orderLine.displayOrderLineNumber = displayOrderLineNumber
		    orderLine.itemId = itemId
		    orderLine.orderedQuantity = orderedQuantity
		    orderLine.orderedUOM = orderedUOM
		    orderLine.requestedInventoryStatus = requestedInventoryStatus
		    orderLine.orderLineStatus = orderLineStatus
			orderLine.isCreateKittingOrder = isCreateKittingOrder.toBoolean()
			orderLine.kittingOrderQuantity = 0
			if (allocateByLpn) {
				allocationService.createAllocationRule(companyId, orderLine.orderLineNumber, AllocationAttribute.LPN, allocateByLpn)
			}
		    orderLine.save(flush: true, failOnError: true)

			if(orderLineStatus == "UNPLANNED"){
			   def order = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
			   def getTotalNumberOfPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, orderNumber, 'PLANNED')

			   if(getTotalNumberOfPlannedOrdersLines.size()>0){
			      order.orderStatus = OrderStatus.PARTIALLY_PLANNED
			      order.save(flush: true, failOnError: true)
			   }
			   return orderLine
			}    		
    	}



    }

    def updateOrderLine(companyId, orderNumber, orderLineNum, displayOrderLineNumber, itemId, orderedQuantity, orderedUOM, requestedInventoryStatus, orderLineStatus, isCreateKittingOrder, allocateByLpnEdit){

        def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, orderNumber, orderLineNum)
        if (orderLine) {
        	
        	orderLine.displayOrderLineNumber = displayOrderLineNumber
        	orderLine.itemId = itemId
        	orderLine.orderedQuantity = orderedQuantity
        	orderLine.orderedUOM = orderedUOM
        	orderLine.requestedInventoryStatus = requestedInventoryStatus
			orderLine.orderLineStatus = orderLineStatus
			orderLine.isCreateKittingOrder = isCreateKittingOrder.toBoolean()

			if (allocateByLpnEdit) {
				def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLineNum)		
				if (allocationRuleData) {
					allocationRuleData.attributeValue = allocateByLpnEdit
					allocationRuleData.save(flush: true, failOnError: true)
				}
				else{
					allocationService.createAllocationRule(companyId, orderLineNum, AllocationAttribute.LPN, allocateByLpnEdit)
				}
			}
			else {
				def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLineNum)
				if (allocationRuleData) {
					allocationRuleData.delete(flush: true, failOnError: true)
				}
			}

        	orderLine.save(flush: true, failOnError: true)
        }

        else{

        	orderLine = new OrderLine()
	        def orderLineNumberExist = OrderLine.find("from OrderLine as ol where ol.companyId='${companyId}' order by orderLineNumber DESC")

	        if (!orderLineNumberExist) {
	            orderLine.orderLineNumber = companyId + "000001"
	        }
	        else{
	            def orderLineNumberInteger = orderLineNumberExist.orderLineNumber - companyId
	            def intIndex = orderLineNumberInteger.toInteger()
	            intIndex = intIndex + 1
	            def stringIndex = intIndex.toString().padLeft(6,"0")
	            orderLine.orderLineNumber = companyId + stringIndex
	        }

	        orderLine.companyId = companyId
	        orderLine.orderNumber = orderNumber
	        orderLine.displayOrderLineNumber = displayOrderLineNumber
	        orderLine.itemId = itemId
	        orderLine.orderedQuantity = orderedQuantity
	        orderLine.orderedUOM = orderedUOM
	        orderLine.requestedInventoryStatus = requestedInventoryStatus
	        orderLine.orderLineStatus = orderLineStatus
			orderLine.isCreateKittingOrder = isCreateKittingOrder
			orderLine.kittingOrderQuantity = 0

			if (allocateByLpnEdit) {
				allocationService.createAllocationRule(companyId, orderLineNum, AllocationAttribute.LPN, allocateByLpnEdit)
			}

			orderLine.save(flush: true, failOnError: true)
        }

    }   

    def updateOrder(updateOrderData, companyId){

    	def order = Orders.findByCompanyIdAndOrderNumber(companyId,updateOrderData.orderNumber)
//		def listValueForOrder = ListValue.find("from ListValue as l where (l.companyId = 'ALL' or l.companyId = ?) and l.optionGroup = ? and l.description  = ? order by l.displayOrder", [companyId, 'RSHSP', updateOrderData.requestedShipSpeed])

    	if(order){

	        order.properties = [customerId: updateOrderData.customerId ]
   			order.requestedShipSpeed = updateOrderData.requestedShipSpeed
   			order.notes = updateOrderData.orderNote.take(255)

	       	if (updateOrderData.earlyShipDate == null || updateOrderData.earlyShipDate == '') {
	        	order.earlyShipDate = null
	        }
	        else{
	        	def convertedEarlyShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", updateOrderData.earlyShipDate)
	        	order.earlyShipDate = convertedEarlyShipDate
	        }

	        if (updateOrderData.lateShipDate == null ||updateOrderData.lateShipDate == '') {
	        	order.lateShipDate = null
	        }  
	        else{
	        	def convertedLateShipDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", updateOrderData.lateShipDate)
	        	order.lateShipDate = convertedLateShipDate
	        } 

    	    order.save(flush: true, failOnError: true)
    	}
    }

    def deleteOrderLine(companyId, orderLineData){
    	def orderLine = OrderLine.findByCompanyIdAndOrderNumberAndOrderLineNumber(companyId, orderLineData.orderNumber,orderLineData.orderLineNumber)
    	if (orderLine) {
    		def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLine.orderLineNumber)
				if (allocationRuleData) {
					allocationRuleData.delete(flush: true, failOnError: true)
				}
    		orderLine.delete(flush:true, failOnError:true)
    		checkAndModifyOrderStatus(companyId, orderLineData.orderNumber)
    	}

    }

    def checkAndModifyOrderStatus(companyId, orderNumber){
		Orders order = Orders.findByCompanyIdAndOrderNumber(companyId, orderNumber)
		def getTotalNumberOfPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, orderNumber, 'PLANNED')
		def getTotalNumberOfUnPlannedOrdersLines = OrderLine.findAllByCompanyIdAndOrderNumberAndOrderLineStatus(companyId, orderNumber, 'UNPLANNED')

		if(getTotalNumberOfPlannedOrdersLines.size() > 0){
			if(getTotalNumberOfUnPlannedOrdersLines.size() > 0){
				order.orderStatus = OrderStatus.PARTIALLY_PLANNED
			}
			else{
				order.orderStatus = OrderStatus.PLANNED
			}
		}
		else{
			order.orderStatus = OrderStatus.UNPLANNED
		}
		order.save(flush:true, failOnError:true)
    }


	def updateWaveOrder(String companyId, String waveOrderNumber, String waveNumber){
		Orders waveOrder = Orders.findByCompanyIdAndOrderNumber(companyId, waveOrderNumber)
		waveOrder.waveNumber = waveNumber
		waveOrder.orderStatus = OrderStatus.PLANNED
		waveOrder.save(flush:true, failOnError:true)
	}


    def checkPlannedOrderLines(companyId, orderNumber){
		return OrderLine.findAll("from OrderLine as ol where ol.companyId='${companyId}' AND ol.orderNumber='${orderNumber}' AND orderLineStatus !='UNPLANNED'")     	
    }

    def deleteOrder(companyId, orderData){
    	def orders = Orders.findByCompanyIdAndOrderNumber(companyId, orderData.orderNumber)
    	if (orders) {

	    	def getAllOrderLines = OrderLine.findAllByCompanyIdAndOrderNumber(companyId, orderData.orderNumber)
	    	if (getAllOrderLines.size() > 0) {
	    		for(orderLines in getAllOrderLines) {
	    			def allocationRuleData = AllocationRule.findByCompanyIdAndOrderLineNumber(companyId, orderLines.orderLineNumber)
					if (allocationRuleData) {
						allocationRuleData.delete(flush: true, failOnError: true)
					}
	    			orderLines.delete(flush:true, failOnError:true)
	    		}
	    		
	    	}    		
    		orders.delete(flush:true, failOnError:true)
    		return orderData
    	}
    }


    def searchOrder(companyId, searchData)
    {        

    	def sqlQuery = null
    	if (searchData.orderSearchForCount == true ) {
	        sqlQuery = "SELECT COUNT(Distinct  o.order_number) as total_orders, o.*, cus.contact_name from orders as o INNER JOIN customer As cus on o.customer_id = cus.customer_id AND o.company_id = cus.company_id LEFT JOIN shipment_line AS sl ON sl.order_number = o.order_number AND sl.company_id = '${companyId}' LEFT JOIN shipment AS sh ON sh.shipment_id = sl.shipment_id AND sh.company_id = ${companyId} WHERE o.company_id = '${companyId}' AND o.is_submitted = true	 "
    	}
    	else{
	        sqlQuery = "SELECT o.*, cus.contact_name from orders as o INNER JOIN customer As cus on o.customer_id = cus.customer_id AND o.company_id = cus.company_id LEFT JOIN shipment_line AS sl ON sl.order_number = o.order_number AND sl.company_id = '${companyId}' LEFT JOIN shipment AS sh ON sh.shipment_id = sl.shipment_id AND sh.company_id = ${companyId} WHERE o.company_id = '${companyId}' AND o.is_submitted = true "
    	}



        if(searchData.orderNumber){
            def findOrderNumber = '%'+searchData.orderNumber+'%'
            sqlQuery = sqlQuery + " AND o.order_number LIKE '${findOrderNumber}'"
        }

        if(searchData.customerName){
            sqlQuery = sqlQuery + " AND cus.contact_name = '${searchData.customerName}'"
        }


        if(searchData.fromEarlyShipDate){
            sqlQuery = sqlQuery + " AND o.early_ship_date >= '${searchData.fromEarlyShipDate}'"
        }


        if(searchData.toEarlyShipDate){
            sqlQuery = sqlQuery + " AND o.early_ship_date <= '${searchData.toEarlyShipDate}'"
        }

        if(searchData.fromLateShipDate){
            sqlQuery = sqlQuery + " AND o.late_ship_date >= '${searchData.fromLateShipDate}'"
        }


        if(searchData.toLateShipDate){
            sqlQuery = sqlQuery + " AND o.late_ship_date <= '${searchData.toLateShipDate}'"
        }

        if(searchData.orderStatus){
            sqlQuery = sqlQuery + " AND o.order_status = '${searchData.orderStatus}'"
        }

        if(searchData.requestedShipSpeed){
            sqlQuery = sqlQuery + " AND o.requested_ship_speed = '${searchData.requestedShipSpeed}'"
        }

        if(searchData.shipmentId){
        	def findShipment = '%'+searchData.shipmentId+'%'
            sqlQuery = sqlQuery + " AND sl.shipment_id LIKE '${findShipment}'"
        } 

        if(searchData.shipmentStatus){
            sqlQuery = sqlQuery + " AND sh.shipment_status = '${searchData.shipmentStatus}'"
        }               

        if (searchData.orderSearchForCount == true ) {
        	sqlQuery = sqlQuery + " ORDER BY o.created_date DESC "
        }

        else{
	        sqlQuery = sqlQuery + " GROUP BY o.order_number ORDER BY o.created_date DESC "

	        if (searchData.currentPageNum ) {
	        	def currentPageNumber = 0
	        	if (searchData.currentPageNum.toInteger() > 0) {
	        		currentPageNumber = (searchData.currentPageNum.toInteger() - 1) * 20
	        	}
	        	else{
	        		currentPageNumber = 0
	        	}
	        	sqlQuery = sqlQuery + " LIMIT ${currentPageNumber}, 20"
	        	
	        }
	        else{
	        	sqlQuery = sqlQuery + " LIMIT 0, 20"
	        }

        }


        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)

        return rows

    }


    def getTotalOrderedQty(companyId,itemId,requestedInventoryStatus) {
    	def itemData = Item.findByCompanyIdAndItemId(companyId, itemId)
    	//itemData.lowestUom
    	//itemData.eachesPerCase
    	def totalOrderedQty = 0
        if (itemData.lowestUom == 'EACH') {
        	
        	def orderLineQtyByCase = 0
        	def orderLineQtyByEach = 0

			def sqlQuery = "select sum(ordered_quantity) AS orderedQuantity from order_line as ol INNER JOIN orders AS ord ON ord.order_number = ol.order_number AND ord.company_id = '${companyId}' AND ord.is_submitted = true where ol.company_id = '${companyId}' and ol.item_id = '${itemId}' and ol.requested_inventory_status =  '${requestedInventoryStatus}' AND ol.ordereduom = '${HandlingUom.CASE}' AND ol.order_line_status = 'UNPLANNED'"

			def sqlQuery2 = "select sum(ordered_quantity) AS orderedQuantity from order_line as ol INNER JOIN orders AS ord ON ord.order_number = ol.order_number AND ord.company_id = '${companyId}' AND ord.is_submitted = true where ol.company_id = '${companyId}' and ol.item_id = '${itemId}' and ol.requested_inventory_status =  '${requestedInventoryStatus}' AND ol.ordereduom = 'EACH' AND ol.order_line_status = 'UNPLANNED'"

			def sql = new Sql(sessionFactory.currentSession.connection())
        	def orderLineByCase = sql.rows(sqlQuery)
        	def orderLineByEach = sql.rows(sqlQuery2)
        
	        // def orderLineByCase = OrderLine.executeQuery("select sum(orderedQuantity) from OrderLine  where companyId = '${companyId}' and itemId = '${itemId}' and requestedInventoryStatus =  '${requestedInventoryStatus}' AND orderedUOM = 'CASE' AND orderLineStatus = 'UNPLANNED'")

	        // def orderLineByEach = OrderLine.executeQuery("select sum(orderedQuantity) from OrderLine where companyId = '${companyId}' and itemId = '${itemId}' and requestedInventoryStatus =  '${requestedInventoryStatus}' AND orderedUOM = 'EACH' AND orderLineStatus = 'UNPLANNED'")

	        if (orderLineByCase[0].orderedQuantity) {
	        	orderLineQtyByCase = orderLineByCase[0].orderedQuantity
	        }
	        if (orderLineByEach[0].orderedQuantity) {
	        	orderLineQtyByEach = orderLineByEach[0].orderedQuantity
	        }
	        
	        totalOrderedQty = (orderLineQtyByCase.toInteger() * itemData.eachesPerCase.toInteger()) + orderLineQtyByEach.toInteger()
        }
        else{
        	// totalOrderedQty = OrderLine.executeQuery("select sum(orderedQuantity) from OrderLine where companyId = '${companyId}' and itemId = '${itemId}' and requestedInventoryStatus =  '${requestedInventoryStatus}' and orderedUOM = 'CASE' AND orderLineStatus = 'UNPLANNED'")
			def sqlQuery = "select sum(ordered_quantity) AS orderedQuantity from order_line as ol INNER JOIN orders AS ord ON ord.order_number = ol.order_number AND ord.company_id = '${companyId}' AND ord.is_submitted = true where ol.company_id = '${companyId}' and ol.item_id = '${itemId}' and ol.requested_inventory_status =  '${requestedInventoryStatus}' AND ol.ordereduom = 'CASE' AND ol.order_line_status = 'UNPLANNED'"
			def sql = new Sql(sessionFactory.currentSession.connection())  
			totalOrderedQty = sql.rows(sqlQuery)[0].orderedQuantity    	

        }

        return [totalOrderedQty:totalOrderedQty, itemLowestUom:itemData.lowestUom, itemEachesPerCase:itemData.eachesPerCase]
    }

	def getOrderStatusCount(companyId){
		def sqlQuery = "SELECT COUNT(*) total, "
		sqlQuery += "SUM(CASE WHEN order_status = '${OrderStatus.UNPLANNED}' THEN 1 ELSE 0 END) unplanned, "
		sqlQuery += "SUM(CASE WHEN order_status = '${OrderStatus.PLANNED}' THEN 1 ELSE 0 END) planned, "
		sqlQuery += "SUM(CASE WHEN order_status = '${OrderStatus.PARTIALLY_PLANNED}' THEN 1 ELSE 0 END) partially_planned, "
		sqlQuery += "SUM(CASE WHEN order_status = '${OrderStatus.CLOSED}' THEN 1 ELSE 0 END) closed "
		sqlQuery += "FROM orders "
		sqlQuery += " WHERE company_id = '${companyId}' AND is_submitted = true "

		def sql = new Sql(sessionFactory.currentSession.connection())

		return sql.rows(sqlQuery)
	}

	def getEbayOrders(companyId){

		ApiCredential credential = new ApiCredential();
		//credential.setApiAccount( account );
		credential.seteBayToken("AgAAAA**AQAAAA**aAAAAA**Gf1hWA**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wFk4GiCpmApQudj6x9nY+seQ**tgoEAA**AAMAAA**oLrfX3iFVc+2Pc6A5yn/JJ6tnJQgAcypy+DXxIG1vBhZnNzZr9YRAXZi8wLi4/Vnaf8MbVbKgdAsGVRHXkdkdGKtCA6DVKctoYcNmmQjpFm/9P20jEtOHDuL0ytdY3GwXR7J6v3k9YWtJBSs5Kbdt5Cszc6i7A/8VHYKi1phD0F5uTlxZAJkNfE8tOOpGiQngPKturppKWZMRX3sWlqoUQO9XEP+3VTQ7HsXeiuRjorQUsKk4ayHTL2XioSB8nOpnLnRnGsmyPchxYouOrRih7p/WveOP6NwqytlIFSlFDPUE0kaGWPPQcu3YauUumaxmU6jd0TTfCTY33sBsM753n23MyKbYstUAyaQIM6WIMT5QdZ7b1E7iHwvwJ9/wPYVLF8bXPOAdu25/1PNrOX8DLsAqXbNsWRNP49OyXNTrwWZUY2ToMOMp2lf2w/3R7pvtO4CFV08YWcldvm87592oRiAlKvU+cyRkmFMxX2ag1WGNGmwavxUyJsi0EFfJO2s93KYeZlJ8PBoRlxTug/WSKEeFGqyguScCryIbLNGCkc+j6RmTL5g+npZTXd9n2KVW3JOQBnHGixnZJqRGkwIV/K/eVZnqO2PDrKpH76CtfYHvtOQNTDK+/MefX65cRdsrMZedZARxptz+zB1zaytlaRpd/VzKibyTZJ9YkD79FIE5HEHgjRp4FqgWATDvSaA/gshCyJftWp4fKb9Rbu/rHb2lyGEAUNYbzJHquZ0SjOTBO7BTIFgFemWjEz+ch/P");

		// add ApiCredential to ApiContext
		ApiContext apiContext = new ApiContext();
		apiContext.setApiCredential(credential);


		apiContext.setApiServerUrl("https://api.sandbox.ebay.com/wsapi");

		// Set the site based on the seller - for UK sellers, set it to SiteCodeType.UK
		// for US, set to SiteCodeType.US
		apiContext.setSite(SiteCodeType.US);

		// set detail level to ReturnAll
		DetailLevelCodeType[] detailLevels = DetailLevelCodeType.RETURN_ALL

		Calendar to = new GregorianCalendar(TimeZone.getTimeZone("GMT")).getInstance();
		Calendar from = (GregorianCalendar) to.clone();

		from.add(to.DAY_OF_YEAR,-25);

		GetOrdersCall getOrders = new GetOrdersCall(apiContext);
		getOrders.setDetailLevel(detailLevels);
		getOrders.setOrderStatus(OrderStatusCodeType.ALL);

		getOrders.setCreateTimeFrom(from);
		getOrders.setCreateTimeTo(to);

		OrderType[] orders = getOrders.getOrders();
		log.info("Finished " + orders.length);


		if (orders.length > 0){

			for(order in orders){

				String orderId = "eBay_" + order.getOrderID()

				log.info("order Id : " + orderId)

				Orders orderExist = Orders.findByCompanyIdAndOrderNumber(companyId, orderId)

				if(orderExist){
					log.info("Order Id : " + order.getOrderID() + " already exists.")
				}
				else{

					TransactionArrayType transactionArrayType =  order.getTransactionArray();
					TransactionType[] transactions =  transactionArrayType.getTransaction();

//					Get Customer TODO Discuss about field for customer
					Customer customer = Customer.findByCompanyIdAndContactName(companyId, order.getBuyerUserID())
					String customerId = null
					if(customer){
						customerId = customer.customerId

					}
					else {
						//TODO create customer
						customerId = "1"
					}


					Orders appOrder = new Orders()
					// TODO Discuss order create date
					appOrder.properties = [companyId:companyId,
										customerId: customerId,
										createdDate: new Date()]

					appOrder.notes = "eBay Notes"
					appOrder.orderNumber = orderId

					appOrder.orderStatus = OrderStatus.UNPLANNED

					for(orderLineData in transactions) {
						ItemType item  = orderLineData.getItem()  //TODO If Item not exist

						def orderLine = new OrderLine()

						def orderLineNumberExist = OrderLine.find("from OrderLine as ol where ol.companyId='${companyId}' order by orderLineNumber DESC")

						if (!orderLineNumberExist) {
							orderLine.orderLineNumber = companyId + "000001"
						}
						else{
							def orderLineNumberInteger = orderLineNumberExist.orderLineNumber - companyId
							def intIndex = orderLineNumberInteger.toInteger()
							intIndex = intIndex + 1
							def stringIndex = intIndex.toString().padLeft(6,"0")
							orderLine.orderLineNumber = companyId + stringIndex
						}

						orderLine.companyId = companyId
						orderLine.orderNumber = appOrder.orderNumber

						orderLine.itemId = item.getItemID()

						orderLine.orderedQuantity = orderLineData.getQuantityPurchased().toInteger()
						orderLine.orderedUOM = "EACH" //TODO
						// orderLine.requestedInventoryStatus = item.getConditionDisplayName() //TODO Status
						orderLine.requestedInventoryStatus = "GOOD"
						orderLine.orderLineStatus = "UNPLANNED"
						orderLine.kittingOrderQuantity = 0

						orderLine.save(flush: true, failOnError: true)
					}

					appOrder.save(flush: true, failOnError: true)




				}



			}
		}

		return true;


	}




}
   
