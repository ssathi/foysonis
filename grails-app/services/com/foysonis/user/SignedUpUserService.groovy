package com.foysonis.user

import grails.converters.JSON
import grails.transaction.Transactional

@Transactional
class SignedUpUserService {

    def createUser(jsonObject) {
        def newUser = new SignedUpUser(jsonObject)
        return newUser.save(flush:true, failOnError:true)
    }

    def getSignedUser(emailId) {
        return SignedUpUser.findWhere(companyEmailId: emailId)
    }
}
