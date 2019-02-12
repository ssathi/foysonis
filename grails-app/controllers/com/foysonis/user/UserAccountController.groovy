package com.foysonis.user

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController
import groovy.sql.Sql

@Secured(['ROLE_USER','ROLE_ADMIN'])
class UserAccountController extends RestfulController<User> {

    def userAccountService
    def sessionFactory
    def springSecurityService
    def userService

    static responseFormats = ['json', 'xml']

    UserAccountController() {
        super(User)
    }

    def index() {
        session.user = springSecurityService.currentUser
        def pageTitle = "User Account";
        [pageTitle:pageTitle]

    }

    def getUser = {
        session.user = springSecurityService.currentUser
        respond userAccountService.getUser(session.user.username, session.user.companyId)
    }

    def updateUserProfile = {
        session.user = springSecurityService.currentUser
        def jsonObject = request.JSON
        respond userAccountService.updateUserProfile(jsonObject,session.user.username, session.user.companyId)

    }

    def checkPasswordExist() {
        session.user = springSecurityService.currentUser
        respond userAccountService.checkPasswordExist(params['username'], params['password'], session.user.companyId)
    }


    def updateUserPassword = {
        session.user = springSecurityService.currentUser
        def jsonObject = request.JSON
        respond userAccountService.updateUserPassword(jsonObject,session.user.username, session.user.companyId)

    }

    def updateTermAccepted= {
        respond userAccountService.updateTermAccepted(session.user.companyId, session.user.username)
    }

    def updateLogEnabled= {
        respond userAccountService.updateLogEnabled(session.user.companyId, session.user.username, params['isLogEnabled'])
    }



}
