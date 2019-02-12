class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"{
            controller = "dashboard"
            action = "index"
        }
        "500"(view:'/error')
        "404"(view:'/notFound')

        "/rest/$controller/company_list" {
            action = [GET:"companyList"]
        }

        "/rest/$controller/getI" {
            action = [GET:"getI"]
        }

//        "/order/$action?/$id?(.$format)?"{
//            controller = "user"
//            action = "adminUser"
//        }
    }
}
