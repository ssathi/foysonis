package com.foysonis.billing

class CompanyBilling implements Serializable{

    String companyId
    String currentPlanDetail
    Date nextPaymentDate
    String paymentMethod
    Date trialDate
    Boolean isTrial
    String subscriptionId
    String couponId

    static mapping = {
        id composite: ['companyId']
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        currentPlanDetail(blank:false, maxSize:32)
        paymentMethod(nullable:true)
        nextPaymentDate(nullable:true)
        trialDate(nullable:true)
        subscriptionId(nullable:true)
        couponId(nullable:true)
    }
}
