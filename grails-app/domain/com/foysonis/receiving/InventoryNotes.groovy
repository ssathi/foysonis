package com.foysonis.receiving

class InventoryNotes implements Serializable {

    String companyId
    String lPN
    String notes

    static mapping = {
        id composite: ['companyId', 'lPN']
    }    

    static constraints = {
    	companyId(blank:false, maxSize:32)
    	lPN(blank:false, maxSize:40)
    	notes(nullable:true)
    }
}
