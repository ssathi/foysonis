package com.foysonis.user

class Company implements Serializable {

    String companyId
    String name
    Boolean activeStatus
    Integer noOfLicensedUsers
    byte[] companyLogo
    String companyBillingStreetAddress
    String companyBillingCity
    String companyBillingState
    String companyBillingPostCode
    String companyBillingCountry
    String companyShippingStreetAddress
    String companyShippingCity
    String companyShippingState
    String companyShippingPostCode
    String companyShippingCountry
    String gsiCompanyPrefix
    String phoneNumber
    String webAddress
    String companyEmail
    String sourceId
    String easyPostProdApiKey
    Boolean isEasyPostEnabled
    Boolean isQuickbooksEnabled
    Boolean autoLoadPalletId
    Boolean is3plEnabled
    Boolean isAutoLoadPackoutContainer
    String bolType



    static mapping = {
        id name: 'companyId'
        version false
        id generator: 'assigned'
    }

    static constraints = {
        companyId(blank:false, maxSize:32)
        name(blank:false)
        companyLogo(nullable:true, maxSize: 1024 * 1024 * 2)
        phoneNumber(nullable:true)
        companyBillingStreetAddress(nullable:true)
        companyBillingCity(nullable:true)
        companyBillingState(nullable:true)
        companyBillingPostCode(nullable:true)
        companyBillingCountry(nullable:true)
        companyShippingStreetAddress(nullable:true)
        companyShippingCity(nullable:true)
        companyShippingState(nullable:true)
        companyShippingPostCode(nullable:true)
        companyShippingCountry(nullable:true)
        gsiCompanyPrefix(nullable:true)
        webAddress(nullable:true)
        companyEmail(nullable:true)
        sourceId(nullable:true)
        easyPostProdApiKey(nullable:true)
        isEasyPostEnabled(nullable:true)
        isQuickbooksEnabled(nullable: true)
        autoLoadPalletId(nullable:true)
        is3plEnabled(nullable:true)
        isAutoLoadPackoutContainer(nullable:true)
        bolType(nullable:true)

    }

}