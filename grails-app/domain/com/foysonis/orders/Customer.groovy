package com.foysonis.orders

class Customer implements Serializable{

    String companyId
    String customerId
    String contactName
    String companyName
    String phonePrimary
    String phoneAlternate
    String email
    String fax
    Boolean isCustomerHold
    String notes
    String billingStreetAddress
    String billingCity
    String billingState
    String billingPostCode
    String billingCountry



    static mapping = {
        id composite: ['companyId', 'customerId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        customerId(blank:false, maxSize:50)
        contactName(blank:false, maxSize:500)
        companyName(blank:false)
        phonePrimary(nullable:true)
        phoneAlternate(nullable:true)
        email(nullable:true)
        fax(nullable:true)
        notes(nullable:true, maxSize:5000)
        billingStreetAddress(nullable:true, maxSize:1000)
        billingCity(nullable:true, maxSize:100)
        billingState(nullable:true, maxSize:100)
        billingPostCode(nullable:true, maxSize:20)
        billingCountry(nullable:true) // from List Value


    }
}

