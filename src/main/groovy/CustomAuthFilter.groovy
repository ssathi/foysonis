import grails.plugin.springsecurity.web.authentication.GrailsUsernamePasswordAuthenticationFilter
import org.springframework.security.authentication.AuthenticationServiceException
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.util.TextEscapeUtils

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

class CustomAuthFilter extends GrailsUsernamePasswordAuthenticationFilter {

    @Override
    Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

        if (!request.post) {
            throw new AuthenticationServiceException("Authentication method not supported: $request.method")
        }
        String username = (obtainUsername(request) ?: '').trim()
        String password = (obtainPassword(request) ?: '').trim()
        String companyId = request.getParameter("company_id")

        def authentication = new CustomAuthToken(username, password, companyId, null, false, false)

        HttpSession session = request.getSession(false)
        if (session || getAllowSessionCreation()) {
            request.session['SPRING_SECURITY_LAST_USERNAME_KEY'] = TextEscapeUtils.escapeEntities(username)
        }

        setDetails(request, authentication)

        return getAuthenticationManager().authenticate(authentication)
    }
}
