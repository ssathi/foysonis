import com.foysonis.billing.CompanyBilling
import com.foysonis.user.User
import grails.plugin.springsecurity.web.authentication.AjaxAwareAuthenticationSuccessHandler
import grails.util.Holders
import org.springframework.security.core.Authentication
import org.springframework.security.web.savedrequest.SavedRequest
import com.foysonis.util.FoysonisLogger

import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

public class CustomAuthenticationSuccessHandler extends AjaxAwareAuthenticationSuccessHandler {

    boolean isTrialPeriodExpired = false
    private FoysonisLogger logger = FoysonisLogger.getInstance();

    @Override
    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response) {
        if (isTrialPeriodExpired) {
            println("This user's trial period is expired....")
            return "/billing/index";
        } else {
            SavedRequest savedRequest = requestCache.getRequest(request, response);
            if (savedRequest) {
                def targetUrl = savedRequest.getRedirectUrl();
                if (targetUrl == null || targetUrl == "") {
                    targetUrl = this.determineTargetUrl(request, response)
                }
                return targetUrl
            } else {
                return "/"
            }
        }
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        try {
            checkTrialPeriodExpired(request.getSession(), authentication)
            handle(request, response, authentication)
            logger = FoysonisLogger.getInstance(authentication.isLogEnabled);
            super.clearAuthenticationAttributes(request)
        }
        finally {
            requestCache.removeRequest(request, response)
        }
    }

    protected void handle(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
            throws IOException, ServletException {
        String targetUrl = determineTargetUrl(request, response)
        if (response.isCommitted()) {
            println("Response has already been committed.Unable to redirect to" + targetUrl)
            return
        }
        redirectStrategy.sendRedirect(request, response, targetUrl)
    }


    private void checkTrialPeriodExpired(HttpSession session, Authentication authentication) {
        def companyId = authentication.companyId
        String username = authentication.name

        isTrialPeriodExpired = false;

        def grailsApplication = Holders.grailsApplication
        Boolean backdoorEnabled = grailsApplication.config.getProperty('grails.login.backdoor.enabled')
        String backdoorUsername = grailsApplication.config.getProperty('grails.login.backdoor.username')

        if (backdoorEnabled && backdoorUsername == username) {
            isTrialPeriodExpired = false;
        } else {
            User.withTransaction { userstatus ->
                User currentuser = User.findByCompanyIdAndUsername(companyId, username)
                if (currentuser && currentuser.adminActiveStatus == true) {
                    CompanyBilling.withTransaction { status ->
                        CompanyBilling companyBilling = CompanyBilling.findByCompanyId(companyId)
                        if (companyBilling && companyBilling.isTrial && companyBilling.trialDate < new Date()) {
                            isTrialPeriodExpired = true
                        }
                    }
                }
            }
        }
    }


}
