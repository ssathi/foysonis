package com.foysonis.user

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController


class SignedUpUserController extends RestfulController<SignedUpUser> {

    static responseFormats = ['json']

    def signedUpUserService;

    SignedUpUserController() {
        super(SignedUpUser)
    }


    @Secured("permitAll")
    def create(){
        def jsonObject = request.JSON
        println("Received json object " + jsonObject)
        render signedUpUserService.createUser(jsonObject) as JSON
    }


    @Secured("permitAll")
    def getI() {
        def signedUser = signedUpUserService.getSignedUser(params["emailId"])
        if(signedUser){
            render signedUser as JSON
        } else {
            render {} as JSON
        }
    }

}
