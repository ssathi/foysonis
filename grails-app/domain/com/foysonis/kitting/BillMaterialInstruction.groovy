package com.foysonis.kitting

class BillMaterialInstruction {

    String  companyId
    Integer bomId
    Integer displayOrderNumber
    String  instruction
    String  instructionId
    String  instructionType
    String  inventoryStatus

    static constraints = {
        companyId(blank:false, maxSize:32)
        bomId(blank:false)
        displayOrderNumber(blank:false)
        instruction(blank:false, maxSize:1000)
        instructionId(nullable:true)
        instructionType(blank:false, maxSize:50)
        inventoryStatus(nullable:true, maxSize:15)

    }
}
