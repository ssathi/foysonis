package com.foysonis.user

import grails.test.mixin.TestMixin
import grails.test.mixin.domain.DomainClassUnitTestMixin
import grails.test.mixin.integration.Integration
import grails.transaction.*
import org.springframework.beans.factory.annotation.Autowired
import spock.lang.*

@Integration
@Rollback
@TestMixin(DomainClassUnitTestMixin)
class CompanyServiceSpec extends Specification {

    @Autowired
    private CompanyService companyService;

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            //companyService.getCompany("C1011") != null
    }
}
