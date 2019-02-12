package com.foysonis.kitting

class KittingOrderInstruction {

    String  companyId
    String kittingOrderNumber
    Integer displayOrderNumber
    String  instruction
    String  instructionId
    String  instructionType
    String  inventoryStatus

    static constraints = {
        companyId(blank:false, maxSize:32)
        kittingOrderNumber(blank:false, maxSize:50)
        displayOrderNumber(blank:false)
        instruction(blank:false, maxSize:1000)
        instructionId(nullable:true)
        instructionType(blank:false, maxSize:50)
        inventoryStatus(nullable:true, maxSize:15)

    }
}
