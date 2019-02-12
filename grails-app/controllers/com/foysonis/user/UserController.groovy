package com.foysonis.user

import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController

import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

class UserController extends RestfulController<User> {

    def userService
    def companyService
    def springSecurityService
    def mailService

    static responseFormats = ['json', 'xml']

    UserController() {
        super(User)
    }

    @Secured("permitAll")
    def forgotPassword() {
        render(view: "forget-password");
    }

    @Secured("permitAll")
    def forgotPasswordAction() {
        String email = params["email"]
        if (email) {
            User user = userService.findUserByEmailId(email)
            println("User details ......." + user)

            String encodedEmail = email.bytes.encodeBase64().toString()
            if (user) {
                println("Sending email...")

                String subject = "Reset Your Foysonis Password"
                String url = grailsApplication.config.getProperty('grails.app.base.url') + "/user/resetPassword#?emailid=" + encodedEmail;
                String imageLocation = grailsApplication.config.getProperty('grails.email.logo.location')
                println("Image Location " + imageLocation)

                String body = "<!DOCTYPE html>\n" +
                        "<html lang=\"en\">\n" +
                        "<head>\n" +
                        "    <meta charset=\"UTF-8\">\n" +
                        "    <title>Title</title>\n" +
                        "</head>\n" +
                        "<body>\n" +
                        "\n" +
                        "<div style=\"width: 700px;font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;margin:0 auto; border: 1px solid rgba(0, 0, 0, 0.23)\">\n" +
                        "\n" +
                        "    <div style=\"text-align: center\">\n" +
                        "        <br>\n" +
    //                    "        <img src=\"src/main/webapp/resources/images/logo.svg\">\n" +
                        "\n" +
                        "        <hr style=\" border-top: 2px solid #1B75BC;\">\n" +
                        "        <h3 style=\"color: #315B91;text-decoration: underline;\">Verify Your Email</h3>\n" +
                        "    </div>\n" +
                        "\n" +
                        "    <div style=\"text-align: left;background-color: #EEF4F8; padding: 20px;color: #59595C;margin: 0 20px\">\n" +
                        "        <p>Dear " + user.getFirstName() + "</p>\n" +
                        "        <p>There was recently a request to change the password for your account.\n" +
                        "        </p>\n" +
                        "        <p>If you requested this password change, Please click on the following button to reset your password.</p>\n" +
                        "\n" +
                        "        <br/>\n" +
                        "        <div style=\"text-align: center\">\n" +
                        "            <p><a style=\"display: inline;width: 300px; height: 30px; padding: 10px 40px; text-align: center;\n" +
                        "            border-radius: 2px;color: white;background-color: #315B91; text-decoration: blink\"\n" +
                        "                  href=\"" + url + "\">RESET PASSWORD</a>\n" +
                        "            </p>\n" +
                        "        </div>\n" +
                        "        <br/>\n" +
                        "    </div>\n" +
                        "\n" +
                        "    <div style=\"background-color: #A7A9AC; text-align: center;color: #2C3C50;\">\n" +
                        "        <p style=\"padding: 10px\">Thank you, Foysonis Team</p>\n" +
                        "    </div>\n" +
                        "\n" +
                        "</div>\n" +
                        "</body>\n" +
                        "</html>"


                sendEmail(email, subject, body)
                flash.message = "An email has been sent your email address. Please check your inbox and proceed to reset the password."
                flash.error = null
                render(view: "forget-password");
            } else {
                println("Your email is not in the database")
                flash.message = null
                flash.error = "Your email is not valid. Please enter your correct email id."
                render(view: "forget-password");
            }            
        }
        else{
            flash.message = null
            flash.error = "Your email cannot be empty. Please enter your correct email id."
            render(view: "forget-password");                
        }
    }

    def sendEmail(String to, String subject, String body) {
        final String username = grailsApplication.config.getProperty('grails.mail.username')
        final String password = grailsApplication.config.getProperty('grails.mail.password')

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "false");
        props.put("mail.smtp.host", "localhost");
        props.put("mail.smtp.port", "25");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("info@foysonis.com" , "Foysonis WMS"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body, "US-ASCII", "html");\
            Transport.send(message);
            println("Email sent successfully");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }

    def sendEmailForSupport(String to, String cc, String subject, String body) {
        final String username = grailsApplication.config.getProperty('grails.mail.username')
        final String password = grailsApplication.config.getProperty('grails.mail.password')

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "false");
        props.put("mail.smtp.host", "localhost");
        props.put("mail.smtp.port", "25");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("info@foysonis.com", "Foysonis WMS"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            if (cc) {
                message.addRecipient(Message.RecipientType.CC, new InternetAddress(cc));
            }
            message.setSubject(subject);
            message.setText(body, "US-ASCII", "html");\
            Transport.send(message);
            println("Email sent successfully");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }    

    @Secured("permitAll")
    def sendSupportMail(){
        def respondObj = [:]
        def jsonObject = request.JSON
        def toMail = grailsApplication.config.getProperty('grails.mail.recipient')
        def ccMail = null
        def subject = springSecurityService.currentUser.companyId+' : '+jsonObject.mailSubject
        def mailBody = jsonObject.mailBody
        if (jsonObject.sendACopy) {
            def getUser = User.findByCompanyIdAndUsername(session.user.companyId, session.user.username)
            if (getUser) {
                ccMail = getUser.email
            }
        }
        sendEmailForSupport(toMail, ccMail, subject, mailBody)
        respondObj.status = 'success'
        respond respondObj
        
    }

    @Secured("permitAll")
    def resetPassword() {
        String emailId = params["emailid"]

        render(view: "reset-password", model: [emailid: emailId])
    }

    @Secured("permitAll")
    def resetPasswordAction() {
        def jsonObject = request.JSON

        String email = jsonObject.emailid
        String newpassword = jsonObject.newpassword
        def decodedEmail = new String(email.decodeBase64())
        print("email id :" + decodedEmail)
        print("newpassword :" + newpassword)
        respond userService.updatePassword(decodedEmail, newpassword)
    }


    @Secured("permitAll")
    def companyList() {
        def company = Company.findWhere(companyId: params['company_id'], activeStatus: true)
        if (company) {
            respond company
        } else {
            respond {}
        }
    }

    // This method is written for the website company id validation using ajax.
    @Secured("permitAll")
    def checkCompanyId() {
        def company = Company.findWhere(companyId: params['companyId'], activeStatus: true)
        if (company) {
            render "${params.callback}(false)"
        } else {
            def error = ['error': "Company not found with id ${params.companyId}."]
            render "${params.callback}(true)"
        }
    }


    def login = {
    }


    def doLogOut = {
        session.user = null
        redirect(controller: 'user', action: 'login')
    }


    def sign_up = {}

    @Secured(['ROLE_ADMIN'])
    def saveUser() {

        def jsonObject = request.JSON

        if (jsonObject.hiddenUsername) {
            def user = User.findByCompanyIdAndUsername(session.user.companyId, jsonObject.hiddenUsername)
            user.firstName = jsonObject.firstName
            user.lastName = jsonObject.lastName
            user.email = jsonObject.email
            user.activeStatus = jsonObject.activeStatus
            user.adminActiveStatus = jsonObject.adminActiveStatus
            user.portalOnlyUser = jsonObject.portalOnlyUser
            if (jsonObject.password) {
                user.password = jsonObject.password
            }

            user.save(flush: true, failOnError: true)


        } else {


            if (jsonObject.adminActiveStatus == null || jsonObject.adminActiveStatus == "") {
                jsonObject.adminActiveStatus = false
            }
            def user = new User(jsonObject)
            userService.saveUser(session.user.companyId, jsonObject.password, user)
        }
    }

    @Secured(['ROLE_ADMIN'])
    def adminUser() {
        session.user = springSecurityService.currentUser
        def pageTitle = "Users";
        [pageTitle: pageTitle]

    }

    @Secured(['ROLE_ADMIN'])
    def getCompanyUsers() {
        respond userService.getCompanyUsers(session.user.companyId)
    }

    @Secured(['ROLE_ADMIN'])
    def getCompanyUsersWithFullName() {
        respond userService.getCompanyUsersWithFullName(session.user.companyId)
    }

    @Secured(['ROLE_ADMIN'])
    def getCompanyActiveUsers() {
        respond userService.getCompanyActiveUsers(session.user.companyId)
    }

    @Secured(['ROLE_ADMIN'])
    def getCompanyActiveUsersWithAll() {
        def users = userService.getCompanyActiveUsers(session.user.companyId)
        users.add(username: 'all', companyId: session.user.companyId, firstName: 'All', lastName: 'Users')
        respond users
    }

    @Secured(['ROLE_ADMIN'])
    def checkUsernameExist() {
        respond userService.checkUsernameExist(session.user.companyId, params['username'])
    }

    @Secured(['ROLE_ADMIN'])
    def checkEmailExist() {
        respond userService.checkEmailExist(params['email'])
    }

    @Secured(['ROLE_ADMIN'])
    def deleteUser() {
        def jsonObject = request.JSON
        if (session.user.companyId == jsonObject.companyId && session.user.username != jsonObject.username)
            userService.deleteUser(jsonObject.companyId, jsonObject.username)
    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN'])
    def getCurrentUser() {
        respond session.user
    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN'])
    def getUserGuideHtml() {
        def userGuideFile = servletContext.getResource('/userGuide/userGuide.html')
        render(text:userGuideFile.text,contentType:"text/html")

    }   

}


