package com.foysonis.item

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class ListValueController extends RestfulController<ListValue>   {

    def listValueService

    static responseFormats = ['json', 'xml']

    ListValueController() {
        super(ListValue)
    }

    def getAllValuesByCompanyIdAndGroup = {
        respond listValueService.getAllValuesByCompanyIdAndGroup(session.user.companyId, params['group'])
    }

    def getAllListValueByOptionValues = {
    	respond listValueService.getAllListValueByOptionValues(session.user.companyId, params['optionGroup'], params['optionValue'])
    }
    def getAllListValueByDescription = {
    	respond listValueService.getAllListValueByDescription(session.user.companyId, params['optionGroup'], params['description'])
    }
    def getBOMInstructionType={
        respond listValueService.getBOMInstructionType()
    }
}

