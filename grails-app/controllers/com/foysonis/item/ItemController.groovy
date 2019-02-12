package com.foysonis.item

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import com.foysonis.billing.CompanyBilling
import groovy.sql.Sql

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class ItemController extends RestfulController<Item> {

    def itemService
    def listValueService
    def sessionFactory
    def springSecurityService
    def billingService


    static responseFormats = ['json', 'xml']

    ItemController() {
        super(Item)
    }

    def adminItemList() {

        def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
        if (billingData) {
            def trialEndDate = null
            use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
            if (billingData.isTrial == true && trialEndDate < new Date()) {

                if(springSecurityService.currentUser.adminActiveStatus == true){
                    redirect(controller:"userAccount",action:"index")
                    return
                }
                else{
                    redirect(controller:"userAccount",action:"index")
                    return
                }


            }
            else if(springSecurityService.currentUser.isTermAccepted != true){
                redirect(controller:"userAccount",action:"index")
                return
            }
        }
        else if(springSecurityService.currentUser.isTermAccepted != true){
            redirect(controller:"userAccount",action:"index")
            return
        }

        session.user = springSecurityService.currentUser
        def pageTitle = "Items";
        [pageTitle:pageTitle]

    }

    def getItems = {

        def keyItemId = '%'+params.keyword+'%'
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows("SELECT item_id as locationId, item_description as shippingStreetAddress FROM item WHERE company_id = '${session.user.companyId}' AND (item_id LIKE '${keyItemId}' OR upc_code LIKE '${keyItemId}' OR item_description LIKE '${keyItemId}') LIMIT 10 ")
        respond rows
    }

    def checkItemIdExist = {
        respond itemService.checkItemIdExist(session.user.companyId, params['itemId'])
    }

    def findItem ={
        respond itemService.checkItemIdExist(session.user.companyId, params['itemId'])
    }


    def getOriginCodes = {
        respond listValueService.getOriginCodes();
    }

    def getOriginCodeForCountries = {
        respond listValueService.getOriginCodeForCountries();
    }


    def getAllValuesByCompanyIdAndGroup = {
        respond listValueService.getAllValuesByCompanyIdAndGroup(session.user.companyId, params['group'])
    }


    def searchResults () {
        respond itemService.searchResults(session.user.companyId, params.itemId, params.itemDescription, params.itemCategory, params.isLotTracked, params.isExpired , params.isCaseTracked, params.configValue)
    }

    def getItemEntityAttributeForSearchRow(){
        respond itemService.getItemEntityAttributeForSearchRow(session.user.companyId, params.selectedRowItem)
    }

    def addItemCategoryValues(){

        def jsonObject = request.JSON
        def listValue = new ListValue(jsonObject)
        listValue.properties = [companyId :session.user.companyId,
                                createdDate:new Date(),
                                displayOrder:0  ]

        def listValueIndex = 000
        String optionValue = "001"
        ListValue listval = ListValue.find("from ListValue as l where l.companyId='${session.user.companyId}' AND l.optionGroup = '${jsonObject.optionGroup}' order by createdDate DESC")

        if (listval) {
            optionValue = listval.optionValue + 1
        }

        listValue.optionValue = optionValue
        respond listValue.save(flush: true, failOnError: true)
    }


    def checkStorageAttributesOfAreas(){

        respond itemService.checkStorageAttributesOfAreas(session.user.companyId, params.storageAttrList)

    }

    def getAllStorageAttributeOfItem = {

        def strorageAttributesOfItem = itemService.getAllStorageAttributeOfItem(session.user.companyId,params.itemId)
        respond strorageAttributesOfItem
        //render strorageAttributesOfItem
    }


    def save() {

        def jsonObject = request.JSON
        def item = new Item(jsonObject)


        item.companyId = session.user.companyId

        if (jsonObject.itemCategory != null && jsonObject.itemCategory != "") {
            def listvalueConfigValue = ListValue.find("from ListValue where (companyId = '${session.user.companyId}' or companyId = 'ALL') and description ='${jsonObject.itemCategory}' and optionGroup = 'ITEMCAT'")
            item.itemCategory = listvalueConfigValue.optionValue
        }


        if (item.isLotTracked == null) {
            item.isLotTracked = false
        }

        if (item.isExpired == null) {
            item.isExpired = false
        }

        if (item.isCaseTracked == null) {
            item.isCaseTracked = false
        }
        if(item.lowestUom == 'PALLET'){
            item.isCaseTracked = false
            item.eachesPerCase = null
            item.casesPerPallet = null
        }

        item.reorderLevelQuantity = jsonObject.reOrderLevelQty

        //itemService.removeEntityAttributesByConfigKey(session.user.companyId, jsonObject.itemId);
        def responseMsg = [:]
        int itemMaxLimitFromApp = grailsApplication.config.getProperty('company.paymentPlan.individual.itemMaxLimit').toInteger()
        def companyBillData = CompanyBilling.findByCompanyId(session.user.companyId)
        def totalItemCount = Item.countByCompanyId(session.user.companyId)
        if (companyBillData && companyBillData.currentPlanDetail == 'Individual' && totalItemCount >=itemMaxLimitFromApp) {
            println 'gone inside'
            println itemMaxLimitFromApp
            responseMsg.status = 'error'
            responseMsg.message =  message(code: "company.paymentPlan.itemMaxLimit.message", args: [itemMaxLimitFromApp])
            respond responseMsg
        }
        else{
            def sortNumber = 1
            for (storageAttributes in jsonObject.storageAttributes.optionValue) {
                def entityAttribute = new EntityAttribute()
                entityAttribute.companyId = session.user.companyId
                entityAttribute.entityId = 'ITEM'
                entityAttribute.configKey = jsonObject.itemId
                entityAttribute.configGroup = 'STRG'
                entityAttribute.configValue = storageAttributes
                entityAttribute.sortSequence = sortNumber

                entityAttribute.save(flush: true, failOnError: true)

                sortNumber++
            }

            if (jsonObject.itemImage) {
                def imageFolderPath = servletContext.getRealPath('/images')
                String imageFilePath = itemService.uploadImageFile(session.user.companyId, jsonObject.itemImage, "png", jsonObject.itemId, imageFolderPath) 
                item.imagePath = imageFilePath                
            }

            item.save(flush: true, failOnError: true)
            responseMsg.status = 'success'
            responseMsg.data = item
            respond responseMsg                               
        }

    }



    def updateItem() {
        def jsonObject = request.JSON

        def item = Item.findByCompanyIdAndItemId(session.user.companyId, jsonObject.itemId);

        if (item) {

            item.properties = [itemDescription:jsonObject.itemDescription,
                               lowestUom:jsonObject.lowestUom,
                               isLotTracked:jsonObject.isLotTracked,
                               isExpired:jsonObject.isExpired,
                               isCaseTracked:jsonObject.isCaseTracked,
                               originCode:jsonObject.originCode,
                               eachesPerCase:jsonObject.eachesPerCase,
                               casesPerPallet:jsonObject.casesPerPallet,
                               upcCode:jsonObject.upcCode,
                               eanCode:jsonObject.eanCode,
                               itemCategory:jsonObject.itemCategory,
                               reorderLevelQuantity:jsonObject.reorderLevelQty ]

        }

        else{
            item = new Item(jsonObject)
            item.companyId = session.user.companyId
        }


        if (jsonObject.itemCategory != null) {
           def listvalueConfigValue = ListValue.find("from ListValue where (companyId = '${session.user.companyId}' or companyId = 'ALL') and description ='${jsonObject.itemCategory}' and optionGroup = 'ITEMCAT'")
            item.itemCategory = listvalueConfigValue.optionValue
        }


        if (item.isLotTracked == null) {
            item.isLotTracked = false
        }

        if (item.isExpired == null) {
            item.isExpired = false
        }

        if (item.isCaseTracked == null) {
            item.isCaseTracked = false
        }
        if(item.lowestUom == 'PALLET'){
            item.isCaseTracked = false
            item.eachesPerCase = null
            item.casesPerPallet = null
        }


        itemService.removeEntityAttributesByConfigKey(session.user.companyId, jsonObject.itemId);

        def sortNumber = 1
        for (storageAttributes in jsonObject.storageAttributes.configValue) {
            def entityAttribute = new EntityAttribute()
            entityAttribute.companyId = session.user.companyId
            entityAttribute.entityId = 'ITEM'
            entityAttribute.configKey = jsonObject.itemId
            entityAttribute.configGroup = 'STRG'
            entityAttribute.configValue = storageAttributes
            entityAttribute.sortSequence = sortNumber

            entityAttribute.save(flush: true, failOnError: true)

            sortNumber++
        }

        if (jsonObject.itemImage) {
            println"into images"
            def parts = jsonObject.itemImage.tokenize(",");
            if (parts.size() == 2) {
                println"into images upload"
                def imageFolderPath = servletContext.getRealPath('/images')
                String imageFilePath = itemService.uploadImageFile(session.user.companyId, jsonObject.itemImage, "png", jsonObject.itemId, imageFolderPath) 
                item.imagePath = imageFilePath
            }
        }

        item.save(flush: true, failOnError: true)

    }

    def findInventoryOfItemId = {
        respond itemService.findInventoryOfItemId(session.user.companyId,params.itemId)
    }

    def deleteItem = {
        def jsonObject = request.JSON
        def item = Item.findByCompanyIdAndItemId(session.user.companyId, jsonObject.itemId)
        if (item) {


            def entityAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKey(session.user.companyId, "ITEM", jsonObject.itemId)

            if (entityAttributes.size()>0) {

                for (entity in entityAttributes){
                    entity.delete(flush: true, failOnError: true)
                }

            }

            item.delete(flush: true, failOnError: true)
            def imageFolderPath = servletContext.getRealPath('/images')
            respond itemService.deleteImageFile(session.user.companyId, "png",  jsonObject.itemId, imageFolderPath)  
            respond jsonObject



        }
        // respond itemService.deleteItem(jsonObject.companyId, jsonObject.item_id)
    }


    //
    def importItem() {
        def jsonObject = request.JSON

        def responseMsg = [:]
        def companyBillData = CompanyBilling.findByCompanyId(session.user.companyId)
        def totalItemCount = Item.countByCompanyId(session.user.companyId)
        if (companyBillData && companyBillData.currentPlanDetail == 'Individual') {
            int itemMaxLimitFromApp = grailsApplication.config.getProperty('company.paymentPlan.individual.itemMaxLimit').toInteger()
                if (jsonObject.size()>=itemMaxLimitFromApp) {
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.itemMaxLimit.message", args: [itemMaxLimitFromApp])
                    respond responseMsg                    
                }
                else if (totalItemCount >=itemMaxLimitFromApp) {                   
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.itemMaxLimit.message", args: [itemMaxLimitFromApp])
                    respond responseMsg                    
                }
                
                else if ((totalItemCount + jsonObject.size()) >=itemMaxLimitFromApp) {                 
                    responseMsg.status = 'error'
                    responseMsg.message = message(code: "company.paymentPlan.itemMaxLimit.message", args: [itemMaxLimitFromApp])
                    respond responseMsg
                }
                else{
                    for (jsonObject1 in jsonObject) {
                        def item = new Item()
                        item.companyId = session.user.companyId
                        item.itemId = jsonObject1[0]
                        item.itemDescription = jsonObject1[1]
            //            item.itemCategory = jsonObject1[2]
                        item.isLotTracked = jsonObject1[3].toBoolean()
                        item.isExpired = jsonObject1[4].toBoolean()
                        item.isCaseTracked = jsonObject1[5].toBoolean()
                        item.lowestUom = jsonObject1[6]
                        item.originCode = jsonObject1[7]
                        item.eachesPerCase = jsonObject1[8].toInteger()
                        item.casesPerPallet = jsonObject1[9].toInteger()
                        item.upcCode = jsonObject1[10]
                        item.eanCode = jsonObject1[11]

                        if(jsonObject1[2]){

                            def listvalueConfigValue = ListValue.find("from ListValue where (companyId = '${session.user.companyId}' or companyId = 'ALL') and description ='${jsonObject1[2]}' and optionGroup = 'ITEMCAT'")
                            item.itemCategory = listvalueConfigValue.optionValue
                        }


                        if (jsonObject1[12]) {

                            def sortNumber = 1
                            Set<String> storageAttributes = Arrays.asList(jsonObject1[12].split("\\s*,\\s*"));

                            for (storageAttribute in storageAttributes) {
                                def entityAttribute = new EntityAttribute()
                                entityAttribute.companyId = session.user.companyId
                                entityAttribute.entityId = 'ITEM'
                                entityAttribute.configKey = jsonObject1[0]
                                entityAttribute.configGroup = 'STRG'
                                entityAttribute.configValue = storageAttribute
                                entityAttribute.sortSequence = sortNumber

                                entityAttribute.save(flush: true, failOnError: true)

                                sortNumber++
                            }
                            
                        }

                        item.save(flush: true, failOnError: true)
                    }
                    responseMsg.status = 'success'
                    respond responseMsg                
                }
        }
        else{
            for (jsonObject1 in jsonObject) {
                def item = new Item()
                item.companyId = session.user.companyId
                item.itemId = jsonObject1[0]
                item.itemDescription = jsonObject1[1]
    //            item.itemCategory = jsonObject1[2]
                item.isLotTracked = jsonObject1[3].toBoolean()
                item.isExpired = jsonObject1[4].toBoolean()
                item.isCaseTracked = jsonObject1[5].toBoolean()
                item.lowestUom = jsonObject1[6]
                item.originCode = jsonObject1[7]
                item.eachesPerCase = jsonObject1[8].toInteger()
                item.casesPerPallet = jsonObject1[9].toInteger()
                item.upcCode = jsonObject1[10]
                item.eanCode = jsonObject1[11]

                if(jsonObject1[2]){

                    def listvalueConfigValue = ListValue.find("from ListValue where (companyId = '${session.user.companyId}' or companyId = 'ALL') and description ='${jsonObject1[2]}' and optionGroup = 'ITEMCAT'")
                    if (listvalueConfigValue) {
                        item.itemCategory = listvalueConfigValue.optionValue
                    }
                    else {


                        def generatedOptVal = returnOptionValueNum(session.user.companyId, 'ITEMCAT')

                        def listValue = new ListValue()

                        listValue.properties = [companyId   : session.user.companyId,
                                                optionGroup : 'ITEMCAT',
                                                optionValue : generatedOptVal,
                                                description : jsonObject1[2],
                                                displayOrder: generatedOptVal,
                                                createdDate : new Date()]

                        listValue.save(flush: true, failOnError: true) 
                        item.itemCategory = generatedOptVal
                    }
                    
                }


                if (jsonObject1[12]) {

                    def sortNumber = 1
                    Set<String> storageAttributes = Arrays.asList(jsonObject1[12].split("\\s*,\\s*"));

                    for (storageAttribute in storageAttributes) {
                        def entityAttribute = new EntityAttribute()
                        entityAttribute.companyId = session.user.companyId
                        entityAttribute.entityId = 'ITEM'
                        entityAttribute.configKey = jsonObject1[0]
                        entityAttribute.configGroup = 'STRG'
                        entityAttribute.configValue = storageAttribute
                        entityAttribute.sortSequence = sortNumber

                        entityAttribute.save(flush: true, failOnError: true)

                        sortNumber++
                    }

                }

                item.save(flush: true, failOnError: true)
            }
            responseMsg.status = 'success'
            respond responseMsg                
        }

    }

    def returnOptionValueNum(companyId, optionGroupVal) {
        def optionValueExist = ListValue.find("from ListValue where companyId='${companyId}' AND optionGroup = '${optionGroupVal}' AND optionValue > 0 order by ABS(optionValue) DESC")
        if (!optionValueExist) {
            return "001"
        }
        else{
            def optionValue = optionValueExist.optionValue
            def intIndex = optionValue.toInteger()
            intIndex = intIndex + 1
            def stringIndex = intIndex.toString().padLeft(3,"0")
            return stringIndex
        }        
    }

    def downloadItemCsvFile = {
        def reportPath = servletContext.getRealPath('/sampleCSV/')
        def file = new File(reportPath+"/"+"itemSampleCsv.csv")

        if (file.exists()) {
           response.setContentType("application/octet-stream")
           response.setHeader("Content-disposition", "filename=${file.name}")
           response.outputStream << file.bytes
           return
        }        
    }

    def getLowestUom = {
        respond itemService.getLowestUom(session.user.companyId, params.itemId)
    }

    def deleteImageFile = {
        def imageFolderPath = servletContext.getRealPath('/images')
        respond itemService.deleteImageFile(session.user.companyId, "png",  params.itemId, imageFolderPath)   
    }

}

