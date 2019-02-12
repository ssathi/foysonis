

// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'com.foysonis.user.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'com.foysonis.user.UserRole'
grails.plugin.springsecurity.authority.className = 'com.foysonis.user.Role'
grails.plugin.springsecurity.logout.postOnly = false
grails.plugin.springsecurity.password.algorithm = 'bcrypt'
grails.plugin.springsecurity.sch.strategyName = org.springframework.security.core.context.SecurityContextHolder.MODE_INHERITABLETHREADLOCAL

grails.plugin.springsecurity.controllerAnnotations.staticRules = [
	[pattern: '/',               access: ['permitAll']],
	[pattern: '/error',          access: ['permitAll']],
	[pattern: '/index',          access: ['permitAll']],
	[pattern: '/index.gsp',      access: ['permitAll']],
	[pattern: '/shutdown',       access: ['permitAll']],
	[pattern: '/assets/**',      access: ['permitAll']],
	[pattern: '/foysonis2016/**',      access: ['permitAll']],
	[pattern: '/**/js/**',       access: ['permitAll']],
	[pattern: '/**/css/**',      access: ['permitAll']],
	[pattern: '/**/beadmin/**',      access: ['permitAll']],
	[pattern: '/**/vendor/**',      access: ['permitAll']],
	[pattern: '/**/app/**',      access: ['permitAll']],
	[pattern: '/fonts/**',      access: ['permitAll']],
	[pattern: '/**/images/**',   access: ['permitAll']],
	[pattern: '/**/favicon.ico', access: ['permitAll']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
	[pattern: '/assets/**',      filters: 'none'],
	[pattern: '/foysonis2016/**',       filters: 'none'],
	[pattern: '/fonts/**',       filters: 'none'],
	[pattern: '/**/vendor/**',       filters: 'none'],
	[pattern: '/**/beadmin/**',       filters: 'none'],
	[pattern: '/**/js/**',       filters: 'none'],
	[pattern: '/**/css/**',      filters: 'none'],
	[pattern: '/**/images/**',   filters: 'none'],
	[pattern: '/**/favicon.ico', filters: 'none'],
	[pattern: '/**',             filters: 'JOINED_FILTERS']
]

