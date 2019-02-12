package com.foysonis.billing

class CompanyCreditCard implements Serializable{

    String companyId
    String username
    String nameOnCard
    Long cardNumber
    int expirationMonth
    int expirationYear
    String billingAddress
    String city
    String state
    String zip

    static mapping = {
        id composite: ['companyId','username']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        username(blank: false, maxSize:32)
        nameOnCard(blank:false, maxSize:50)
        cardNumber(blank:false)
        billingAddress(blank:false, maxSize:255)
        city(blank:false)
        state(nullable:true)
        zip(blank:false)
        expirationMonth(blank:false)
        expirationYear(blank:false)
    }
}
