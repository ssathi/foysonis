
import com.foysonis.user.SignedUpUser

import grails.converters.JSON

class BootStrap {



    static {
        JSON.registerObjectMarshaller(SignedUpUser) {
            return it.properties.findAll {k,v -> k != 'class' && k!='declaredClass'}
        }
    }

    def init = { servletContext ->

       /* Role adminRole = new Role(authority: 'ROLE_ADMIN').save()
        Role userRole = new Role(authority: 'ROLE_USER').save()

        User adminUser = new User(username: 'admin', password: 'admin@123', adminActiveStatus: true, companyId: 'C1011',
                email: 'password@email.com', firstName: 'admin', lastName: 'admin').save()
        User normalUser = new User(username: 'user', password: 'user@123', adminActiveStatus: false, companyId: 'C1011',
                email: 'user@email.com', firstName: 'user', lastName: 'user').save()

        UserRole.create(adminUser, adminRole)
        UserRole.create(normalUser, userRole)

        UserRole.withSession {
            it.flush()
            it.clear()
        }*/
    }
    def destroy = {
    }
}
