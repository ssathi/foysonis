package com.foysonis.printer

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.rest.RestfulController

@Secured(['ROLE_ADMIN', 'ROLE_USER'])

class PrinterController extends RestfulController<Printer> {

	def springSecurityService
	def printerService

	static responseFormats = ['json', 'xml']

    PrinterController() {
        super(Printer)
    }

    def index() {
    	session.user = springSecurityService.currentUser
        def pageTitle = "Printers";
        [pageTitle:pageTitle]
    }

    def getPrinterDataByCompanyId = {
    	respond printerService.getPrinterDataByCompanyId(springSecurityService.currentUser.companyId)
    }

    def getAllDefaultPrinters = {
        respond printerService.getAllDefaultPrinters(springSecurityService.currentUser.companyId)
    }

    def getAllLabelPrinters = {
        respond printerService.getAllLabelPrinters(springSecurityService.currentUser.companyId)
    }

    def getAllRegularPrinters = {
        respond printerService.getAllRegularPrinters(springSecurityService.currentUser.companyId)
    }        

    def savePrinter = {
    	def jsonObject = request.JSON

    	if (jsonObject.printerId) {
    		Printer printer = Printer.findByCompanyIdAndId(springSecurityService.currentUser.companyId, jsonObject.printerId)
    		printer.displayName 	= jsonObject.displayName
    		printer.printerType 	= jsonObject.printerType
    		printer.dpiSize 		= jsonObject.dpiSize
    		printer.labelSize 		= jsonObject.labelSize
    		printer.printerAddress 	= jsonObject.printerAddress
    		printer.connectionType 	= jsonObject.connectionType

    		respond printerService.savePrinter(printer)
    	}
    	else {
	    	Printer printer = new Printer()
	    	printer.properties = [companyId		: springSecurityService.currentUser.companyId,
	    						  displayName	: jsonObject.displayName,
	    						  printerType	: jsonObject.printerType,
	    						  dpiSize		: jsonObject.dpiSize,
	    						  labelSize		: jsonObject.labelSize,
	    						  printerAddress: jsonObject.printerAddress,
	    						  connectionType: jsonObject.connectionType]    		
    		respond printerService.savePrinter(printer)
    	}
    	
    }

	def deletePrinter = {
		Printer printer = Printer.findByCompanyIdAndId(springSecurityService.currentUser.companyId, params.printerId)
		if (printer) {
			respond printerService.deletePrinter(printer)
		}
	}    

}
