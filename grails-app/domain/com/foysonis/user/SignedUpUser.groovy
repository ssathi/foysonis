package com.foysonis.user

class SignedUpUser implements Serializable {

    String firstName;
    String lastName;
    String companyEmailId;
    Boolean isConfirmed;
    String pricingPlan;
    String sourceId

    static mapping = {
        version false
    }
    static constraints = {
        isConfirmed(nullable:true)
        pricingPlan(nullable:true)
        sourceId(nullable:true)
    }



}
