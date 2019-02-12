import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.GrantedAuthority

class CustomAuthToken extends UsernamePasswordAuthenticationToken {

    private static final long serialVersionID = 1;

    final String companyId
    final String companyPaymentMethod;
    final Boolean isTermAccepted
    final Boolean isLogEnabled

    CustomAuthToken(Object principal, Object credentials, String compId, String companyPaymentMethod, Boolean isTermAccepted, Boolean isLogEnabled) {
        super(principal, credentials)
        companyId = compId
        this.companyPaymentMethod = companyPaymentMethod
        this.isTermAccepted = isTermAccepted
        this.isLogEnabled = isLogEnabled
    }

    CustomAuthToken(Object principal, Object credentials, String compId, String companyPaymentMethod, Boolean  isTermAccepted, Boolean  isLogEnabled, Collection<? extends GrantedAuthority> authorities) {
        super(principal, credentials, authorities)
        companyId = compId
        this.companyPaymentMethod = companyPaymentMethod
        this.isTermAccepted = isTermAccepted
        this.isLogEnabled = isLogEnabled

    }
}
