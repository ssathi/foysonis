package com.foysonis.billing

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

import com.stripe.model.Charge
import com.stripe.model.Customer
import com.stripe.model.Plan
import com.stripe.model.Invoice
import com.stripe.model.Subscription
import com.stripe.model.InvoiceItem
import com.stripe.Stripe

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class BillingController extends RestfulController<CompanyBilling> {

    def springSecurityService
    BillingService billingService
//    CompanyService companyService
    def sessionFactory

    static responseFormats = ['json', 'xml']

    def BillingController() {
        super(CompanyBilling)
    }

    def index() {
        session.user = springSecurityService.currentUser
        def pageTitle = "Billing & Licenses";
        [pageTitle: pageTitle]
    }


    def getCompanyPaymentHistory() {
        respond billingService.getCompanyPaymentHistory(session.user.companyId)
    }

    def getCompanyPaymentStripeHistory() {
//        respond billingService.getCompanyPaymentHistory(session.user.companyId)

        def apiKeyFromApp = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        Stripe.apiKey = apiKeyFromApp

        Map<String, Object> invoiceParams = new HashMap<String, Object>()
        invoiceParams.put("customer", session.user.companyId)

        respond Invoice.all(invoiceParams)
    }

    def getCompanyCreditCard() {
        respond billingService.getCompanyCreditCard(session.user.companyId)
    }


    def getCompanyBilling() {
        respond billingService.getCompanyBillingDetails(session.user.companyId)
    }

    def getCompanyBillingForSupport(){
        respond CompanyBilling.findAllByCompanyId(session.user.companyId)
    }

    def isTrialEnd() {

        respond billingService.isTrialEnd(session.user.companyId)
    }

//    def getNumberOfUser() {
//        respond billingService.getNumberOfUser(session.user.companyId)
//    }

    def updateCreditCard = {

        def jsonObject = request.JSON
        def token = jsonObject.card

        println ("currentPlanDetail " + jsonObject.currentPlanDetail)
        println ("trialDateTimeStamp " + jsonObject.trialDateTimeStamp)
        println ("couponId " + jsonObject.couponId)

        def apiKeyFromApp = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        Stripe.apiKey = apiKeyFromApp

        try {
            Customer cu = Customer.retrieve(session.user.companyId)

            Map<String, Object> updateCustomerParams = new HashMap<String, Object>();
            updateCustomerParams.put("source", token);
            updateCustomerParams.put("description", jsonObject.nameOnCard);
            cu.update(updateCustomerParams)
        }
        catch (Exception e) {
            def customerParams = [
                    'id': session.user.companyId,
                    'source'  : token,
                    'description': jsonObject.nameOnCard
            ]

            if(jsonObject.couponId){
                customerParams.put('coupon', jsonObject.couponId);
            }

            Customer.create(customerParams)

            Customer cu = Customer.retrieve(session.user.companyId)

            Map<String, Object> subscriptionParams = new HashMap<String, Object>();
            subscriptionParams.put("plan", jsonObject.currentPlanDetail);
            subscriptionParams.put("prorate", false);
            subscriptionParams.put("quantity", 1);

            if(jsonObject.currentTimeStamp < jsonObject.trialDateTimeStamp){
                subscriptionParams.put("trial_end", jsonObject.trialDateTimeStamp);
            }
            else{
                subscriptionParams.put("trial_end", "now");
            }


            print("Create subscription....." + subscriptionParams)
            cu.createSubscription(subscriptionParams)

        }

        respond billingService.updateCreditCard(session.user.companyId, session.user.username, jsonObject)

    }

    def updateCompanyBilling = {
        def jsonObject = request.JSON
        respond billingService.updateCompanyBilling(session.user.companyId, jsonObject)

    }

    def updateCompanyPayment = {
        def jsonObject = request.JSON
        respond billingService.updateCompanyPayment(session.user.companyId, session.user.username, jsonObject)

    }

    // stripe

    def getPlanAmount() {
        def jsonObject = request.JSON
        def planName = jsonObject.planDetails
        Stripe.apiKey = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        try {
            Plan s = Plan.retrieve(planName)
            respond s
        } catch (Exception e) {
            //do nothing
        }
    }

    def getSubscriptionId() {
        def jsonObject = request.JSON
        def name = jsonObject.nameOnCard
        Stripe.apiKey = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        try {
            Subscription sub = Subscription.retrieve(name);
            respond sub

        } catch (Exception e) {
            //do nothing
        }
    }


    def checkout() {
        // TODO move to service class

//        def jsonObject = request.JSON
//        def test = billingService.getPreviousDetails(jsonObject)
//        println("TestData----------------- " + test)

        try {
            def jsonObject = request.JSON
            println("jsonObject----------------- " + jsonObject)
            //Set Stripe Secret/Api Key
            def apiKeyFromApp = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
            Stripe.apiKey = apiKeyFromApp

            def amount = billingService.calculatePlanTotalAmount(jsonObject.planAmount, jsonObject.NoOfUsers)

            jsonObject.amount = amount
            def token = jsonObject.card
            def name = jsonObject.nameOnCard
            def plan = jsonObject.plan
            def customerId = jsonObject.customerId

            if (amount && token) {
                println "\n\nSTRIPE API KEY : ${Stripe.apiKey} -> TOKEN : ${token} -> AMOUNT : ${amount}\n\n"
                //convert amount into cents
                def amountInCents = (amount * 100) as Integer

                //create Stripe parameters object
                def chargeParams = [
                        'customer': customerId,
                        'amount'     : amountInCents,
                        'currency'   : 'usd',
//                        'card'       : token,
                        'description': "Order Placed ${amount}",
                ]

                def customerParams = [
                        'id': customerId,
                        'source'  : token,
                       'description': name
                ]


                Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                subscriptionParams.put("plan", plan);

                Map<String, Object> updateCustomerParams = new HashMap<String, Object>();
                updateCustomerParams.put("source", token);
                updateCustomerParams.put("description", name);

//                Charge.create(chargeParams)

                try {
                    Customer cu = Customer.retrieve(customerId)
                    if (cu != null) {
                        print("Updating existing customer")
                        cu.update(updateCustomerParams)
                        cu.updateSubscription(subscriptionParams)
                    }
                } catch (Exception e) {
                    print("There is no such customer. " + e)
                    print("Creating new customer")
                    print("Creating new customer......*****" + customerParams)
                    Customer.create(customerParams);
                    print("Creating new customer........." + customerParams)
                    print("Create subscription....." + subscriptionParams)

                    Customer cu = Customer.retrieve(customerId);
                    cu.updateSubscription(subscriptionParams)

                    print("Updated subscription")

//                    Subscription.create(subscriptionParams)
                }

                Charge.create(chargeParams)

                flash.message = "Successfully charged Stripe"

                println("Successfully charged Stripe")
            }

//            billingService.updateCompanyBilling(session.user.companyId, jsonObject)
//            billingService.updateCreditCard(session.user.companyId, session.user.username, jsonObject)
//            billingService.updateCompanyPayment(session.user.companyId, session.user.username, jsonObject)


        } catch (Exception e) {
            flash.message = "Something went wrong ..."
            println("Status is: " + e.printStackTrace());
        }


    }



    def updateStripe(stripeData) {


//        def jsonObject = request.JSON
//        def test = billingService.getPreviousDetails(jsonObject)
//        println("TestData----------------- " + test)

        try {
            println("stripeData----------------- " + stripeData)

            //Set Stripe Secret/Api Key
            def apiKeyFromApp = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
            Stripe.apiKey = apiKeyFromApp


            def token = stripeData.card
            def name = stripeData.nameOnCard
            def plan = stripeData.currentPlanDetail
            def previousPlan = stripeData.plan
            def customerId = stripeData.companyId
            def noOfUsers = stripeData.NoOfUsers
            String couponId = stripeData.couponId

            println("Plan :"+ plan)
            println("token :"+ token)

            if (plan && token) {


                try {
                    Customer cu = Customer.retrieve(customerId)
                    if (cu != null) {

                        println("Updating an existing customer....!!!")
                        println("Updating existing customer...")

                        Map<String, Object> updateCustomerParams = new HashMap<String, Object>();
                        updateCustomerParams.put("source", token);
                        updateCustomerParams.put("description", name);

                        cu.update(updateCustomerParams)


                        if(previousPlan == "Individual"){

                            Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                            subscriptionParams.put("plan", plan);
                            subscriptionParams.put("prorate", false);
                            subscriptionParams.put("quantity", 1);
                            subscriptionParams.put("trial_end", "now");

                            print("Create subscription....." + subscriptionParams)
                            cu.createSubscription(subscriptionParams)

                            if(plan == "Standard" && noOfUsers > 2){
                                Integer additionalUser = noOfUsers - 2

                                Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                                additionalUserSubscriptionParams.put("plan", "Standard - User");
                                additionalUserSubscriptionParams.put("prorate", false);
                                additionalUserSubscriptionParams.put("quantity", additionalUser);
                                cu.createSubscription(additionalUserSubscriptionParams)
                            }
                            else if(plan == "Premium" && noOfUsers > 5){
                                Integer additionalUser = noOfUsers - 5

                                Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                                additionalUserSubscriptionParams.put("plan", "Premium - User");
                                additionalUserSubscriptionParams.put("prorate", false);
                                additionalUserSubscriptionParams.put("quantity", additionalUser);
                                cu.createSubscription(additionalUserSubscriptionParams)
                            }
                        }
                        else  if(previousPlan == "Standard"){


                            if(plan == "Premium" && noOfUsers >= 5){

                                def isUpdatedAdditionalUser = false

                                for (subs in cu.subscriptions.data){
                                    def subscription = cu.subscriptions.retrieve(subs.id)

                                    if(subscription.plan.id == "Standard"){

                                        def previousPlanAmount = subscription.plan.amount
                                        def previousPeriodEnd = new Date(((long)subscription.currentPeriodEnd) * 1000)

                                        Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                                        subscriptionParams.put("plan", "Premium");
                                        subscriptionParams.put("prorate", false);
                                        subscriptionParams.put("quantity", 1);
                                        subscriptionParams.put("trial_end", "now");
                                        subscription.update(subscriptionParams)

                                        def currentPlanAmount = subscription.plan.amount
                                        def additionalAmount = (previousPeriodEnd - new Date())*(currentPlanAmount-previousPlanAmount)/30

                                        Map<String, Object> invoiceItemParams = new HashMap<String, Object>();
                                        invoiceItemParams.put("customer", customerId);
                                        invoiceItemParams.put("amount", additionalAmount);
                                        invoiceItemParams.put("currency", "usd");
                                        invoiceItemParams.put("description", 'Upgraded to '+ plan );
                                        InvoiceItem.create(invoiceItemParams);
                                    }
                                    else if(subscription.plan.id == "Standard - User"){

                                        def previousPlanAmount = subscription.plan.amount * subscription.quantity
                                        def previousPeriodEnd = new Date(((long)subscription.currentPeriodEnd) * 1000)

                                        Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                                        subscriptionParams.put("plan", "Premium - User");
                                        subscriptionParams.put("prorate", false);
                                        subscriptionParams.put("quantity", (noOfUsers-5));
                                        subscription.update(subscriptionParams)
                                        isUpdatedAdditionalUser = true

                                        def currentPlanAmount = subscription.plan.amount * subscription.quantity
                                        def additionalAmount = (previousPeriodEnd - new Date())*(currentPlanAmount-previousPlanAmount)/30

                                        Map<String, Object> invoiceItemParams = new HashMap<String, Object>();
                                        invoiceItemParams.put("customer", customerId);
                                        invoiceItemParams.put("amount", additionalAmount);
                                        invoiceItemParams.put("currency", "usd");
                                        invoiceItemParams.put("description", 'Upgraded to Premium - User');
                                        InvoiceItem.create(invoiceItemParams);
                                    }
                                }

                                if(!isUpdatedAdditionalUser && noOfUsers > 5) {

                                    Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                                    additionalUserSubscriptionParams.put("plan", "Premium - User");
                                    additionalUserSubscriptionParams.put("prorate", false);
                                    additionalUserSubscriptionParams.put("quantity", (noOfUsers - 5));
                                    cu.createSubscription(additionalUserSubscriptionParams)
                                }

                            }
                        }



                    }
                } catch (Exception e) {
                    println("There is no such customer. " + e)
                    println("Creating new customer")

                    def customerParams = [
                            'id': customerId,
                            'source'  : token,
                            'description': name
                    ]

                    if(couponId){
                        customerParams.put('coupon', couponId);
                    }

                    print("Creating new customer......*****" + customerParams)
//                    customerParams.object = 'card'
                    Customer.create(customerParams)

                    print("Creating new customer........." + customerParams)

                    Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                    subscriptionParams.put("plan", plan);
                    subscriptionParams.put("prorate", false);
                    subscriptionParams.put("quantity", 1);
                    subscriptionParams.put("trial_end", "now");


                    println("Create subscription....." + subscriptionParams)
                    Customer cu = Customer.retrieve(customerId)
                    cu.createSubscription(subscriptionParams)

                    if(plan == "Standard" && noOfUsers > 2){
                        Integer additionalUser = noOfUsers - 2

                        Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                        additionalUserSubscriptionParams.put("plan", "Standard - User");
                        additionalUserSubscriptionParams.put("prorate", false);
                        additionalUserSubscriptionParams.put("quantity", additionalUser);
                        cu.createSubscription(additionalUserSubscriptionParams)
                    }
                    else if(plan == "Premium" && noOfUsers > 5){
                        Integer additionalUser = noOfUsers - 5

                        Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                        additionalUserSubscriptionParams.put("plan", "Premium - User");
                        additionalUserSubscriptionParams.put("prorate", false);
                        additionalUserSubscriptionParams.put("quantity", additionalUser);
                        cu.createSubscription(additionalUserSubscriptionParams)
                    }
                    else if(plan == "Premium-V2" && noOfUsers > 5){
                        Integer additionalUser = noOfUsers - 5

                        Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                        additionalUserSubscriptionParams.put("plan", "Premium-V2 - User");
                        additionalUserSubscriptionParams.put("prorate", false);
                        additionalUserSubscriptionParams.put("quantity", additionalUser);
                        cu.createSubscription(additionalUserSubscriptionParams)
                    }
                    else if(plan == "Enterprise" && noOfUsers > 5){
                        Integer additionalUser = noOfUsers - 5

                        Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                        additionalUserSubscriptionParams.put("plan", "Enterprise - User");
                        additionalUserSubscriptionParams.put("prorate", false);
                        additionalUserSubscriptionParams.put("quantity", additionalUser);
                        cu.createSubscription(additionalUserSubscriptionParams)
                    }

                    println("Updated subscription")


//                    Subscription.create(subscriptionParams)
                }

//                Charge.create(chargeParams)

//                flash.message = "Successfully charged Stripe"

                println("Successfully charged Stripe")
            }



//            billingService.updateCompanyPayment(session.user.companyId, session.user.username, jsonObject)


        } catch (Exception e) {
//            flash.message = "Something went wrong ..."
            println("Status is: " + e.printStackTrace());
        }


    }



    def upgrade = {
        def jsonObject = request.JSON
        jsonObject.companyId = session.user.companyId
        jsonObject.username = session.user.username
        jsonObject.paidBy = session.user.username

        updateStripe(jsonObject)


        Stripe.apiKey = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        Plan stripePlan = Plan.retrieve(jsonObject.currentPlanDetail);

        Customer cu = Customer.retrieve(jsonObject.companyId);

        for (subs in cu.subscriptions.data){
            def subscription = cu.subscriptions.retrieve(subs.id)
            jsonObject.subscriptionId = subscription.id
            jsonObject.nextPaymentDate = new Date( ((long)subscription.currentPeriodEnd) * 1000 )
        }

        jsonObject.action = "Paid"
        jsonObject.description = "Subscription Fees for " + jsonObject.currentPlanDetail + " plan "
        
        if(jsonObject.currentPlanDetail == 'Standard'){
            jsonObject.amount = (stripePlan.amount/100) + (15 * (jsonObject.NoOfUsers - 2))
        }
        else if(jsonObject.currentPlanDetail == 'Premium'){
            jsonObject.amount = (stripePlan.amount/100) + (20 * (jsonObject.NoOfUsers - 5))
        }
        else if(jsonObject.currentPlanDetail == 'Enterprise'){
            jsonObject.amount = (stripePlan.amount/100) + (99 * (jsonObject.NoOfUsers - 5))
        }

        billingService.upgrade(jsonObject)

    }


    def upgradeCurrentPlan = {
        def jsonObject = request.JSON

        Stripe.apiKey = grailsApplication.config.getProperty('company.billing.stripe.apiKey')
        Plan stripePlan = Plan.retrieve(jsonObject.currentPlanDetail);

        Customer cu = Customer.retrieve(session.user.companyId)

        Boolean isUserUpdated = false

        for (subs in cu.subscriptions.data){
            def subscription = cu.subscriptions.retrieve(subs.id)
            log.info("Plan Id " + subscription)


            if(subscription.plan.id == "Standard"){

                Map<String, Object> subscriptionParams = new HashMap<String, Object>()
                subscriptionParams.put("trial_end", "now")
                subscription.update(subscriptionParams)

            }
            else if(subscription.plan.id == "Premium"){

                Map<String, Object> subscriptionParams = new HashMap<String, Object>()
                subscriptionParams.put("trial_end", "now")
                subscription.update(subscriptionParams)

            }
            else if(subscription.plan.id == "Standard - User"){

                if((jsonObject.NoOfUsers - 2 - subscription.quantity) > 0){

                    Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                    subscriptionParams.put("quantity", (jsonObject.NoOfUsers-2));
                    subscription.update(subscriptionParams)
                    isUserUpdated = true

                    return  billingService.upgradeNoOfUsers(session.user.companyId, jsonObject)
                    break
                }


            }
            else if(subscription.plan.id == "Premium - User"){
                if((jsonObject.NoOfUsers - 5 - subscription.quantity) > 0){
//                    def previousPlanAmount = subscription.plan.amount * subscription.quantity

                    Map<String, Object> subscriptionParams = new HashMap<String, Object>();
                    subscriptionParams.put("quantity", (jsonObject.NoOfUsers-5));
                    subscription.update(subscriptionParams)
                    isUserUpdated = true

                    return  billingService.upgradeNoOfUsers(session.user.companyId, jsonObject)
                    break
                }
            }


        }

        if(isUserUpdated == false){
            if(jsonObject.currentPlanDetail == "Standard" && jsonObject.NoOfUsers > 2){
                Integer additionalUser = jsonObject.NoOfUsers - 2

                Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                additionalUserSubscriptionParams.put("plan", "Standard - User");
                additionalUserSubscriptionParams.put("prorate", false);
                additionalUserSubscriptionParams.put("quantity", additionalUser);
                cu.createSubscription(additionalUserSubscriptionParams)
                return  billingService.upgradeNoOfUsers(session.user.companyId, jsonObject)
            }
            else  if(jsonObject.currentPlanDetail == "Premium" && jsonObject.NoOfUsers > 5){
                Integer additionalUser = jsonObject.NoOfUsers - 5

                Map<String, Object> additionalUserSubscriptionParams = new HashMap<String, Object>();
                additionalUserSubscriptionParams.put("plan", "Premium - User");
                additionalUserSubscriptionParams.put("prorate", false);
                additionalUserSubscriptionParams.put("quantity", additionalUser);
                cu.createSubscription(additionalUserSubscriptionParams)
                return  billingService.upgradeNoOfUsers(session.user.companyId, jsonObject)
            }
        }

        return true
    }


    def upgradeNoOfUsers = {
        def jsonObject = request.JSON
        respond billingService.upgradeNoOfUsers(session.user.companyId, jsonObject)

    }

   ////new

//    def upgradeIndividualToStandard = {
//        def jsonObject = request.JSON
//        billingService.updateNoOfUsers(session.user.companyId, jsonObject)
//        billingService.updateCompanyBilling(session.user.companyId, jsonObject)
//        billingService.updateCompanyCreditCard(session.user.companyId, session.user.username, jsonObject)
//        billingService.updateCompanyPayment(session.user.companyId, session.user.username, jsonObject)
//
//    }


}
