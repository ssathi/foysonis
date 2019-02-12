package com.foysonis.orders

class CustomerAddress implements Serializable{

    String companyId
    String customerId
    String addressType
    String streetAddress
    String city
    String state
    String postCode
    String country
    Boolean isDefault

    static constraints = {
        companyId(blank:false, maxSize:32)
        customerId(blank:false, maxSize:50)
        addressType(blank:false, maxSize:30)
        streetAddress(nullable:true, maxSize:1000)
        city(nullable:true, maxSize:100)
        state(nullable:true, maxSize:100)
        postCode(nullable:true, maxSize:20)
        country(nullable:true)
    }
}
