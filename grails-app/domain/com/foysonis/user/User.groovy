package com.foysonis.user

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

import java.sql.Timestamp

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService

	String companyId
	String username
	String password
	String firstName
	String lastName
	boolean adminActiveStatus = true
	boolean activeStatus = true
	boolean portalOnlyUser = false
	Timestamp createdDate = new Timestamp(Calendar.getInstance().getTime().getTime())
	Timestamp lastModifiedDate = new Timestamp(Calendar.getInstance().getTime().getTime())
	String lastLoginSessionId = ""
	Timestamp lastLoggedInDate = new Timestamp(Calendar.getInstance().getTime().getTime())
	int incorrectLoginAttempt = 0
	boolean isDeleted = false
	Timestamp deletedDate = new Timestamp(Calendar.getInstance().getTime().getTime())
	String email
	byte[] userImage

	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	boolean isTermAccepted = false
	boolean isLogEnabled = false

	Integer defaultPrinterId
	Integer labelPrinterId

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService']

	static constraints = {
		companyId blank: false
		password blank: false, password: true
		username blank: false
		firstName blank: false
		lastName blank: false
		email nullable: true
		userImage(nullable:true, maxSize: 1024 * 1024 * 2)
		defaultPrinterId nullable: true
		labelPrinterId nullable: true
	}

	static mapping = {
		password column: '`password`'
	}
}
