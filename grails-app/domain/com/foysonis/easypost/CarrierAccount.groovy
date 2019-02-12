package com.foysonis.easypost

class CarrierAccount implements  Serializable {

    String accountId;
    String type;
    String description;
    String readable;

    static mapping = {
        id name: 'accountId';
        version false;
        id generator: 'assigned';
    }

    static constraints = {
        accountId(blank: false)
        type(nullable: true)
        description(nullable: true)
        readable(nullable: true)
    }


    @Override
    public String toString() {
        return "CarrierAccount{" +
                "accountId='" + accountId + '\'' +
                ", type='" + type + '\'' +
                ", description='" + description + '\'' +
                ", readable='" + readable + '\'' +
                '}';
    }
}
