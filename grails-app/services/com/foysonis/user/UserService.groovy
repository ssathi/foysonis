package com.foysonis.user

import com.foysonis.util.FoysonisLogger
import grails.transaction.Transactional
import org.hibernate.Query

import java.sql.Timestamp

@Transactional
class UserService {

    final static Integer MAX_INCORRECT_LOGIN_ATTEMPTS = 3

    def sessionFactory
    FoysonisLogger logger = FoysonisLogger.getLogger(UserService.class);

    def encriptPassword(password) {
        def dateTime = new Date()
        def timestamp = dateTime.toTimestamp()
        def encryptTime = timestamp.encodeAsSHA1()
        def encrypt = password + encryptTime
        def cryptedPassword = encrypt.encodeAsSHA1()
        def cryptedPasswordSalt = [salt: encryptTime, cryptedPassword: cryptedPassword]
        return cryptedPasswordSalt
    }


    def updateIncorrectLoginAttempts(String username) {
        logger.info("Incorrect login attempt. So updating the incorrectLoginAttempt and lastLoggedInDate")
        Query query = sessionFactory.getCurrentSession().createQuery("UPDATE User SET incorrectLoginAttempt = " +
                "incorrectLoginAttempt + 1, lastLoggedInDate = :lastLogInDate WHERE username = :username")
        query.setParameter("username", username)
        query.setParameter("lastLogInDate", new Timestamp(Calendar.getInstance().getTime().getTime()))
        query.executeUpdate()

        Query q = sessionFactory.getCurrentSession().createQuery("SELECT incorrectLoginAttempt from User where username = :username")
        q.setParameter("username", username)
        int incorrectLoginAttempt = (Integer) q.list()[0]

        if (incorrectLoginAttempt > MAX_INCORRECT_LOGIN_ATTEMPTS) {
            updateAccountLocked(username, true)
        }
    }

    def updateAccountLocked(String username, boolean isLocked) {
        logger.info("Updating account locked is [$isLocked]")
        Query query = sessionFactory.getCurrentSession().createQuery("UPDATE User SET incorrectLoginAttempt=0, " +
                "accountLocked = :isLocked , lastLoggedInDate = :lastLogInDate WHERE username = :username")
        query.setParameter("username", username)
        query.setParameter("isLocked", isLocked)
        query.setParameter("lastLogInDate", new Timestamp(Calendar.getInstance().getTime().getTime()))
        query.executeUpdate()
    }

    def getCompanyUsers(companyId) {
        return User.findAllByCompanyIdAndIsDeleted(companyId, false)
    }

    def findUserByEmailId(email) {
        return User.findByEmail(email)
    }

    def getCompanyUsersWithFullName(companyId) {
        return User.executeQuery("select concat(u.firstName,' ',u.lastName) as name , u.firstName, u.lastName, u.username, u.email, u.adminActiveStatus, u.activeStatus, u.companyId, u.portalOnlyUser from User u where u.companyId = ? and u.isDeleted = false ", [companyId])
    }

    def getCompanyActiveUsers(companyId) {
        return User.findAllByCompanyIdAndActiveStatusAndIsDeleted(companyId, true, false)
    }

    def checkUsernameExist(companyId, username) {
        return User.findAllByCompanyIdAndUsername(companyId, username)
    }

    def checkEmailExist(email) {
        return User.findAllByEmail(email)
    }

    def saveUser(companyId, password, user) {
        user.properties = encriptPassword(password)
        user.companyId = companyId
        User addedUser = user.save(flush: true, failOnError: true)

        Role role = Role.findByAuthority('ROLE_USER')
        if (user.adminActiveStatus) {
            role = Role.findByAuthority('ROLE_ADMIN')
        }
        UserRole.create addedUser, role

        return addedUser

    }

    def updatePassword(emailId, password){
        def user = User.findByEmail(emailId)
        user.password = password
        user.save(flush: true, failOnError: true)
        println("Password has been updated successfully")
        return [message: "Password has been updated successfully"]
    }

    def deleteUser(companyId, username) {
        def user = User.findWhere(companyId: companyId, username: username)
        user.activeStatus = false
        user.isDeleted = true
        user.deletedDate = new Timestamp(Calendar.getInstance().getTime().getTime())
        return user.save(flush: true, failOnError: true)
    }

}

