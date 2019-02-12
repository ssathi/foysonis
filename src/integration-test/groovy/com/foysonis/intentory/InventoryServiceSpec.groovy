package com.foysonis.intentory

import com.foysonis.inventory.InventoryService
import grails.test.mixin.TestMixin
import grails.test.mixin.domain.DomainClassUnitTestMixin
import grails.test.mixin.integration.Integration
import grails.transaction.*
import org.springframework.beans.factory.annotation.Autowired
import spock.lang.*

@Integration
@Rollback
@TestMixin(DomainClassUnitTestMixin)
class InventoryServiceSpec extends Specification {

    @Autowired
    public InventoryService inventoryService

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            //inventoryService.getItemsForGivenLpn("c1011", "XYZ123").itemId == "ITEM160914"
    }
}
