package com.foysonis.user

import com.foysonis.quickbooks.QuickbooksUser
import grails.transaction.Transactional

import com.foysonis.item.ListValue
import com.foysonis.billing.CompanyBilling 
import com.foysonis.easypost.CarrierAccount

@Transactional
class CompanyService {

    def getCompany(companyId) {
        return Company.findWhere(companyId: companyId)
    }

    def getActiveUsers(companyId) {
        return User.findAllByCompanyIdAndActiveStatus(companyId, true)
    }

    def create(jsonObject) {
        def newCompany = new Company(jsonObject)
        Company oldCompany = getCompany(newCompany.companyId)

        if(oldCompany == null){
          println("Company id is not exist and add this")
        } else {
            println("Company id is already exist")
        }

        //saving company details
        def savedCompany = newCompany.save(flush:true, failOnError:true);

        def newCompanyBillingData = new CompanyBilling()
        def newListValue = new ListValue()

        newCompanyBillingData.properties = [companyId : newCompany.companyId,
                                            currentPlanDetail : jsonObject.currentPlanDetail,
                                            nextPaymentDate : jsonObject.nextPaymentDate,
                                            paymentMethod : null,
                                            trialDate : jsonObject.trialDate,
                                            isTrial : true ]

        newListValue.properties = [companyId : newCompany.companyId,
                                   optionGroup : 'INVSTATUS',
                                   optionValue : 1,
                                   description : 'GOOD',
                                   displayOrder : 1,
                                   createdDate : new Date()]



        newCompanyBillingData.save(flush:true, failOnError:true)
        newListValue.save(flush:true, failOnError:true)

        SignedUpUser signedUpUser = SignedUpUser.findByCompanyEmailId(jsonObject.companyEmail)
        signedUpUser.isConfirmed = true
        signedUpUser.save(flush:true, failOnError:true)

        return savedCompany
    }

    def createNewCompanyProfile(companyId,name){
        def newCompanyData = new Company()
        newCompanyData.properties = [companyId : companyId,
                                     name : name,
                                     activeStatus : true,
                                     noOfLicensedUsers : 1,
                                     companyLogo : null,
                                     companyBillingAddress : null,
                                     companyShippingAddress : null,
                                     gsiCompanyPrefix : null,
                                     phoneNumber : null,
                                     webAddress : null,
                                     companyEmail : null,
                                     isEasyPostEnabled:false ]

        def newCompanyBillingData = new CompanyBilling()
        newCompanyBillingData.properties = [companyId : companyId,
                                            currentPlanDetail : 'Individual',
                                            nextPaymentDate : null,
                                            paymentMethod : null,
                                            trialDate : null,
                                            isTrial : false ]

        def newListValue = new ListValue()
        newListValue.properties = [companyId : companyId,
                                   optionGroup : 'INVSTATUS',
                                   optionValue : 1,
                                   description : 'GOOD',
                                   displayOrder : 1,
                                   createdDate : new Date()]      


        newCompanyData.save(flush:true, failOnError:true)
        newCompanyBillingData.save(flush:true, failOnError:true)
        newListValue.save(flush:true, failOnError:true)
    }

    def updateCompanyProfile(companyData){

    	//CommonsMultipartFile file = companyData.list("companyLogo")?.getAt(0)

    	def company = Company.findByCompanyId(companyData.companyId)
    	company.name = companyData.companyName
    	company.gsiCompanyPrefix = companyData.gsiCompPrefix
    	//company.companyBillingAddress = companyData.companyBillAddrs
    	//company.companyShippingAddress = companyData.companyShipAddrs
    	//company.companyLogo = companyData.companyLogo
        if (companyData.companyLogo) {
            def string = companyData.companyLogo - "data:image/png;base64,"
          //company.companyLogo = companyData.companyLogo.bytes
          company.companyLogo = string.bytes  
        }
    	

    	company.save(flush:true, failOnError:true)
    }

    def updateCompanyEasyPostApi(companyId, companyApiData){
        def company = Company.findByCompanyId(companyId)
        company.easyPostProdApiKey = companyApiData.easyPostProdApiKey
        company.isEasyPostEnabled = companyApiData.isEasyPostEnabled
        if (companyApiData.isEasyPostEnabled) {
          def ePostCarrierData = CarrierAccount.list()
          if (ePostCarrierData.size() > 0) {
              for(carrierData in ePostCarrierData) {
                  def listvalue = ListValue.findByCompanyIdAndOptionGroupAndOptionValue(companyId, 'CARRCODE', carrierData.readable)
                  if (!listvalue) {
                      def createListValue = new ListValue()
                      createListValue.properties = [companyId     : companyId,
                                                    optionGroup   :'CARRCODE',
                                                    optionValue   : carrierData.readable,
                                                    description   : carrierData.readable,
                                                    displayOrder  : 0,
                                                    createdDate   :new Date()] 
                      createListValue.save(flush:true, failOnError:true)         
                  }             
              }            
          }          
        }
        else{
          def ePostCarrierData = CarrierAccount.list()
          if (ePostCarrierData.size() > 0) {
              for(carrierData in ePostCarrierData) {
                  def listvalue = ListValue.findByCompanyIdAndOptionGroupAndOptionValue(companyId, 'CARRCODE', carrierData.readable)
                  if (listvalue) {
                    listvalue.delete(flush:true, failOnError:true)
                  }
                              
              }            
          } 

        }
        company.save(flush:true, failOnError:true)        
    }

    def updateQuickbooksInfo(companyId, data) {
        boolean isQuickbooksEnabled = data.isQuickbooksEnabled

        def company = Company.findByCompanyId(companyId)
        if(company){
            company.isQuickbooksEnabled = isQuickbooksEnabled
            company.save(flush:true, failOnError:true)
        }

        def quickbooksUser = QuickbooksUser.findByCompanyId(companyId);
        if(!quickbooksUser){
            def newUser = new QuickbooksUser(username: data.username, password: data.password, companyId: data.companyId, defaultInventoryStatus: data.inventoryStatus)
            newUser.save(flush:true, failOnError:true)
        } else {
            quickbooksUser.username = data.username;
            quickbooksUser.password = data.password;
            quickbooksUser.defaultInventoryStatus = data.inventoryStatus;
            quickbooksUser.save(flush:true, failOnError:true)
        }

    }

    def updateNoOfLicensedUsers(companyId, noOfLicensedUsers){
        Company company = Company.findByCompanyId(companyId)
        if (company && company.noOfLicensedUsers != noOfLicensedUsers){
            company.noOfLicensedUsers = noOfLicensedUsers
            company.save(flush:true, failOnError:true)
        }

    }

    def updateCompanyAddress(companyId, companyAddressData){
      Company company = Company.findByCompanyId(companyId)
      if (company) {
        if (companyAddressData.billingAddressCopy) {
          company.properties = [companyBillingStreetAddress   : companyAddressData.companyBillingStreetAddress,
                                companyBillingCity            : companyAddressData.companyBillingCity,
                                companyBillingState           : companyAddressData.companyBillingState,
                                companyBillingPostCode        : companyAddressData.companyBillingPostCode,
                                companyBillingCountry         : companyAddressData.companyBillingCountry,
                                companyShippingStreetAddress  : companyAddressData.companyBillingStreetAddress,
                                companyShippingCity           : companyAddressData.companyBillingCity,
                                companyShippingState          : companyAddressData.companyBillingState,
                                companyShippingPostCode       : companyAddressData.companyBillingPostCode,
                                companyShippingCountry        : companyAddressData.companyBillingCountry]          
        }
        else{
          company.properties = [companyBillingStreetAddress   : companyAddressData.companyBillingStreetAddress,
                                companyBillingCity            : companyAddressData.companyBillingCity,
                                companyBillingState           : companyAddressData.companyBillingState,
                                companyBillingPostCode        : companyAddressData.companyBillingPostCode,
                                companyBillingCountry         : companyAddressData.companyBillingCountry,
                                companyShippingStreetAddress  : companyAddressData.companyShippingStreetAddress,
                                companyShippingCity           : companyAddressData.companyShippingCity,
                                companyShippingState          : companyAddressData.companyShippingState,
                                companyShippingPostCode       : companyAddressData.companyShippingPostCode,
                                companyShippingCountry        : companyAddressData.companyShippingCountry]          
        }


        company.save(flush:true, failOnError:true)   
                           
      }
    }
   
}

