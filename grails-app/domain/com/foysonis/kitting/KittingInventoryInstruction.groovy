package com.foysonis.kitting

class KittingInventoryInstruction implements Serializable {

    String      companyId
    String      kittingOrderNumber
    Integer     kittingOrderInstructionId
    Integer     kittingInventoryId
    String      status
    Date        createdDate


    static constraints = {
        companyId(blank:false, maxSize:32)
        kittingOrderNumber(blank:false, maxSize:50)
        kittingOrderInstructionId(blank:false)
        kittingInventoryId(blank:false)
        status(blank:false, maxSize:20)

    }
}
