package com.foysonis.billing

import com.foysonis.user.Company
import com.foysonis.user.CompanyService
import grails.transaction.Transactional
import groovy.sql.Sql
import com.foysonis.billing.CompanyBilling
import com.foysonis.billing.CompanyCreditCard
import com.foysonis.billing.CompanyPayment

import com.stripe.model.Charge
import com.stripe.model.Customer
import com.stripe.model.Plan
import com.stripe.model.Subscription
import com.stripe.Stripe

import groovy.time.TimeCategory

@Transactional
class BillingService {

    def sessionFactory
    CompanyService companyService



    def getCompanyPaymentHistory(companyId) {
        return CompanyPayment.findAllByCompanyId(companyId, [sort:'paymentDate', order: 'desc'])
    }

    def getCompanyCreditCard(companyId){
        return CompanyCreditCard.findByCompanyId(companyId)
    }

    def getCompanyBillingDetails(companyId){
        return CompanyBilling.findByCompanyId(companyId)
    }

    def isTrialEnd(companyId){
       return CompanyBilling.find("FROM CompanyBilling AS cb WHERE cb.companyId = '${companyId}' AND cb.isTrial = true AND cb.trialDate <= CURDATE()")
    }

    def updateCreditCard(companyId, username, customerData) {
        def companyCreditCard = CompanyCreditCard.findByCompanyIdAndUsername(companyId, username);

        def getCardNumber = customerData.cardNumber
        def last4DigitCardNumber = getCardNumber.reverse().take(4).reverse();

        if (companyCreditCard) {

            companyCreditCard.properties = [nameOnCard : customerData.nameOnCard,
                                            cardNumber : last4DigitCardNumber,
                                            expirationMonth : customerData.expirationMonth,
                                            expirationYear : customerData.expirationYear,
                                            billingAddress : customerData.billingAddress,
                                            city : customerData.city,
                                            state : customerData.state,
                                            zip : customerData.zip
            ]

        }

        else{
            companyCreditCard = new CompanyCreditCard()
            companyCreditCard.companyId = companyId
            companyCreditCard.username = username

            companyCreditCard.properties = [nameOnCard : customerData.nameOnCard,
                                            cardNumber : last4DigitCardNumber,
                                            expirationMonth : customerData.expirationMonth,
                                            expirationYear : customerData.expirationYear,
                                            billingAddress : customerData.billingAddress,
                                            city : customerData.city,
                                            state : customerData.state,
                                            zip : customerData.zip
            ]

        }

        companyCreditCard.save(flush: true, failOnError: true)
        return true

    }


//    def updateCompanyBilling(companyId, customerData) {
//        def companyBilling = CompanyBilling.findByCompanyId(companyId);
//
//        if (companyBilling) {
//            companyBilling.properties = [paymentMethod : customerData.paymentMethod,
//                                         subscriptionId: 'sub_27374heehrehe']
//
//        }
//
//        companyBilling.save(flush: true, failOnError: true)
//        return true
//
//    }


    def updateCompanyPayment(companyId, username, customerData) {

            def companyPayment = new CompanyPayment()
            companyPayment.companyId = companyId

            companyPayment.properties = [action : 'test action',
                                         description : 'test desc',
                                         amount : customerData.amount,
                                         paidBy : username,
                                         paymentDate : new Date(),
            ]

        companyPayment.save(flush: true, failOnError: true)
        return true

    }




    def upgradePremium(companyId, customerData) {
        def companyBilling = CompanyBilling.findByCompanyId(companyId);

        if (companyBilling) {
            companyBilling.properties = [currentPlanDetail : customerData.currentPlanDetail,
                                         paymentMethod : customerData.paymentMethod]

            if(customerData.currentPlanDetail == "Premium-monthly"){
                companyBilling.properties = [nextPaymentDate : new Date()+30]
            }

        }

        companyBilling.save(flush: true, failOnError: true)
        return true

    }

    def upgradeCurrentPlan(companyId, customerData) {
        def companyBilling = CompanyBilling.findByCompanyId(companyId);

        if (companyBilling) {
            companyBilling.properties = [currentPlanDetail : customerData.currentPlanDetail]

            if(customerData.currentPlanDetail == "Premium-monthly"){
                companyBilling.properties = [nextPaymentDate : new Date()+30]
            }


        }

        companyBilling.save(flush: true, failOnError: true)
        return true

    }

    def upgradeNoOfUsers(companyId, customerData) {
        def company = Company.findByCompanyId(companyId);

        if (company) {
            company.properties = [noOfLicensedUsers : customerData.NoOfUsers]

        }

        CompanyBilling companyBilling = CompanyBilling.findByCompanyId(companyId)
        if(companyBilling && companyBilling.isTrial == true){
            companyBilling.isTrial = false
            use (TimeCategory) {
                companyBilling.nextPaymentDate = new Date() + 1.month
            }
            companyBilling.save(flush: true, failOnError: true)

        }

        company.save(flush: true, failOnError: true)
        return true

    }

    def calculatePlanTotalAmount(Integer planAmount, Integer noOfUser) {
        def totalAmount = planAmount * noOfUser;
        totalAmount

//        def previousPlan = customerData.plan;
//        def previousNextPaymentDate = customerData.nexChargeDate;
//        def previousTotalAmount = customerData.nexChargeAmount;
//
//        println("previousPlan-----------" + previousPlan)
//        println("previousDate-----------" + previousNextPaymentDate)
//        println("previousAmount-----------" + previousTotalAmount)
//
////        def previousPlanAmount = customerData.planAmount
////        def previousNoOfUser = customerData.previousNoOfUser
////        def previousTotalAmount = previousPlanAmount * previousNoOfUser
//
//        def newTotalAmount  = planAmount * noOfUser;
//
//        if(previousPlan == "Individual"){
//            def totalAmount = planAmount * noOfUser;
//            totalAmount
//        }
//
//        else{
//            def totalAmount = newTotalAmount - ((previousNextPaymentDate - new Date()) * previousTotalAmount)
//            totalAmount
//        }


    }


    def getPreviousDetails(customerData) {
        def previousPlan = customerData.plan;
        def previousNextPaymentDate = customerData.nexChargeDate;
        def previousTotalAmount = customerData.nexChargeAmount;

        println("previousPlan-----------" + previousPlan)
        println("previousDate-----------" + previousNextPaymentDate)
        println("previousAmount-----------" + previousTotalAmount)

    }


    ///new

//    def updateCompanyCreditCard(companyId, username, customerData) {
//        def companyCreditCard = CompanyCreditCard.findByCompanyIdAndUsername(companyId, username);
//
//        def getCardNumber = customerData.cardNumber
//        def last4DigitCardNumber = getCardNumber.reverse().take(4).reverse();
//
//        if (companyCreditCard) {
//
//            companyCreditCard.properties = [nameOnCard : customerData.nameOnCard,
//                                            cardNumber : last4DigitCardNumber,
//                                            expirationMonth : customerData.expirationMonth,
//                                            expirationYear : customerData.expirationYear,
//                                            billingAddress : customerData.billingAddress,
//                                            city : customerData.city,
//                                            state : customerData.state,
//                                            zip : customerData.zip
//            ]
//
//        }
//
//        else{
//            companyCreditCard = new CompanyCreditCard()
//            companyCreditCard.companyId = companyId
//            companyCreditCard.username = username
//
//            companyCreditCard.properties = [nameOnCard : customerData.nameOnCard,
//                                            cardNumber : last4DigitCardNumber,
//                                            expirationMonth : customerData.expirationMonth,
//                                            expirationYear : customerData.expirationYear,
//                                            billingAddress : customerData.billingAddress,
//                                            city : customerData.city,
//                                            state : customerData.state,
//                                            zip : customerData.zip
//            ]
//
//        }
//
//        companyCreditCard.save(flush: true, failOnError: true)
//        return true
//
//    }
//
//
//    def updateCompanyBilling(companyId, customerData) {
//        def companyBilling = CompanyBilling.findByCompanyId(companyId);
//
//        if (companyBilling) {
//            companyBilling.properties = [paymentMethod : customerData.paymentMethod,
//                                         subscriptionId: customerData.paymentMethod]
//
//        }
//
//        companyBilling.save(flush: true, failOnError: true)
//        return true
//
//    }
//
//
//    def updateCompanyPayment(companyId, username, customerData) {
//
//        def companyPayment = new CompanyPayment()
//        companyPayment.companyId = companyId
//
//        companyPayment.properties = [action : 'test action',
//                                     description : 'test desc',
//                                     amount : customerData.amount,
//                                     paidBy : username,
//                                     paymentDate : new Date(),
//        ]
//
//        companyPayment.save(flush: true, failOnError: true)
//        return true
//
//    }
//
//
//    def updateNoOfUsers(companyId, customerData) {
//        def company = Company.findByCompanyId(companyId);
//
//        if (company) {
//            company.properties = [noOfLicensedUsers : customerData.NoOfUsers]
//
//        }
//
//        company.save(flush: true, failOnError: true)
//        return true
//
//    }

    // SRIKARAN

    def updateCompanyBilling(billingData){

        log.info("billingData.isTrial" + billingData.isTrial)

        CompanyBilling companyBilling = CompanyBilling.findByCompanyId(billingData.companyId)
        if(!companyBilling){
            companyBilling = new CompanyBilling()
            companyBilling.companyId = billingData.companyId
        }


        if(billingData.currentPlanDetail)
            companyBilling.currentPlanDetail = billingData.currentPlanDetail
        if(billingData.paymentMethod)
            companyBilling.paymentMethod = billingData.paymentMethod
        if(billingData.trialDate)
            companyBilling.trialDate = billingData.trialDate

        if(billingData.isTrial == true && companyBilling.isTrial == false ){
            use (TimeCategory) {
                companyBilling.nextPaymentDate = new Date() + 1.month
            }
        }
        else if(billingData.nextPaymentDate){
            companyBilling.nextPaymentDate = billingData.nextPaymentDate
        }

        if(billingData.isTrial != null)
            companyBilling.isTrial = billingData.isTrial
        if(billingData.subscriptionId)
            companyBilling.subscriptionId = billingData.subscriptionId


        log.info("companyBilling.isTrial" +companyBilling.isTrial)
        companyBilling.save(flush:true, failOnError:true)
    }

    def updateCompanyCreditCard(creditCardData){
        CompanyCreditCard companyCreditCard = CompanyCreditCard.findByCompanyId(creditCardData.companyId)
        if(!companyCreditCard){
            companyCreditCard = new CompanyCreditCard()
            companyCreditCard.companyId = creditCardData.companyId
        }

        if(creditCardData.username)
            companyCreditCard.username = creditCardData.username
        if(creditCardData.nameOnCard)
            companyCreditCard.nameOnCard = creditCardData.nameOnCard
        if(creditCardData.cardNumber)
            companyCreditCard.cardNumber = creditCardData.cardNumber.reverse().take(4).reverse().toInteger()
        if(creditCardData.expirationMonth)
            companyCreditCard.expirationMonth = creditCardData.expirationMonth.toInteger()
        if(creditCardData.expirationYear)
            companyCreditCard.expirationYear = creditCardData.expirationYear.toInteger()
        if(creditCardData.billingAddress)
            companyCreditCard.billingAddress = creditCardData.billingAddress
        if(creditCardData.city)
            companyCreditCard.city = creditCardData.city
        if(creditCardData.state)
            companyCreditCard.state = creditCardData.state
        if(creditCardData.zip)
            companyCreditCard.zip = creditCardData.zip

        companyCreditCard.save(flush:true, failOnError:true)
    }

    def updateCompanyPayment(paymentData){
        CompanyPayment companyPayment = new CompanyPayment()
        companyPayment.companyId = paymentData.companyId
        companyPayment.paymentDate = new Date()

        if(paymentData.action)
            companyPayment.action = paymentData.action
        if(paymentData.description)
            companyPayment.description = paymentData.description
        if(paymentData.amount)
            companyPayment.amount = paymentData.amount
        if(paymentData.paidBy)
            companyPayment.paidBy = paymentData.paidBy

        companyPayment.save(flush:true, failOnError:true)

    }

    def upgrade(billingData) {

        companyService.updateNoOfLicensedUsers(billingData.companyId, billingData.NoOfUsers)



//        if(billingData.currentPlanDetail == "Standard-monthly" || billingData.currentPlanDetail == "Premium-monthly"){
//            billingData.nextPaymentDate = new Date()+30
//        }
//        else if(billingData.currentPlanDetail == "Standard-yearly" || billingData.currentPlanDetail == "Premium-yearly"){
//            billingData.nextPaymentDate = new Date()+365
//        }

        billingData.isTrial = false

        updateCompanyBilling(billingData)

        updateCompanyCreditCard(billingData)

        updateCompanyPayment(billingData)

        return true

    }




}