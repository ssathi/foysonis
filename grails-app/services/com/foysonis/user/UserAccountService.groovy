package com.foysonis.user

import grails.transaction.Transactional

@Transactional
class UserAccountService {

    def springSecurityService

    def passwordEncoder

    def getUser(username, companyId) {
        return User.findByUsernameAndCompanyId(username, companyId)
    }

    def updateUserProfile(companyData, username, companyId){
        def user = User.findByUsernameAndCompanyId(username, companyId)
        user.firstName = companyData.firstName
        user.lastName = companyData.lastName
        user.email = companyData.email
        user.password = companyData.password
        if (companyData.defaultPrinter && companyData.defaultPrinter.id) {
            println '111111111111111111111111111' 
           user.defaultPrinterId = companyData.defaultPrinter.id 
        }
        else {
            user.defaultPrinterId = null
        }
        if (companyData.labelPrinter && companyData.labelPrinter.id) {
            println '2222222222222222222222222'
            user.labelPrinterId = companyData.labelPrinter.id
        }
        else { 
            user.labelPrinterId = null
        }
        

        if (companyData.userImage) {
            user.userImage = companyData.userImage.bytes
        }

        user.save(flush:true, failOnError:true)
    }

    def checkPasswordExist(username, password, companyId){
        def user = User.findByUsernameAndCompanyId(username, companyId)
        if(passwordEncoder.isPasswordValid(user.password, password, null) ){
            return [result: true];
        } else{
            return [result: false];
        }
   }


    def updateUserPassword(companyData,username, companyId){
        def user = User.findByUsernameAndCompanyId(username, companyId)
        user.password = companyData.password
        user.save(flush:true, failOnError:true)
    }

    def updateTermAccepted(companyId, username) {
        User user =  User.findWhere(companyId: companyId, username: username)
        user.isTermAccepted = true
        return user.save(flush: true, failOnError: true)
    }

    def updateLogEnabled(String companyId, String username, isLogEnabled) {
        User user =  User.findWhere(companyId: companyId, username: username)
        user.isLogEnabled = isLogEnabled
        return user.save(flush: true, failOnError: true)
    }


}
