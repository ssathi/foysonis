package com.foysonis.item

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql
import com.foysonis.inventory.InventoryAdjustment
import com.foysonis.orders.Orders
import com.foysonis.area.Area
import com.foysonis.orders.Shipment
import com.foysonis.inventory.Inventory
import com.foysonis.receiving.ReceiveInventory
import com.foysonis.picking.CancelledPick

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class SettingsController extends RestfulController<ListValue>{

	def listValueService
	def sessionFactory
	def springSecurityService
	def billingService

    static responseFormats = ['json', 'xml']
 
    SettingsController() {
        super(ListValue)
    }	


    def adminListValue() {
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
		def pageTitle = "Configuration";
		[pageTitle:pageTitle]
	}

    def getAllStorageAreasByCompany(){
    	respond listValueService.getAllStorageAreasByCompany(session.user.companyId)
    }

    def getAllPickableAreasByCompany(){
    	respond listValueService.getAllPickableAreasByCompany(session.user.companyId)
    }


    def getAllListValuesByCompanyId(){
    	respond listValueService.getAllListValuesByCompanyId(session.user.companyId)
    }

    def getAllOptionGroupsByCompanyId(){
        //def sql = new Sql(sessionFactory.currentSession.connection())
        //def rows = sql.rows("SELECT DISTINCT option_group as optionGroup FROM list_value WHERE company_id = 'all' OR company_id = ?", session.user.companyId)
        def optionGroup = []
        def optionGroupObj = [:]
        optionGroup.add(optionGroup:"ADJREASON")
        optionGroup.add(optionGroup:"STRG")
        optionGroup.add(optionGroup:"ITEMCAT")
        optionGroup.add(optionGroup:"RSHSP")

        //def xxx =  [{optionGroup:"ADJREASON"},{optionGroup:"STRG"},{optionGroup:"ITEMCAT"},{optionGroup:"RSHSP"}]
        respond optionGroup
    }

	def getAllValuesByCompanyIdAndGroup(){
		respond listValueService.getAllValuesByCompanyIdAndGroup(session.user.companyId, params.group)
	}    


	def savePutawayOrder(){
		def jsonObject = request.JSON

		respond listValueService.savePutawayOrder(session.user.companyId,jsonObject)
	}

	def resetPutawayOrder(){

		def jsonObject = request.JSON

		respond listValueService.resetPutawayOrder(session.user.companyId,jsonObject)		
	
	}

	def saveAllocationOrder(){
		def jsonObject = request.JSON

		respond listValueService.saveAllocationOrder(session.user.companyId,jsonObject)
	}

	def resetAllocationOrder(){

		def jsonObject = request.JSON

		respond listValueService.resetAllocationOrder(session.user.companyId,jsonObject)		
	
	}
	

	def findListValueExist(){
		if (params.optionGroup == 'ADJREASON') {
			respond InventoryAdjustment.findAllByCompanyIdAndReasonCode(session.user.companyId, params.optionValue)

		}

		else if  (params.optionGroup == 'ITEMCAT') {
			respond Item.findAllByCompanyIdAndItemCategory(session.user.companyId, params.optionValue)

		}	
		else if  (params.optionGroup == 'RSHSP') {
			respond Orders.findAllByCompanyIdAndRequestedShipSpeed(session.user.companyId, params.optionValue)

		}
		else if  (params.optionGroup == 'STRG') {
			respond EntityAttribute.findAllByCompanyIdAndConfigValue(session.user.companyId, params.optionValue)

		}
		else if  (params.optionGroup == 'CARRCODE') {
			respond Shipment.findAllByCompanyIdAndCarrierCode(session.user.companyId, params.optionValue)
		}
		else if  (params.optionGroup == 'INVSTATUS') {
			def invstatusExistingRaws = Inventory.findAllByCompanyIdAndInventoryStatus(session.user.companyId, params.optionValue)
			if (invstatusExistingRaws.size() == 0) {
				respond Inventory.findAllByCompanyIdAndInventoryStatus(session.user.companyId, params.optionValue)
			}
			else{
				respond invstatusExistingRaws
			}
		}
		else if (params.optionGroup == 'CPR') {
			respond CancelledPick.findAllByCompanyIdAndReason(session.user.companyId, params.optionValue)
		}										
	}

    def saveListValue(){
        def jsonObject = request.JSON
        respond listValueService.saveListValue(session.user.companyId, jsonObject)
    }   


    def updateListValue(){
        def jsonObject = request.JSON

        respond listValueService.updateListValue(session.user.companyId, jsonObject)
    }


    def deleteListValue(){
    	def jsonObject = request.JSON
    	respond listValueService.deleteListValue(session.user.companyId, jsonObject)
    }
    
    def updateWarehouseConfig = {
    	def jsonObject = request.JSON
        respond listValueService.updateWarehouseConfig(session.user.companyId, jsonObject)
    }

}
