package com.foysonis.orders

import groovy.sql.Sql
import grails.transaction.Transactional

@Transactional
class CustomerService {
    def sessionFactory

    def getAllcustomerIdByCompany(companyId, keyWord){
        def keyCustomer = '%'+keyWord+'%'
        def sqlQuery = " SELECT c.customer_id as customerId, c.contact_name as contactName, c.company_name as companyName, c.is_customer_hold AS isCustomerHold, ca.street_address as shippingStreetAddress, ca.city as shippingCity, ca.state as shippingState, ca.post_code as shippingPostCode, ca.country as shippingCountry FROM customer as c INNER JOIN customer_address AS ca ON c.customer_id = ca.customer_id WHERE c.company_id = '${companyId}' AND ca.is_default = true AND ca.address_type = 'shipping' AND (c.company_name LIKE '${keyCustomer}' OR c.contact_name LIKE '${keyCustomer}') ORDER BY c.contact_name ASC LIMIT 10"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }


    def customerSave(companyId, customerData) {

        def customer = new Customer()
        def customerAddress = new CustomerAddress()

        customer.properties = [companyId:companyId,
                               contactName :customerData.contactName,
                               companyName : customerData.companyName,
                               phonePrimary : customerData.phonePrimary,
                               phoneAlternate : customerData.phoneAlternate,
                               email : customerData.email,
                               fax : customerData.fax,
                               isCustomerHold: customerData.isCustomerHold ? customerData.isCustomerHold : false ,
                               notes:customerData.notes,
                               billingStreetAddress :customerData.billingStreetAddress,
                               billingCity : customerData.billingCity,
                               billingState : customerData.billingState,
                               billingPostCode : customerData.billingPostCode,
                               billingCountry : customerData.billingCountry
                               ]

        customerAddress.companyId = companyId
        customerAddress.addressType = "shipping"
        customerAddress.isDefault = true

        if (customerData.sameAsBilling) {
            customerAddress.streetAddress = customerData.billingStreetAddress
            customerAddress.city = customerData.billingCity
            customerAddress.state = customerData.billingState
            customerAddress.postCode = customerData.billingPostCode
            customerAddress.country = customerData.billingCountry

                                 
        }  
        else {

            customerAddress.streetAddress = customerData.shippingStreetAddress
            customerAddress.city = customerData.shippingCity
            customerAddress.state = customerData.shippingState
            customerAddress.postCode = customerData.shippingPostCode
            customerAddress.country = customerData.shippingCountry

        }                   


        def customerIdExist = Customer.find("from Customer as c where c.companyId='${companyId}' order by customerId DESC")
        if (!customerIdExist) {

            customer.customerId = companyId + "001"
        }
        else{

            def customerIdInteger = customerIdExist.customerId - companyId
            def intIndex = customerIdInteger.toInteger()
            intIndex = intIndex + 1
            def stringIndex = intIndex.toString().padLeft(3,"0")
            customer.customerId = companyId + stringIndex

        }
        customerAddress.customerId = customer.customerId
        customerAddress.save(flush: true, failOnError: true)

        return customer.save(flush: true, failOnError: true)
        

    }


    def deleteCustomer(companyId, customerData){
        def customer = Customer.findByCompanyIdAndCustomerId(companyId,customerData.customerId)

        def customerAddress = CustomerAddress.findAllByCompanyIdAndCustomerId(companyId,customerData.customerId)

        if(customerAddress){
            for(address in customerAddress){
                address.delete(flush:true, failOnError:true)
            }
        }

        if (customer){
            customer.delete(flush:true, failOnError:true)
            return true
        }

    }


    def updateCustomer(companyId,customerData) {
        def customer = Customer.findByCompanyIdAndCustomerId(companyId, customerData.customerId)
        def customerAddress = CustomerAddress.findByCompanyIdAndCustomerIdAndIsDefaultAndAddressType(companyId, customerData.customerId, true, 'shipping')


        if (customer) {
            customer.properties = [contactName :customerData.contactName,
                                   companyName : customerData.companyName,
                                   phonePrimary : customerData.phonePrimary,
                                   phoneAlternate : customerData.phoneAlternate,
                                   email : customerData.email,
                                   fax : customerData.fax,
                                   isCustomerHold:customerData.isCustomerHold,
                                   notes:customerData.notes,
                                   billingStreetAddress :customerData.billingStreetAddress,
                                   billingCity : customerData.billingCity,
                                   billingState : customerData.billingState,
                                   billingPostCode : customerData.billingPostCode,
                                   billingCountry : customerData.billingCountry
            ]


        }
        if (customerData.sameAsBilling) {
            customerAddress.streetAddress = customerData.billingStreetAddress
            customerAddress.city = customerData.billingCity
            customerAddress.state = customerData.billingState
            customerAddress.postCode = customerData.billingPostCode
            customerAddress.country = customerData.billingCountry


        }
        else {

            customerAddress.streetAddress = customerData.shippingStreetAddress
            customerAddress.city = customerData.shippingCity
            customerAddress.state = customerData.shippingState
            customerAddress.postCode = customerData.shippingPostCode
            customerAddress.country = customerData.shippingCountry

        }

        customerAddress.save(flush: true, failOnError: true)
        customer.save(flush: true, failOnError: true)
        return customer

    }


    def customerSearch (companyId,customerId) {
        def sqlQuery = "SELECT c.*, ca.* FROM customer as c LEFT JOIN customer_address AS ca ON c.customer_id = ca.customer_id AND ca.is_default = true AND ca.address_type = 'shipping' WHERE c.company_id = '${companyId}' "
        if(customerId){
            def findCustomer = '%'+customerId+'%'
            sqlQuery = sqlQuery + " AND (c.company_name LIKE '${findCustomer}'" +
                    "OR c.contact_name LIKE '${findCustomer}'" +
                    "OR c.phone_primary LIKE '${findCustomer}'" +
                    "OR c.phone_alternate LIKE '${findCustomer}'" +
                    "OR c.billing_country LIKE '${findCustomer}'" +
                    "OR ca.country LIKE '${findCustomer}'" +
                    "OR c.billing_city LIKE '${findCustomer}'" +
                    "OR ca.city LIKE '${findCustomer}'" +
                    ")"
        }

        sqlQuery = sqlQuery + " ORDER BY c.customer_id ASC"

        log.info("sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows

    }


    def getCustomerByGrid(companyId) {
        def sqlQuery = "SELECT c.*, ca.* FROM customer as c INNER JOIN customer_address AS ca ON c.customer_id = ca.customer_id WHERE c.company_id = '${companyId}' AND ca.is_default = true AND ca.address_type = 'shipping' ORDER BY c.customer_id DESC LIMIT 1"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def getCustomerShippingAddress(companyId, customerId) {
        def sqlQuery = "SELECT id,  CONCAT_WS(', ', street_address, city, state, post_code, country) AS shippingAddress FROM customer_address "
        sqlQuery = sqlQuery + " WHERE company_id = '${companyId}' AND customer_id = '${customerId}' AND address_type='shipping' "
        sqlQuery = sqlQuery + " ORDER BY is_default DESC, id DESC "

        log.info(" sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def getCustomerShippingAddressWithShipment(companyId, customerId) {
        def sqlQuery = "SELECT DISTINCT ca.id, ca.address_type, ca.city, ca.country, ca.is_default, ca.post_code, ca.state, ca.street_address, ca.customer_id, sh.shipping_address_id "
        sqlQuery = sqlQuery + " FROM customer_address AS ca "
        sqlQuery = sqlQuery + " LEFT JOIN shipment As sh ON sh.shipping_address_id = ca.id AND sh.company_id = '${companyId}' "
        sqlQuery = sqlQuery + " WHERE ca.company_id = '${companyId}' AND ca.address_type='shipping' AND ca.customer_id='${customerId}' "
        sqlQuery = sqlQuery + " ORDER BY ca.is_default DESC, ca.id DESC "

        log.info(" sqlQuery : " + sqlQuery)

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }

    def checkOrderExistForCustomer(companyId,customerId) {
        def sqlQuery = "SELECT * FROM customer as c INNER JOIN orders as o ON c.customer_id = o.customer_id WHERE o.company_id = '${companyId}'AND c.customer_id = '${customerId}';"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }


    def updateCustomerShippingAddress(companyId,customerId) {

        def customers = Customer.findAllByCompanyId(companyId)

        for(customer in customers){

            def customerAddress = new CustomerAddress()
            customerAddress.companyId = companyId
            customerAddress.customerId = customer.customerId
            customerAddress.addressType = "shipping"
            customerAddress.isDefault = true
            customerAddress.streetAddress = customer.shippingStreetAddress
            customerAddress.city = customer.shippingCity
            customerAddress.state = customer.shippingState
            customerAddress.postCode = customer.shippingPostCode
            customerAddress.country = customer.shippingCountry
            customerAddress.save(flush: true, failOnError: true)


            def orders = Orders.findAllByCompanyIdAndCustomerId(companyId, customer.customerId)
            if(orders){
                for(order in orders){
                    def shipmentlines = ShipmentLine.findAllByCompanyIdAndOrderNumber(companyId, order.orderNumber)
                    if(shipmentlines){
                        for(shipmentline in shipmentlines){
                            def shipment = Shipment.findByCompanyIdAndShipmentId(companyId,shipmentline.shipmentId)
                            shipment.shippingAddressId = customerAddress.id
                            shipment.save(flush: true, failOnError: true)
                        }
                    }
                }
            }

        }

        return true
    }

    def createCustomerShippingAddress(CustomerAddress customerAddress) {
        return customerAddress.save(flush: true, failOnError: true)
    }

    def makeDefaultShippingAddress(companyId, customerId, addressId){
        CustomerAddress defaultAddress = CustomerAddress.findByCompanyIdAndCustomerIdAndIsDefault(companyId,customerId,true)
        if(defaultAddress){
            defaultAddress.isDefault = false
            defaultAddress.save(flush: true, failOnError: true)
        }
        CustomerAddress customerAddress = CustomerAddress.findByCompanyIdAndCustomerIdAndId(companyId,customerId,addressId)
        customerAddress.isDefault = true
        return customerAddress.save(flush: true, failOnError: true)

    }

    def deleteShippingAddress(companyId, customerId, addressId){
        def customerAddressUpdate = CustomerAddress.findByCompanyIdAndCustomerIdAndId(companyId,customerId,addressId)
        if (customerAddressUpdate) {
            customerAddressUpdate.delete(flush: true, failOnError: true);
            return[delete:'successful']
        }
        else{
            return[delete:'unseccessful']
        }
    }

    def checkIsCustomerAddressInUse(companyId, addressId) {
        return Shipment.findAllByCompanyIdAndShippingAddressId(companyId, addressId)
    }

    def getCustomerByIdAndCompany(companyId, customerId){
        def sqlQuery = " SELECT * FROM customer as c WHERE c.company_id = '${companyId}' AND c.customer_id ='${customerId}' "
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }


}
