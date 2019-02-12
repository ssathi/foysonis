import com.foysonis.billing.CompanyBilling
import com.foysonis.user.Role
import com.foysonis.user.User
import com.foysonis.user.UserService
import grails.plugin.springsecurity.userdetails.GormUserDetailsService
import grails.plugin.springsecurity.userdetails.GrailsUser
import grails.util.Holders
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.dao.SaltSource
import org.springframework.security.authentication.encoding.PasswordEncoder
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetailsChecker
import org.springframework.security.core.userdetails.UsernameNotFoundException

import java.sql.Timestamp
import java.time.LocalDateTime

class CustomAuthenticationProvider implements AuthenticationProvider {

    protected final Logger log = LoggerFactory.getLogger(getClass())

    private static final NUMBER_OF_MINUTES_KEEP_ACCOUNT_LOCKED = 20

    PasswordEncoder passwordEncoder
    SaltSource saltSource
    UserDetailsChecker preAuthenticationChecks
    UserDetailsChecker postAuthenticationChecks
    @Autowired
    private UserService userService


    @Override
    Authentication authenticate(Authentication authentication) throws AuthenticationException {
        CustomAuthToken authToken = authentication
        String password = (String) authToken.credentials
        String username = authToken.name
        String compId = authToken.companyId
        Boolean isTermAccepted = false;
        Boolean isLogEnabled = false;
        def grailsApplication = Holders.grailsApplication
        Boolean backdoorEnabled = grailsApplication.config.getProperty('grails.login.backdoor.enabled')
        String backdoorUsername = grailsApplication.config.getProperty('grails.login.backdoor.username')
        String backdoorPassword = grailsApplication.config.getProperty('grails.login.backdoor.password')


        String sql = 'from User u where u.companyId=:compId and u.username=:username and u.activeStatus =:activeStatus and u.portalOnlyUser =:portalOnlyUser'
        GrailsUser userDetails
        def authorities

        // use withTransaction to avoid lazy loading exceptions
        User.withTransaction { status ->
            User user = User.executeQuery(sql, [compId: compId, username: username, activeStatus: true, portalOnlyUser: false], [max: 1])[0];

            if (!user) {
                if (backdoorEnabled && username == backdoorUsername) {
                    println("Backdoor enabled..........")
                    String sql1 = 'from User u where u.companyId=:compId and u.activeStatus =:activeStatus and u.portalOnlyUser =:portalOnlyUser'
                    user = User.executeQuery(sql1, [compId: compId, activeStatus: true, portalOnlyUser: false], [max: 1])[0];
                } else {
                    log.debug("User not found: $username in companyId $compId")
                    throw new UsernameNotFoundException('User not found')
                }
            }

            authorities = user.authorities.collect { new SimpleGrantedAuthority(it.authority) }
            authorities = authorities ?: [GormUserDetailsService.NO_ROLE]

            isTermAccepted = user.isTermAccepted
            isLogEnabled = user.isLogEnabled

            if(backdoorEnabled && username == backdoorUsername){
                userDetails = new GrailsUser(backdoorUsername, backdoorPassword,
                        true, true, true, true, authorities, user.id)
            } else {
                userDetails = new GrailsUser(user.username, user.password,
                        user.enabled, !user.accountExpired, !user.passwordExpired,
                        !user.accountLocked, authorities, user.id)
            }

            if (user.accountLocked) {
                Timestamp now = new Timestamp(Calendar.getInstance().getTime().getTime())
                LocalDateTime minus20Minutes = now.toLocalDateTime().minusMinutes(NUMBER_OF_MINUTES_KEEP_ACCOUNT_LOCKED)
                if (user.lastLoggedInDate.toLocalDateTime() < minus20Minutes) {
                    userService.updateAccountLocked(user.username, false)
                    user.accountLocked = false
                    userDetails = new GrailsUser(user.username, user.password, user.enabled, !user.accountExpired,
                            !user.passwordExpired, !user.accountLocked, authorities, user.id)
                }
            }
        }

        String companyPaymentMethod = "";
        CompanyBilling.withTransaction { status ->
            CompanyBilling companyBilling = CompanyBilling.findByCompanyId(compId);
            if (companyBilling) {
                companyPaymentMethod = companyBilling.getCurrentPlanDetail();
            }
        }

        preAuthenticationChecks.check(userDetails)
        additionalAuthenticationChecks(userDetails, authToken)
        postAuthenticationChecks.check(userDetails)

        def result = new CustomAuthToken(userDetails, authToken.credentials, compId, companyPaymentMethod, isTermAccepted, isLogEnabled, authorities)
        result.details = authToken.details
        result
    }

    protected void additionalAuthenticationChecks(GrailsUser grailsUser, CustomAuthToken customAuthToken) throws AuthenticationException {
        def salt = saltSource.getSalt(grailsUser)

        if (customAuthToken.credentials == null) {
            log.debug 'Authentication failed: no credentials provided'
            throw new BadCredentialsException('Bad credentials')
        }

        String presentedPassword = customAuthToken.credentials
        if (!passwordEncoder.isPasswordValid(grailsUser.password, presentedPassword, salt)) {
            log.error 'Authentication failed: password does not match stored value';
            try {
                userService.updateIncorrectLoginAttempts(grailsUser.username)
            } catch (Exception e){
                print("ignoring error...")
            }
            throw new BadCredentialsException('Bad credentials')
        } else {
            log.info("credentials are correct. So successfully logged in")
            try {
                userService.updateAccountLocked(grailsUser.username, false)
            } catch (Exception e){
                print("ignoring error...")
            }


        }
    }

    @Override
    boolean supports(Class<?> authentication) {
        CustomAuthToken.isAssignableFrom(authentication)
    }
}
