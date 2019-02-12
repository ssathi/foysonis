package com.foysonis.inventory

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class InventorySummaryController extends RestfulController<InventorySummary> {

    def inventorySummaryService
    def springSecurityService

    static responseFormats = ['json', 'xml']

    InventorySummaryController() {
        super(InventorySummary)
    }

    def index() { }


    def getAllInventorySummary = {
        respond inventorySummaryService.getAllInventorySummary(springSecurityService.currentUser.companyId)
    }
}
