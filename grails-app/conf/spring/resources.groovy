import grails.plugin.springsecurity.SpringSecurityUtils

// Place your Spring DSL code here
beans = {
    def conf = SpringSecurityUtils.securityConfig

    authenticationProcessingFilter(CustomAuthFilter){
        authenticationManager = ref('authenticationManager')
        sessionAuthenticationStrategy = ref('sessionAuthenticationStrategy')
        authenticationSuccessHandler = ref('authenticationSuccessHandler')
        authenticationFailureHandler = ref('authenticationFailureHandler')
        rememberMeServices = ref('rememberMeServices')
        authenticationDetailsSource = ref('authenticationDetailsSource')
        filterProcessesUrl = conf.apf.filterProcessesUrl
        usernameParameter = conf.apf.usernameParameter
        passwordParameter = conf.apf.passwordParameter
        continueChainBeforeSuccessfulAuthentication = conf.apf.continueChainBeforeSuccessfulAuthentication
        allowSessionCreation = conf.apf.allowSessionCreation
        postOnly = conf.apf.postOnly
        storeLastUsername = true
    }

    // custom authentication
    daoAuthenticationProvider(CustomAuthenticationProvider) {
        passwordEncoder = ref('passwordEncoder')
        saltSource = ref('saltSource')
        preAuthenticationChecks = ref('preAuthenticationChecks')
        postAuthenticationChecks = ref('postAuthenticationChecks')
    }

    // other beans
    authenticationSuccessHandler(CustomAuthenticationSuccessHandler) {
        /* Reusing the security configuration */
        def config = SpringSecurityUtils.securityConfig
        /* Configuring the bean */
        requestCache = ref('requestCache')
        redirectStrategy = ref('redirectStrategy')
        defaultTargetUrl = config.successHandler.defaultTargetUrl
//        alwaysUseDefaultTargetUrl = config.successHandler.alwaysUseDefault
        targetUrlParameter = config.successHandler.targetUrlParameter
        ajaxSuccessUrl = config.successHandler.ajaxSuccessUrl
        useReferer = config.successHandler.useReferer
    }
}