package com.foysonis.printer

class Printer implements Serializable{

    String companyId
    String displayName
    String printerType
    String dpiSize
    String labelSize
    String printerAddress
    String connectionType


    static constraints = {
        companyId(blank: false, maxSize: 32)
        displayName(blank: false, maxSize: 150)
        printerType(blank: false, maxSize: 30)
        dpiSize(nullable: true, maxSize: 10)
        labelSize(nullable: true, maxSize: 30)
        printerAddress(nullable: true, maxSize: 100)
        connectionType(nullable: true, maxSize: 50)
    }
}
