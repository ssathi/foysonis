package com.foysonis.printer

import com.foysonis.picking.PickWork
import com.foysonis.user.Company
import com.foysonis.item.Item
import com.foysonis.user.User
import grails.transaction.Transactional
import groovy.sql.Sql

import java.awt.print.PrinterJob;
import javax.print.PrintService;
import javax.print.PrintServiceLookup

@Transactional
class PrinterService {

    def getAllPrinters(String companyId) {
        return Printer.findAllByCompanyId(companyId)
    }

    def getAllDefaultPrinters(String companyId) {
        return Printer.findAllByCompanyIdAndPrinterTypeNotEqual(companyId, PrinterType.LABEL)
    }

    def getAllLabelPrinters(String companyId) {
        return Printer.findAllByCompanyIdAndPrinterType(companyId, PrinterType.LABEL)
    }

    def getAllRegularPrinters(String companyId) {
        return Printer.findAllByCompanyIdAndPrinterType(companyId, PrinterType.REGULAR)
    }

    def savePrinter(Printer printer) {

        // if (printer.id) {
        //     if(printer.printerType == PrinterType.LABEL){
        //         User userLabelPrinter = User.findAllByCompanyId(printer.companyId) { it.defaultPrinterId == printer.id}.each {
        //             it.defaultPrinterId = null
        //             it.save(flush: true, failOnError: true)
        //         }
        //     }
        //     else{
        //         User userDefaultPrinter = User.findAllByCompanyId(printer.companyId) { it.labelPrinterId == printer.id}.each {
        //             it.labelPrinterId = null
        //             it.save(flush: true, failOnError: true)
        //         }
        //     }

        // }

        try {
            return printer.save(flush: true, failOnError: true)
        } catch (Exception e) {
            log.error("Error occurred " + e)
        }
    }

    def deletePrinter(Printer printer) {

        // if(printer.printerType == PrinterType.LABEL){
        //     User userLabelPrinter = User.findAllByCompanyId(printer.companyId) { it.labelPrinterId = printer.id}.each {
        //         it.labelPrinterId = null
        //         it.save(flush: true, failOnError: true)
        //     }
        // }
        // else{
        //     User userDefaultPrinter = User.findAllByCompanyId(printer.companyId) { it.defaultPrinterId = printer.id}.each {
        //         it.defaultPrinterId = null
        //         it.save(flush: true, failOnError: true)
        //     }
        // }
        try {
            printer.delete(flush: true, failOnError: true)
            return [code: 'success']
        } catch (Exception e) {
            log.error("Error occurred " + e)
        }

    }

    def getPrinterDataByCompanyId(companyId) {
        return Printer.findAllByCompanyId(companyId)
    }

    def setPrinter(String printerName) {

        PrinterJob pj = PrinterJob.getPrinterJob();
        PrintService[] printServices = PrintServiceLookup.lookupPrintServices(null, null);

        println("Number of printers configured: " + printServices.length)

        for (PrintService printer : printServices) {

            println("Printer: " + printer.getName())

            if (printer.getName().equals(printerName)) {

                try {

                    pj.setPrintService(printer);

//                    println("Printer set to : " + printer.getName())


                } catch (Exception ex) {

                }


            }
        }

    }

    def printZPLPerPick(String companyId, PickWork pickWork) {
        Company company = Company.findByCompanyId(companyId)
        Item item = Item.findByCompanyIdAndItemId(companyId, pickWork.itemId)
        String zplCode = "^XA"

        zplCode += " ^FX Top section with company logo, name and address."
        zplCode += " ^CF0,60"
        zplCode += " ^FO50,50^GB100,100,100^FS"
        zplCode += " ^FO75,75^FR^GB100,100,100^FS"
        zplCode += " ^FO88,88^GB50,50,50^FS"
        zplCode += " ^FO220,50^FD ${company.name}^FS"
        zplCode += " ^CF0,40"
        zplCode += " ^FO220,100^FD ${company.companyBillingStreetAddress} ^FS"
        zplCode += " ^FO220,135^FD ${company.companyBillingCity},  ${company.companyBillingState}, ${company.companyBillingPostCode} ^FS"
        zplCode += " ^FO220,170^FD ${company.companyBillingCountry} ^FS"
        zplCode += " ^FO50,250^GB700,1,3^FS"

        zplCode += " ^FX Second section with recipient address and permit information."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,300^FDItem :  ${pickWork.itemId} (${item.itemDescription}) ^FS"
        zplCode += " ^FO50,340^FDQuantity : ${pickWork.pickQuantity} ${pickWork.pickQuantityUom} ^FS"
        zplCode += " ^CFA,15"
        zplCode += " ^FO50,400^GB700,1,3^FS"

        zplCode += " ^FX Third section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,440^FDPick Ref:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,480^BC^FD ${pickWork.workReferenceNumber} ^FS"
        zplCode += " ^FO50,670^GB700,1,3^FS"

        zplCode += " ^FX Fourth section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,720^FDOrder Number:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,760^BC^FD ${pickWork.orderNumber} ^FS"
        zplCode += " ^FO50,940^GB700,1,3^FS"

        zplCode += " ^FX Fifth section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,990^FDShipment ID:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,1030^BC^FD ${pickWork.shipmentId} ^FS"

        zplCode += " ^XZ"

        return zplCode

    }

    def printZPLPerUnit(String companyId, PickWork pickWork) {
        Company company = Company.findByCompanyId(companyId)
        Item item = Item.findByCompanyIdAndItemId(companyId, pickWork.itemId)
        String zplCode = "^XA"

        zplCode += " ^FX Top section with company logo, name and address."
        zplCode += " ^CF0,60"
        zplCode += " ^FO50,50^GB100,100,100^FS"
        zplCode += " ^FO75,75^FR^GB100,100,100^FS"
        zplCode += " ^FO88,88^GB50,50,50^FS"
        zplCode += " ^FO220,50^FD ${company.name}^FS"
        zplCode += " ^CF0,40"
        zplCode += " ^FO220,100^FD ${company.companyBillingStreetAddress} ^FS"
        zplCode += " ^FO220,135^FD ${company.companyBillingCity},  ${company.companyBillingState}, ${company.companyBillingPostCode} ^FS"
        zplCode += " ^FO220,170^FD ${company.companyBillingCountry} ^FS"
        zplCode += " ^FO50,250^GB700,1,3^FS"

        zplCode += " ^FX Second section with recipient address and permit information."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,300^FDItem :  ${pickWork.itemId} (${item.itemDescription}) ^FS"
        zplCode += " ^FO50,340^FDUOM : ${pickWork.pickQuantityUom} ^FS"
        zplCode += " ^CFA,15"
        zplCode += " ^FO50,400^GB700,1,3^FS"

        zplCode += " ^FX Third section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,440^FDPick Ref:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,480^BC^FD ${pickWork.workReferenceNumber} ^FS"
        zplCode += " ^FO50,670^GB700,1,3^FS"

        zplCode += " ^FX Fourth section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,720^FDOrder Number:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,760^BC^FD ${pickWork.orderNumber} ^FS"
        zplCode += " ^FO50,940^GB700,1,3^FS"

        zplCode += " ^FX Fifth section with barcode."
        zplCode += " ^CFA,30"
        zplCode += " ^FO50,990^FDShipment ID:^FS"
        zplCode += " ^BY2,2,100"
        zplCode += " ^FO50,1030^BC^FD ${pickWork.shipmentId} ^FS"

        zplCode += " ^XZ"

        return zplCode

    }


}
