package com.foysonis.billing

class CompanyPayment implements Serializable{

    String companyId
//    int id
    Date paymentDate
    String action
    String description
    Double amount
    String paidBy

//    static mapping = {
//        id composite: ['companyId','id']
//    }

    static constraints = {
        companyId(blank:false, maxSize:32)
//        id(blank:false)
        action(blank:false, maxSize:50)
        description(blank:false, maxSize:50)
        amount(nullable:true)
        paidBy(blank:false, maxSize:32)
    }
}
