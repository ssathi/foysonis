package com.foysonis.quickbooks

class QuickbooksUser implements Serializable {

    String username;
    String companyId;
    String password;
    Date lastDownloadedDate;
    String defaultInventoryStatus;

    static mapping = {
        id name: 'companyId', type: 'string', generator: 'assigned'
        version false
    }

    static constraints = {
        companyId(blank: false, maxSize: 40)
        username(blank: false, maxSize: 40)
        password(blank: false, maxSize: 40)
        lastDownloadedDate(nullable: true)
        defaultInventoryStatus(nullable: true)
    }
}
