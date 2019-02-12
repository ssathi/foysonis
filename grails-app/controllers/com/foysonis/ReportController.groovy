package com.foysonis

import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory
import org.springframework.context.ApplicationContext
import org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes
//import com.foysonis.orders.Orders
import org.springframework.mail.javamail.MimeMessageHelper;
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import javax.activation.DataSource;
import javax.mail.util.ByteArrayDataSource;


@Secured(['ROLE_USER','ROLE_ADMIN'])
class ReportController {

   def sessionFactory
   def reportService	
   def springSecurityService
	def billingService

   static responseFormats = ['json', 'xml']

   def index() {
      // Gather data for the report.
		//def controller = applicationContext.getBean('com.foysonis.jasperReport.JasperReportController') 

      // 2) Invoke the action
		//def inputCollection = controller."${params._action}"(params)
   		//params.inputCollection = inputCollection


		// Find the compiled report
		def reportFileName = reportService.reportFileName("${params.file}")
		def reportFile = servletContext.getResource(reportFileName)

		if(reportFile == null){
		    throw new FileNotFoundException("""\"${reportFileName}\" file must be in
		        reports repository.""")
		}

		// Call the ReportService to invoke the reporting 

		params.format = params.fileFormat
		//params.SUBREPORT_DIR = servletContext.getRealPath('/reports/')
	   	params.SUBREPORT_DIR = '../../reports/'
	   	params.REPORT_CONNECTION = sessionFactory.currentSession.connection()
		params.companyId = session.user.companyId

	   switch(params.format){
	      case "PDF":
			  def generatedPdf = reportService.generateReport(reportFile,
						reportService.PDF_FORMAT,params).toByteArray()
			  if (params.isForMail) {
			  	def jsonObject 	= request.JSON
			  	def recipient 	= jsonObject.recipient
			  	def subject 	= jsonObject.mailSubject
			  	def pdfFileName = params.file
			  	def mailBody 	= jsonObject.mailBody
			  	sendMailWithAttachedFile(recipient, subject, mailBody, pdfFileName, generatedPdf)
		        render "Mail has been successfully sent"
			  }
			  else {
			  	render(file:generatedPdf,contentType:"application/pdf")
			  }
			  
			  break
	      case "HTML":
	         render(text:reportService.generateReport(reportFile,
	            reportService.HTML_FORMAT,params),contentType:"text/html")
	         break
	      case "CSV":
	      	createCsvFile(reportService.generateReport(reportFile,
	            reportService.CSV_FORMAT,params),params.file)
	         //render(text:reportService.generateReport(reportFile,
	           // reportService.CSV_FORMAT,params),contentType:"text")
	         break
	      case "XLS":
	         createXlsFile(reportService.generateReport(reportFile,
	            reportService.XLS_FORMAT,params).toByteArray(),params.file)
	         break
	      case "RTF":
	         createRtfFile(reportService.generateReport(reportFile,
	            reportService.RTF_FORMAT,params).toByteArray(),params.file)
	         break
	      case "XML":
	         render(text:reportService.generateReport(reportFile,
	            reportService.XML_FORMAT,params),contentType:"text")
	         break
	      case "TXT":
	         render(text:reportService.generateReport(reportFile,
	            reportService.TEXT_FORMAT,params),contentType:"text")
	         break
	      default:
	         throw new Exception("Invalid format"+params.SUBREPORT_DIR)
	         break
	   }
	}

	/**
	* Output a PDF response
	*/
	def createPdfFile = { contentBinary, fileName ->
	   response.setHeader("Content-disposition", "${params.accessType}; filename=" +
	        fileName + ".pdf");
	   response.contentType = "application/pdf"
	   response.outputStream << contentBinary
	}
	
	def createCsvFile = { contentBinary, fileName ->
	   response.setHeader("Content-disposition", "${params.accessType}; filename=" +
	        fileName + ".csv");
	   response.contentType = "application/csv"
	   response.outputStream << contentBinary
	}
	/**
	* Output an Excel response
	*/
	def createXlsFile = { contentBinary, fileName ->
	   response.setHeader("Content-disposition", "attachment; filename=" +
	      fileName + ".xls");
	   response.contentType = "application/vnd.ms-excel"
	   response.outputStream << contentBinary
	}

	/**
	* Output an RTF response
	*/
	def createRtfFile = { contentBinary, fileName ->
	   response.setHeader("Content-disposition", "attachment; filename=" +
	        fileName + ".rtf");
	   response.contentType = "application/rtf"
	   response.outputStream << contentBinary
	}


	def getReport = {

		def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
		if (billingData) {
			def trialEndDate = null
			use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
			if (billingData.isTrial == true && trialEndDate < new Date()) {

				if(springSecurityService.currentUser.adminActiveStatus == true){
					redirect(controller:"userAccount",action:"index")
					return
				}
				else{
					redirect(controller:"userAccount",action:"index")
					return
				}


			}
			else if(springSecurityService.currentUser.isTermAccepted != true){
				redirect(controller:"userAccount",action:"index")
				return
			}
		}
		else if(springSecurityService.currentUser.isTermAccepted != true){
			redirect(controller:"userAccount",action:"index")
			return
		}
		session.user = springSecurityService.currentUser
		def pageTitle = "Reports";
		[pageTitle:pageTitle]
	}

	def importFile = {

		def billingData = billingService.getCompanyBillingDetails(springSecurityService.currentUser.companyId)
		if (billingData) {
			def trialEndDate = null
			use(TimeCategory) {trialEndDate = billingData.trialDate + 05.days}
			if (billingData.isTrial == true && trialEndDate < new Date()) {

				if(springSecurityService.currentUser.adminActiveStatus == true){
					redirect(controller:"userAccount",action:"index")
					return
				}
				else{
					redirect(controller:"userAccount",action:"index")
					return
				}


			}
			else if(springSecurityService.currentUser.isTermAccepted != true){
				redirect(controller:"userAccount",action:"index")
				return
			}
		}
		else if(springSecurityService.currentUser.isTermAccepted != true){
			redirect(controller:"userAccount",action:"index")
			return
		}

		def pageTitle = "Import CSV";
		[pageTitle:pageTitle]
	}

	def getParamFromJasperReport = {
		def reportPath = servletContext.getRealPath('/reports/')
		respond reportService.getParamFromJasperReport(reportPath, params.reportType)
	}

	def sendMailWithAttachedFile(recipient, subject, mailBody, pdfFileName, generatedBytes) {
        //final String username = grailsApplication.config.getProperty('grails.mail.username')
        //final String password = grailsApplication.config.getProperty('grails.mail.password')
        final String username = "skylarkproj@gmail.com"
        final String password =  "Skylark@123"

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            // //message.setFrom(new InternetAddress("info@foysonis.com", "Foysonis WMS"));
            // message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("pruthvin@foysonis.com"));
            // if (cc) {
            //     message.addRecipient(Message.RecipientType.CC, new InternetAddress(cc));
            // }
            // message.setSubject(subject);
            // message.setText(body, "US-ASCII", "html");


			MimeMessageHelper helper = new MimeMessageHelper(message, true);
	        //helper.setFrom(simpleMailMessage.getFrom());
	        helper.setTo(recipient);
	        helper.setSubject(subject);
	        helper.setText(String.format(mailBody, "US-ASCII", "html"));

	        //FileSystemResource file = new FileSystemResource("C:\\projects\\attachMe.txt");
	        byte[] pdfInBytes = generatedBytes;
	        DataSource dataSource = new ByteArrayDataSource(pdfInBytes, "application/pdf");
	        helper.addAttachment(pdfFileName, dataSource);

            Transport.send(message);
            println("Email sent successfully");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
	}	

}


