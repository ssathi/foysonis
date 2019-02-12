package com.foysonis.clientBilling

import com.foysonis.orders.ShipmentStatus
import grails.transaction.Transactional
import groovy.sql.Sql
import static java.util.Calendar.*

@Transactional
class ClientBillingService {

	def sessionFactory

    def getAllBillingItem(companyId) {
    	//return BillingItem.findAllByHeadingIdIsNull()
		def sqlQuery = "SELECT bi.*, bia.amount AS billing_amount, bia.min_rate FROM billing_item as bi LEFT JOIN billing_item_amount as bia ON bia.billing_item_id = bi.id AND bia.company_id = '${companyId}' WHERE bi.heading_id IS NULL"
		def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }  

    def getAllSubBillingItem(companyId, headingId) {
		def sqlQuery = "SELECT bi.*, bia.amount AS billing_amount, bia.min_rate FROM billing_item as bi LEFT JOIN billing_item_amount as bia ON bia.billing_item_id = bi.id AND bia.company_id = '${companyId}' WHERE bi.heading_id = ${headingId}"
		def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def saveBillingItem(companyId, jsonObject) {

    	for(billingItem in jsonObject.billingItem) {
    		if (billingItem.billing_amount) {
    			def billingItemAmountExist = BillingItemAmount.findByCompanyIdAndBillingItemId(companyId, billingItem.id)
    			if (billingItemAmountExist) {
    				if (billingItem.billing_amount) {
    					billingItemAmountExist.amount = billingItem.billing_amount.toDouble()
    				}
    				if (billingItem.min_rate) {
    					billingItemAmountExist.minRate = billingItem.min_rate.toDouble()
    				}else{
    					billingItemAmountExist.minRate = null
    				}   				
    				billingItemAmountExist.save(flush: true, failOnError: true)
    			}
    			else{
		    		def billingItemAmount = new BillingItemAmount()
		    		billingItemAmount.companyId = companyId
		    		billingItemAmount.billingItemId = billingItem.id
		    		if (billingItem.billing_amount) {
		    			billingItemAmount.amount = billingItem.billing_amount.toDouble()
		    		}
		    		if (billingItem.min_rate) {
		    			billingItemAmount.minRate = billingItem.min_rate.toDouble()
		    		}
		    		billingItemAmount.createdDate = new Date()
		    		billingItemAmount.save(flush: true, failOnError: true)
    			}    			
    		}

    	}//end for

    	for(def i = 0; i < jsonObject.subBillingItem.size(); i++){
    		if (jsonObject.subBillingItem[i].size() > 0) {
    			for(subBilling in jsonObject.subBillingItem[i]) {
    				if (subBilling.billing_amount) {
    					def billingItemAmountExist = BillingItemAmount.findByCompanyIdAndBillingItemId(companyId, subBilling.id)
    					if (billingItemAmountExist) {
    						if (subBilling.billing_amount) {
    							billingItemAmountExist.amount = subBilling.billing_amount.toDouble()
    						}
    						if (subBilling.min_rate) {
    							billingItemAmountExist.minRate = subBilling.min_rate.toDouble()
    						}else{
    							billingItemAmountExist.minRate = null
    						}    						
    						billingItemAmountExist.save(flush: true, failOnError: true)
    					}
    					else{
	    					def billingItemAmount = new BillingItemAmount()
				    		billingItemAmount.companyId = companyId
				    		billingItemAmount.billingItemId = subBilling.id
				    		if (subBilling.billing_amount) {
				    			billingItemAmount.amount = subBilling.billing_amount.toDouble()
				    		}
				    		if (subBilling.min_rate) {
				    			billingItemAmount.minRate = subBilling.min_rate.toDouble()
				    		}
				    		billingItemAmount.createdDate = new Date()
				    		billingItemAmount.save(flush: true, failOnError: true)
    					}
     					
    				}
   							
    			}
    		}
    	}//end for
    	return[code:'success']
    	
    }


    def saveBillingInvoice(companyId, jsonObject) {

    	def invoice = new Invoice()
    	invoice.companyId = companyId
    	invoice.invoiceNumber = jsonObject.invoiceData.invoiceNumber
    	invoice.invoiceDisplayNumber = jsonObject.invoiceData.invoiceNumber
    	def convertedFromDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", jsonObject.invoiceData.fromDate)
    	def convertedToDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", jsonObject.invoiceData.toDate)
    	invoice.fromDate = convertedFromDate
    	invoice.toDate = convertedToDate
    	invoice.createdDate = new Date()

    	def fromDateFormat = convertedFromDate.format( 'yyyy-MM-dd' )
    	convertedToDate.set(hourOfDay: 23, minute: 59, second: 0)
    	def toDateFormat = convertedToDate.format( 'yyyy-MM-dd HH:mm:ss' )


    	for(billingItem in jsonObject.billingItem) {
    		if (billingItem.is_item_selected && billingItem.has_sub_item != true) {
		    		def invoiceItemData = new InvoiceItem()
		    		invoiceItemData.companyId = companyId
		    		invoiceItemData.invoiceNumber = jsonObject.invoiceData.invoiceNumber
		    		invoiceItemData.billingItemName = billingItem.name
		    		if (billingItem.billing_amount) {
		    			println 'inside'
		    			def billingItemDataRow = BillingItem.findById(billingItem.id)
		    			println billingItemDataRow
		    			if (billingItemDataRow.functionName) {
		    				println 'gotit'
							def sqlQuery = "SELECT "+billingItemDataRow.functionName+"('${companyId}', '${fromDateFormat}', '${toDateFormat}') as itemCount "
							def sql = new Sql(sessionFactory.currentSession.connection())
					        def rows = sql.rows(sqlQuery)
					        println rows
					         invoiceItemData.amount = rows[0].itemCount.toDouble() * billingItem.billing_amount.toDouble()		    				
		    			}
		    			else{
		    				invoiceItemData.amount = billingItem.billing_amount.toDouble()
		    			}
		    			
		    		}
		    		else{
		    			invoiceItemData.amount = 0
		    		}
		    		invoiceItemData.createdDate = new Date()		
		    		invoiceItemData.save(flush: true, failOnError: true)   	
    		}

    	}//end for

    	for(def i = 0; i < jsonObject.subBillingItem.size(); i++){
    		if (jsonObject.subBillingItem[i].size() > 0) {
    			for(subBilling in jsonObject.subBillingItem[i]) {
    				if (subBilling.is_item_selected) {
	    					def invoiceItem = new InvoiceItem()
				    		invoiceItem.companyId = companyId
				    		invoiceItem.invoiceNumber = jsonObject.invoiceData.invoiceNumber
				    		invoiceItem.billingItemName = subBilling.name
				    		if (subBilling.billing_amount) {
				    			//invoiceItem.amount = subBilling.billing_amount.toInteger()

				    			def billingItemDataRow = BillingItem.findById(subBilling.id)
				    			if (billingItemDataRow.functionName) {
									def sqlQuery = "SELECT "+billingItemDataRow.functionName+"('${companyId}', '${fromDateFormat}', '${toDateFormat}') as itemCount "
									def sql = new Sql(sessionFactory.currentSession.connection())
							        def rows = sql.rows(sqlQuery)

									if(subBilling.billing_amount && rows[0].itemCount)
										invoiceItem.amount = rows[0].itemCount.toDouble() * subBilling.billing_amount.toDouble()
									else
										invoiceItem.amount = 0
				    			}
				    			else{
				    				invoiceItem.amount = subBilling.billing_amount.toDouble()
				    			}

				    		}
				    		else{
				    			invoiceItem.amount = 0
				    		}				    		
				    		invoiceItem.createdDate = new Date()
				    		invoiceItem.save(flush: true, failOnError: true)
     					
    				}
   							
    			}
    		}
    	}//end for

    	if (jsonObject.customBillingItem.size()>0) {
    		for(customBillingItem in jsonObject.customBillingItem) {
    			if (customBillingItem && customBillingItem.is_item_selected && customBillingItem.item_name) {
					def invoiceItem = new InvoiceItem()
		    		invoiceItem.companyId = companyId
		    		invoiceItem.invoiceNumber = jsonObject.invoiceData.invoiceNumber
		    		invoiceItem.billingItemName = customBillingItem.item_name
		    		if (customBillingItem.billing_amount) {
		    			invoiceItem.amount = customBillingItem.billing_amount * 1
		    		}
		    		else{
		    			invoiceItem.amount = 0
		    		}	
		    		invoiceItem.isCustom = true			    		
		    		invoiceItem.createdDate = new Date()
		    		invoiceItem.save(flush: true, failOnError: true)   			
    			}
    		}
    	}

    	return invoice.save(flush: true, failOnError: true)
    }

    def getCommercialInvoiceData(companyId, commercialInvoiceNumber){
    	def commercialInvoice = CommercialInvoiceItem.findByCompanyIdAndCommercialInvoiceNumber(companyId, commercialInvoiceNumber)
    	if (commercialInvoice) {
    		return [invoiceExist:true, invoiceData:commercialInvoice]
    	}
    	else {
    		return [invoiceExist: false]
    	}
    }

    def generateInvoiceNumber(companyId) {
    	def invoiceData = [:]
    	invoiceData.invoiceNumber = null
		def invoiceDataExist = Invoice.find("from Invoice as inc where inc.companyId='${companyId}' order by invoiceNumber DESC")

		if (!invoiceDataExist) {
			invoiceData.invoiceNumber = companyId + "000001"
		}
		else{
			def invoiceNumberInteger = invoiceDataExist.invoiceNumber - companyId
			def intIndex = invoiceNumberInteger.toInteger()
			intIndex = intIndex + 1
			def stringIndex = intIndex.toString().padLeft(6,"0")
			invoiceData.invoiceNumber = companyId + stringIndex
		}   

		return invoiceData	
    }
    def getAllCommercialBillingItem(companyId) {
    	//return BillingItem.findAllByHeadingIdIsNull()
		def sqlQuery = "SELECT bi.*, bia.amount AS billing_amount, bia.min_rate FROM billing_item as bi LEFT JOIN billing_item_amount as bia ON bia.billing_item_id = bi.id AND bia.company_id = '${companyId}' WHERE bi.id >=18"
		def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }  

    def saveCommercialInvoice(companyId, jsonObject) {

    	def convertedFromDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", jsonObject.invoiceData.fromDate)
    	def convertedToDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", jsonObject.invoiceData.toDate)

    	def fromDateFormat = convertedFromDate.format( 'yyyy-MM-dd' )
    	convertedToDate.set(hourOfDay: 23, minute: 59, second: 0)
    	def toDateFormat = convertedToDate.format( 'yyyy-MM-dd HH:mm:ss' )
    	println "todate==========="+toDateFormat
    	println "fromDate==========="+fromDateFormat

    	def sqlQueryForCustomers = "SELECT DISTINCT ord.customer_id from shipment AS sh INNER JOIN shipment_line AS shln ON shln.shipment_id = sh.shipment_id AND shln.company_id = '${companyId}' INNER JOIN orders as ord ON ord.order_number = shln.order_number AND ord.company_id = '${companyId}' WHERE (sh.creation_date >= '${fromDateFormat}' AND sh.creation_date <= '${toDateFormat}') AND sh.shipment_status = '${ShipmentStatus.COMPLETED}' AND sh.company_id = '${companyId}'"
		def sql = new Sql(sessionFactory.currentSession.connection())
		def rowsOfCustomerByShipments = sql.rows(sqlQueryForCustomers)


		for(customers in rowsOfCustomerByShipments) {

	    	for(billingItem in jsonObject.billingItem) {	

	    		if (billingItem.is_item_selected) {

					def commercialInvoice = new CommercialInvoiceItem()
			    	commercialInvoice.fromDate = Date.parse("yyyy-MM-dd", fromDateFormat)
			    	commercialInvoice.toDate = Date.parse("yyyy-MM-dd", toDateFormat)
			    	commercialInvoice.createdDate = new Date()
			    	commercialInvoice.companyId = companyId
		    		commercialInvoice.commercialInvoiceNumber = jsonObject.invoiceData.invoiceNumber	
		    		commercialInvoice.customerId = customers.customer_id

    				commercialInvoice.billingItemName = billingItem.name

		    		if (billingItem.billing_amount) {

		    			def billingItemDataRow = BillingItem.findById(billingItem.id)
		    			println billingItemDataRow
		    			if (billingItemDataRow.functionName) {

							def sqlQuery = "SELECT "+billingItemDataRow.functionName+"('${companyId}', '${customers.customer_id}', '${fromDateFormat}', '${toDateFormat}') as itemCount "
					        def rows = sql.rows(sqlQuery)
					        println rows
					        commercialInvoice.priceEach = billingItem.billing_amount
					        println "customer........."+customers.customer_id
					        println "check ............."+rows[0].itemCount
					        commercialInvoice.qty = rows[0].itemCount.toDouble()
					        if (billingItem.min_rate && rows[0].itemCount.toDouble() > 0) {
					        	def totalAmt = rows[0].itemCount.toDouble() * billingItem.billing_amount.toDouble()
					        	if (totalAmt < billingItem.min_rate) {
					        		commercialInvoice.totalAmount = billingItem.min_rate
					        	}
					        	else{
					        		commercialInvoice.totalAmount = rows[0].itemCount.toDouble() * billingItem.billing_amount.toDouble()	
					        	}
					        }
					        else {
					        	commercialInvoice.totalAmount = rows[0].itemCount.toDouble() * billingItem.billing_amount.toDouble()	
					        }
					        	    				
		    			}
		    			else{
		    				commercialInvoice.totalAmount = billingItem.billing_amount.toDouble()
		    			}
		    			
		    		}
		    		else{
		    			commercialInvoice.priceEach = 0
		    			commercialInvoice.totalAmount = 0
		    		}	
			    	commercialInvoice.save(flush: true, failOnError: true)			
	    		}

				   

	    	}//end for

		}

    	if (jsonObject.customBillingItem.size()>0) {
    		for(customBillingItem in jsonObject.customBillingItem) {
    			if (customBillingItem && customBillingItem.is_item_selected && customBillingItem.item_name) {
					def commercialInvoice = new CommercialInvoiceItem()
		    		commercialInvoice.companyId = companyId
		    		commercialInvoice.fromDate = Date.parse("yyyy-MM-dd", fromDateFormat)
			    	commercialInvoice.toDate = Date.parse("yyyy-MM-dd", toDateFormat)
			    	commercialInvoice.createdDate = new Date()
		    		commercialInvoice.commercialInvoiceNumber = jsonObject.invoiceData.invoiceNumber
		    		commercialInvoice.billingItemName = customBillingItem.item_name
		    		if (customBillingItem.billing_amount) {
		    			commercialInvoice.totalAmount = customBillingItem.billing_amount * 1
		    			commercialInvoice.qty = 1
		    			commercialInvoice.priceEach = customBillingItem.billing_amount
		    		}
		    		else{
		    			commercialInvoice.totalAmount = 0
		    			commercialInvoice.qty = 0
		    			ommercialInvoice.priceEach = 0
		    		}				    		
		    		commercialInvoice.createdDate = new Date()
		    		commercialInvoice.save(flush: true, failOnError: true)   			
    			}
    		}
    	}


		return [code:'success']

    }


    def generateInvoiceNumberForCustomReport(companyId) {
    	def invoiceData = [:]
    	invoiceData.invoiceNumber = null
		def invoiceDataExist = CommercialInvoiceItem.find("from CommercialInvoiceItem as cit where cit.companyId='${companyId}' order by cit.commercialInvoiceNumber DESC")

		if (!invoiceDataExist) {
			invoiceData.invoiceNumber = companyId + "000001"
		}
		else{
			def invoiceNumberInteger = invoiceDataExist.commercialInvoiceNumber - companyId
			def intIndex = invoiceNumberInteger.toInteger()
			intIndex = intIndex + 1
			def stringIndex = intIndex.toString().padLeft(6,"0")
			invoiceData.invoiceNumber = companyId + stringIndex
		}   

		return invoiceData	
    }    


}
