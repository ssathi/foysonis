package com.foysonis.user

import com.foysonis.quickbooks.QuickbooksUser
import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class CompanyController extends RestfulController<Company> {

    def companyService
    def userService
    def springSecurityService

    static responseFormats = ['json', 'xml']

    CompanyController() {
        super(Company)
    }

    def companyProfile() {
        session.user = springSecurityService.currentUser
        def pageTitle = "Company Profile";
        [pageTitle: pageTitle]
    }

    def getCurrentUserCompany = {
        respond companyService.getCompany(session.user.companyId)
    }

    def getQuickbooksInfo = {
        respond QuickbooksUser.findByCompanyId(session.user.companyId);
    }


    @Secured("permitAll")
    def create() {
        def jsonObject = request.JSON
        def user = new User(jsonObject)
        userService.saveUser(jsonObject.companyId, jsonObject.password, user)
        respond companyService.create(jsonObject)
    }

    def updateCompanyProfile = {
        def jsonObject = request.JSON
        respond companyService.updateCompanyProfile(jsonObject)
    }

    def updateCompanyEasyPostApi = {
        def jsonObject = request.JSON
        respond companyService.updateCompanyEasyPostApi(session.user.companyId, jsonObject)
    }

    def updateQuickbooksInfo = {
        def jsonObject = request.JSON
        respond companyService.updateQuickbooksInfo(session.user.companyId, jsonObject)
    }

    @Secured("permitAll")
    def downloadQWCFile() {
        log.info("Downloading QWC webconnector file..")
        String companyId = springSecurityService.currentUser.companyId
        String fileName = "webconnector-" + companyId + ".qwc"
        def file = new File(fileName)

        if (file.exists()) {
            file.write(getContent(companyId))
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "filename=${file.name}")
            response.outputStream << file.bytes
//            return;
        } else {
            boolean created = new File(fileName).createNewFile()
            if (created) {
                file.write(getContent(companyId))
                response.setContentType("application/octet-stream")
                response.setHeader("Content-disposition", "filename=${file.name}")
                response.outputStream << file.bytes
//                return;
            }
        }
    }

    String getContent(String username) {

        String content = "<?xml version=\"1.0\"?>\n" +
                "<QBWCXML>\n" +
                "    <AppName>Foysonis Quickbooks integration</AppName>\n" +
                "    <AppID>Foysonis</AppID>\n" +
                "    <AppURL>http://localhost:54323/quickbooks-foysonis</AppURL>\n" +
                "    <AppDescription>Foysonis WMS Application</AppDescription>\n" +
                "    <AppSupport>http://support.quickbooks.intuit.com/support/</AppSupport>\n" +
                "    <UserName>"+ username +"</UserName>\n" +
                "    <OwnerID>{d2893150-5a48-11e7-907b-a6006ad3dba0}</OwnerID>\n" +
                "    <FileID>{d289343e-5a48-11e7-907b-a6006ad3dba0}</FileID>\n" +
                "    <QBType>QBFS</QBType>\n" +
                "    <Scheduler>\n" +
                "        <RunEveryNMinutes>2</RunEveryNMinutes>\n" +
                "    </Scheduler>\n" +
                "    <IsReadOnly>false</IsReadOnly>\n" +
                "</QBWCXML>"
        return content;

    }

    def updateCompanyAddress = {
        def jsonObject = request.JSON
        respond companyService.updateCompanyAddress(session.user.companyId, jsonObject)
    }

}

