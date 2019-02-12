package com.foysonis.easypost

class ServiceLevel implements Serializable {

    String id;
    String carrierAccountId;
    String description;

    static mapping = {
        id composite: ['carrierAccountId', 'id']
        version false
    }

    static constraints = {
        id(blank: false)
        carrierAccountId(blank: false)
        description(nullable: true)
    }
}
