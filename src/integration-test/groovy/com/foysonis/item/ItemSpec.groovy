package com.foysonis.item

import grails.test.mixin.TestMixin
import grails.test.mixin.domain.DomainClassUnitTestMixin
import grails.test.mixin.integration.Integration
import grails.transaction.*
import org.springframework.beans.factory.annotation.Autowired
import spock.lang.*

@Integration
@Rollback
@TestMixin(DomainClassUnitTestMixin)
class ItemSpec extends Specification {


    @Autowired
    private ItemService itemService;

    def setup() {
    }

    def cleanup() {
    }

    void "test checkItemIdExist"() {
        given:

        expect:"fix me"
            //itemService.checkItemIdExist("C1011", "AB1001").size() == 1
    }
}
