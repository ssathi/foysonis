package com.foysonis.integration

import com.easypost.EasyPost
import com.easypost.exception.EasyPostException
import com.easypost.model.Address
import com.easypost.model.Parcel
import com.easypost.model.Rate
import com.easypost.model.Shipment
import com.foysonis.user.Company
import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController

@Secured("permitAll")
class IntegrationController extends RestfulController<Company> {

    static responseFormats = ['json', 'xml']
    def easyPostService;
    def springSecurityService;

    IntegrationController() {
        super(Company)
    }

    def index() {

        EasyPost.apiKey = "6Z0IeVMC1593pZVG48gTnA";

        Map<String, Object> fromAddressMap = new HashMap<String, Object>();
        fromAddressMap.put("name", "Srikaran Ariyakumar");
        fromAddressMap.put("street1", "321 S Bickett Blvd");
        fromAddressMap.put("street2", "Louisburg");
        fromAddressMap.put("city", "San Francisco");
        fromAddressMap.put("state", "NC");
        fromAddressMap.put("zip", "27549");
        fromAddressMap.put("phone", "415-456-7890");
        fromAddressMap.put("company", "Foysonis");
        fromAddressMap.put("company", "info@foysonis.com");

        Map<String, Object> toAddressMap = new HashMap<String, Object>();
        toAddressMap.put("name", "Mayooran Somasundaram");
        toAddressMap.put("street1", "209 katie court");
        toAddressMap.put("street2", "Falls Church");
        toAddressMap.put("city", "St. Albert");
        toAddressMap.put("state", "VA");
        toAddressMap.put("zip", "22046");
        toAddressMap.put("phone", "780-483-2746");
        toAddressMap.put("country", "US");

        Map<String, Object> parcelMap = new HashMap<String, Object>();
        parcelMap.put("weight", 22.9);
        parcelMap.put("height", 12.1);
        parcelMap.put("width", 8);
        parcelMap.put("length", 19.8);


        try {
            Address fromAddress = Address.create(fromAddressMap);
            Address toAddress = Address.create(toAddressMap);
            Parcel parcel = Parcel.create(parcelMap);



            Address verifiedFromAddress = fromAddress.verify();
            Address verifiedToAddress = toAddress.verify();

//            log.info("From address verification : " + verifiedFromAddress.prettyPrint())
//            log.info("To address verification : " + verifiedToAddress.prettyPrint())

            // create shipment
            Map<String, Object> shipmentMap = new HashMap<String, Object>();
            shipmentMap.put("to_address", toAddress);
            shipmentMap.put("from_address", fromAddress);
            shipmentMap.put("parcel", parcel);

            Shipment shipment = Shipment.create(shipmentMap);

            List<Rate> availableRates = shipment.rates
            log.info("Number of available rates." + availableRates.size())

            List<String> buyServices = new ArrayList<String>();
            List<String> buyCarriers = new ArrayList<String>();

            for (Rate rate: availableRates){
                log.info("Available rate: carriers - " + rate.carrier + ", service level -" + rate.service )
                buyCarriers.add(rate.carrier);
                buyServices.add(rate.service);
            }
//            println("------" + shipment.rates)

            // buy postage

/*            buyCarriers.add("USPS");

            buyServices.add("Standard Post");*/

            Rate lowestRate = shipment.lowestRate(buyCarriers, buyServices)
            log.info("Lowest rate...." + lowestRate.prettyPrint())

            shipment = shipment.buy(shipment.lowestRate(buyCarriers, buyServices));

            System.out.println(shipment.prettyPrint());

        } catch (EasyPostException e) {
            e.printStackTrace();

        }

        render "Hello"
    }

    def refund(){
        EasyPost.apiKey = "6Z0IeVMC1593pZVG48gTnA";
    }
}
