package com.foysonis.easypost

import com.easypost.EasyPost
import com.easypost.exception.EasyPostException
import com.easypost.model.*
import com.foysonis.easypost.CarrierAccount
import com.foysonis.orders.Customer
import com.foysonis.orders.CustomerAddress
import com.foysonis.user.Company
import grails.transaction.Transactional
import org.grails.web.json.JSONObject

@Transactional
class EasyPostService {

    def getTestApiKey(String companyId) {
        Company company = Company.findByCompanyId(companyId);
        if (company) {
            return [easyPostTestApiKey: company.easyPostTestApiKey.toString()];
        } else {
            return [easyPostTestApiKey: ""];
        }
    }

    def getProdApiKey(String companyId) {
        Company company = Company.findByCompanyId(companyId);
        if (company) {
            return [easyPostProdApiKey: company.easyPostProdApiKey.toString()];
        } else {
            return [easyPostProdApiKey: ""];
        }
    }

    def validateProdKey(String prodKey) {
        Boolean isValid = false;
        EasyPost.apiKey = prodKey;
        try {
            ApiKeys parentKeys = ApiKeys.all()
            for (ApiKey k : parentKeys.keys) {
                if (k.key == prodKey) {
                    isValid = true;
                    break;
                }
            }
        } catch (Exception e) {
            EasyPostException exception = (EasyPostException) e
            println('Easypost api key validatin ' + e)
            if (exception.localizedMessage.contains("UNAUTHORIZED")) {
                isValid = false
            } else {
                isValid = true;
            }

        }
        return [isValid: isValid];
    }

    def validateTestKey(String testKey) {
        Boolean isValid = false;
        EasyPost.apiKey = testKey;
        try {
            Map<String, Object> list_params = new HashMap<>();
            list_params.put("page_size", 2);
            ShipmentCollection shipments = Shipment.all(list_params);
            isValid = true;
        } catch (Exception e) {
            EasyPostException exception = (EasyPostException) e
            if (exception.localizedMessage.contains("UNAUTHORIZED")) {
                isValid = false
            } else {
                isValid = true;
            }
        }
        return [isValid: isValid];
    }

    def findAllCarriers() {
        return CarrierAccount.findAll()
    }

    def findServiceLevelByCarrier(String carrier) {
        return ServiceLevel.findAllByCarrierAccountId(carrier).description
    }


    def performEasyPost(companyId, shippingAddressId, carrierCode, serviceLevel, easyPostWeight, shipmentId) {

        Company company = Company.findByCompanyId(companyId)

        EasyPost.apiKey = company.easyPostProdApiKey;

        def customerAddress = CustomerAddress.findByCompanyIdAndId(companyId, shippingAddressId)
        def customer = Customer.findByCompanyIdAndCustomerId(companyId, customerAddress.customerId)

        Map<String, Object> toAddressMap = new HashMap<String, Object>();
        toAddressMap.put("name", customer.contactName);
        toAddressMap.put("street1", customerAddress.streetAddress);
        //toAddressMap.put("street2", "");
        toAddressMap.put("city", customerAddress.city);   Map<String, Object> fromAddressMap = new HashMap<String, Object>();
        toAddressMap.put("state", customerAddress.state);
        toAddressMap.put("zip", customerAddress.postCode);
        toAddressMap.put("phone", customer.phonePrimary);
        toAddressMap.put("country", customerAddress.country);

        fromAddressMap.put("name", company.name);
        fromAddressMap.put("street1", company.companyBillingStreetAddress);
//        fromAddressMap.put("street2", "Apt 20");
        fromAddressMap.put("city", company.companyBillingCity);
        fromAddressMap.put("state", company.companyBillingState);
        fromAddressMap.put("zip", company.companyBillingPostCode);
        fromAddressMap.put("phone", company.phoneNumber);
        fromAddressMap.put("country", "us");

        println"fromAddressMap-----------------" +fromAddressMap 

        Map<String, Object> parcelMap = new HashMap<String, Object>();
        parcelMap.put("weight", easyPostWeight.toDouble());

        def systemShipment = com.foysonis.orders.Shipment.findByCompanyIdAndShipmentId(companyId,shipmentId)
        if (systemShipment) {
            systemShipment.actualWeight = easyPostWeight.toDouble()
            systemShipment.save(flush: true, failOnError: true)
        }        

        try {
            Address fromAddress = Address.create(fromAddressMap);
            Address toAddress = Address.create(toAddressMap);
            Parcel parcel = Parcel.create(parcelMap);

            Address verified = fromAddress.verify();
            //println "from address-------------" +verified.prettyPrint()

            // create shipment
            Map<String, Object> shipmentMap = new HashMap<String, Object>();
            shipmentMap.put("to_address", toAddress);
            shipmentMap.put("from_address", fromAddress);
            shipmentMap.put("parcel", parcel);

            Shipment shipment = Shipment.create(shipmentMap);

            List<Rate> rateList = shipment.rates;
            List<String> availableCarriers = new ArrayList<>();
            List<String> availableServices = new ArrayList<>();

            def splitText = "-EasyPost"
            String selectedCarrier = carrierCode - splitText
            String selectedService = serviceLevel;

            Rate selectedRate = null;
            for (Rate rate : rateList) {
                availableCarriers.add(rate.carrier);
                availableServices.add(rate.service);
                if (rate.carrier == selectedCarrier && rate.service == selectedService) {
                    selectedRate = rate;
                    break;
                }
            }

            println("available carrier " + availableCarriers)
            println("available service level " + availableServices)

            // buy postage
            if (selectedRate != null) {
                shipment = shipment.buy(selectedRate);

                Shipment sh = Shipment.retrieve(shipment.id);

                Map<String, Object> params = new HashMap<String, Object>();
                params.put("file_format", "PDF");
                Shipment s = sh.label(params);
                String label = s.postageLabel.labelPdfUrl;
                String easyPostShipmentId = shipment.id;
                Boolean easyPostManifested = true;
                return [isSuccess: true, easypost_label: label, easyPostShipmentId:easyPostShipmentId,
                        easyPostManifested:easyPostManifested, trackingCode:sh.trackingCode,
                        message: 'This shipment has been manifested through EasyPost'];
            } else {
                // TODO: show error message and let user to edit the service level and carrier code..
                return [isSuccess: false, message: 'The carrier code or service level you selected is not applicable for this shipment'];
            }


        } catch (EasyPostException ex) {

            String error = ex.message.substring(ex.message.indexOf("{"),ex.message.length());
            JSONObject json = new JSONObject(error)
            String actualMessage = json.getJSONObject("error").getString("message");
            println("Error occurred in EasyPost : " + actualMessage)
            return [isSuccess: false, message: actualMessage];
        }
    }


    def refund(String companyId, String shipmentId, String systemShipmentId) {
        Company company = Company.findByCompanyId(companyId)
        EasyPost.apiKey = company.easyPostProdApiKey;

        try {
            Shipment shipment = Shipment.retrieve(shipmentId);
            shipment.refund();
            def systemShipment = com.foysonis.orders.Shipment.findByCompanyIdAndShipmentId(companyId, systemShipmentId)
            if (systemShipment) {
                systemShipment.easyPostManifested = false
                systemShipment.easyPostShipmentId = null
                systemShipment.easyPostLabel = null
                systemShipment.save(flush: true, failOnError: true)
            }            
            return [isSuccess: true, message: 'The refund request has been sent to EasyPost']
        } catch (Exception ex) {
            println("Error occurred " + ex)
            if(ex instanceof EasyPostException){
                String error = ex.message.substring(ex.message.indexOf("{"),ex.message.length());
                JSONObject json = new JSONObject(error)
                String actualMessage = json.getJSONObject("error").getString("message");
                println("Error occurred in EasyPost : " + actualMessage)
                return [isSuccess: false, message: actualMessage]
            } else {
                return [isSuccess: false, message: "Unable to request refund!"]
            }
        }

    }

}
