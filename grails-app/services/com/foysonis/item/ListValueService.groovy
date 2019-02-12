package com.foysonis.item

import grails.transaction.Transactional

import com.foysonis.area.Area
import com.foysonis.user.Company

@Transactional
class ListValueService {

    def getAllValuesByCompanyIdAndGroup(companyId, group){
        return ListValue.findAll("from ListValue as l where (l.companyId = 'ALL' or l.companyId = ?) and l.optionGroup = ? order by l.displayOrder", [companyId, group])
    }

    def getAllListValueByOptionValues(companyId, group, optionValue){
         return ListValue.findAll("from ListValue as l where (l.companyId = 'ALL' or l.companyId = ?) and l.optionGroup = ? AND l.optionValue = ? order by l.displayOrder", [companyId, group, optionValue])
    }

    def getAllListValueByDescription(companyId, group, description){
         return ListValue.findAll("from ListValue as l where (l.companyId = 'ALL' or l.companyId = ?) and l.optionGroup = ? AND l.description = ? order by l.displayOrder", [companyId, group, description])
    }    

    def getAllStorageAreasByCompany(companyId){
        //return Area.findAllByCompanyIdAndIsStorage(companyId, true)
        return Area.findAll("FROM Area WHERE companyId = '${companyId}' AND isStorage = true ORDER BY putawayOrder ASC NULLS LAST")
    }


    def getAllPickableAreasByCompany(companyId){
        //return Area.findAllByCompanyIdAndIsStorage(companyId, true)
        return Area.findAll("FROM Area WHERE companyId = '${companyId}' AND isPickable = true ORDER BY allocationOrder ASC NULLS LAST")
    }


    def getAllListValuesByCompanyId(companyId){
        return ListValue.findAllByCompanyId(companyId)
    }

    def getOriginCodes(){
        return ["US", "CA", "CN", "BR"].toArray()
    }


    def savePutawayOrder(companyId, areaOrderData){

        def index = 1

        for(areaOrder in areaOrderData) {
            
            def getArea = Area.findByCompanyIdAndAreaIdAndIsStorage(companyId,areaOrder.areaId,true)
            if (getArea) {
                getArea.putawayOrder = index
                getArea.save(flush: true, failOnError: true)
                index++
            }
        }
        return areaOrderData
    }

    def resetPutawayOrder(companyId, areaOrderData){

        for(areaOrder in areaOrderData) {
            
            def getArea = Area.findByCompanyIdAndAreaIdAndIsStorage(companyId,areaOrder.areaId,true)
            if (getArea) {
                getArea.putawayOrder = null
                getArea.save(flush: true, failOnError: true)
            }
        }
        return areaOrderData
    
    }

    def saveAllocationOrder(companyId, areaOrderData){

        def index = 1

        for(areaOrder in areaOrderData) {
            
            def getArea = Area.findByCompanyIdAndAreaIdAndIsPickable(companyId,areaOrder.areaId,true)
            if (getArea) {
                getArea.allocationOrder = index
                getArea.save(flush: true, failOnError: true)
                index++
            }
        }
        return areaOrderData
    }

    def resetAllocationOrder(companyId, areaOrderData){

        for(areaOrder in areaOrderData) {
            
            def getArea = Area.findByCompanyIdAndAreaIdAndIsPickable(companyId,areaOrder.areaId,true)
            if (getArea) {
                getArea.allocationOrder = null
                getArea.save(flush: true, failOnError: true)
            }
        }
        return areaOrderData
    
    }

    def saveListValue(companyId, listValueData){

        def listValue = new ListValue()


        if (!listValueData.optionValue) {
            def optionValueExist = ListValue.find("from ListValue where companyId='${companyId}' AND optionGroup = '${listValueData.optionGroup}' AND optionValue > 0 order by ABS(optionValue) DESC")
            if (!optionValueExist) {
                listValue.optionValue = "001"
            }
            else{
                def optionValue = optionValueExist.optionValue
                def intIndex = optionValue.toInteger()
                intIndex = intIndex + 1
                def stringIndex = intIndex.toString().padLeft(3,"0")
                listValue.optionValue = stringIndex
            }           
        }
        else{
            listValue.optionValue = listValueData.optionValue
        }


        listValue.companyId = companyId
        listValue.optionGroup = listValueData.optionGroup
        listValue.description = listValueData.description
        listValue.createdDate = new Date()

        if (listValueData.displayOrder) {
            listValue.displayOrder = listValueData.displayOrder.toInteger()
        }
        else{
            listValue.displayOrder = 0
        }

        listValue.save(flush: true, failOnError: true)

    }   


    def updateListValue(companyId, listValueData){

        def listValue = ListValue.findByCompanyIdAndOptionGroupAndOptionValue(companyId, listValueData.optionGroup, listValueData.optionValue)

        listValue.description = listValueData.description
        listValue.createdDate = new Date()
        
        if (listValueData.displayOrder) {
            listValue.displayOrder = listValueData.displayOrder.toInteger()
        }
        else{
            listValue.displayOrder = 0
        }

        listValue.save(flush: true, failOnError: true)

    }


    def deleteListValue(companyId, listValueData){
        def listValue = ListValue.findByCompanyIdAndOptionGroupAndOptionValue(companyId, listValueData.optionGroup, listValueData.optionValue)       
        listValue.delete(flush: true, failOnError: true)
        return [deletionResult: true]

    }

    def updateWarehouseConfig(companyId, warehouseConfigData){
        def company = Company.findByCompanyId(companyId)
        company.autoLoadPalletId = warehouseConfigData.autoLoadPalletId    
        company.bolType = warehouseConfigData.bolType
        company.isAutoLoadPackoutContainer = warehouseConfigData.autoLoadContainer
        company.save(flush: true, failOnError: true)           
    } 

    def getCountries(){
        return ["Afghanistan",
                "Albania",
                "Algeria",
                "American Samoa",
                "Andorra",
                "Angola",
                "Anguilla",
                "Antarctica",
                "Antigua and Barbuda",
                "Argentina",
                "Armenia",
                "Aruba",
                "Australia",
                "Austria",
                "Azerbaijan",
                "Bahamas",
                "Bahrain",
                "Bangladesh",
                "Barbados",
                "Belarus",
                "Belgium",
                "Belize",
                "Benin",
                "Bermuda",
                "Bhutan",
                "Bolivia",
                "Bosnia and Herzegovina",
                "Botswana",
                "Brazil",
                "British Indian Ocean Territory",
                "British Virgin Islands",
                "Brunei",
                "Bulgaria",
                "Burkina Faso",
                "Burundi",
                "Cambodia",
                "Cameroon",
                "Canada",
                "Cape Verde",
                "Cayman Islands",
                "Central African Republic",
                "Chad",
                "Chile",
                "China",
                "Christmas Island",
                "Cocos Islands",
                "Colombia",
                "Comoros",
                "Cook Islands",
                "Costa Rica",
                "Croatia",
                "Cuba",
                "Curacao",
                "Cyprus",
                "Czech Republic",
                "Democratic Republic of the Congo",
                "Denmark",
                "Djibouti",
                "Dominica",
                "Dominican Republic",
                "East Timor",
                "Ecuador",
                "Egypt",
                "El Salvador",
                "Equatorial Guinea",
                "Eritrea",
                "Estonia",
                "Ethiopia",
                "Falkland Islands",
                "Faroe Islands",
                "Fiji",
                "Finland",
                "France",
                "French Polynesia",
                "Gabon",
                "Gambia",
                "Georgia",
                "Germany",
                "Ghana",
                "Gibraltar",
                "Greece",
                "Greenland",
                "Grenada",
                "Guam",
                "Guatemala",
                "Guernsey",
                "Guinea",
                "Guinea-Bissau",
                "Guyana",
                "Haiti",
                "Honduras",
                "Hong Kong",
                "Hungary",
                "Iceland",
                "India",
                "Indonesia",
                "Iran",
                "Iraq",
                "Ireland",
                "Isle of Man",
                "Israel",
                "Italy",
                "Ivory Coast",
                "Jamaica",
                "Japan",
                "Jersey",
                "Jordan",
                "Kazakhstan",
                "Kenya",
                "Kiribati",
                "Kosovo",
                "Kuwait",
                "Kyrgyzstan",
                "Laos",
                "Latvia",
                "Lebanon",
                "Lesotho",
                "Liberia",
                "Libya",
                "Liechtenstein",
                "Lithuania",
                "Luxembourg",
                "Macao",
                "Macedonia",
                "Madagascar",
                "Malawi",
                "Malaysia",
                "Maldives",
                "Mali",
                "Malta",
                "Marshall Islands",
                "Mauritania",
                "Mauritius",
                "Mayotte",
                "Mexico",
                "Micronesia",
                "Moldova",
                "Monaco",
                "Mongolia",
                "Montenegro",
                "Montserrat",
                "Morocco",
                "Mozambique",
                "Myanmar",
                "Namibia",
                "Nauru",
                "Nepal",
                "Netherlands",
                "Netherlands Antilles",
                "New Caledonia",
                "New Zealand",
                "Nicaragua",
                "Niger",
                "Nigeria",
                "Niue",
                "North Korea",
                "Northern Mariana Islands",
                "Norway",
                "Oman",
                "Pakistan",
                "Palau",
                "Palestine",
                "Panama",
                "Papua New Guinea",
                "Paraguay",
                "Peru",
                "Philippines",
                "Pitcairn",
                "Poland",
                "Portugal",
                "Puerto Rico",
                "Qatar",
                "Republic of the Congo",
                "Reunion",
                "Romania",
                "Russia",
                "Rwanda",
                "Saint Barthelemy",
                "Saint Helena",
                "Saint Kitts and Nevis",
                "Saint Lucia",
                "Saint Martin",
                "Saint Pierre and Miquelon",
                "Saint Vincent and the Grenadines",
                "Samoa",
                "San Marino",
                "Sao Tome and Principe",
                "Saudi Arabia",
                "Senegal",
                "Serbia",
                "Seychelles",
                "Sierra Leone",
                "Singapore",
                "Sint Maarten",
                "Slovakia",
                "Slovenia",
                "Solomon Islands",
                "Somalia",
                "South Africa",
                "South Korea",
                "South Sudan",
                "Spain",
                "Sri Lanka",
                "Sudan",
                "Suriname",
                "Svalbard and Jan Mayen",
                "Swaziland",
                "Sweden",
                "Switzerland",
                "Syria",
                "Taiwan",
                "Tajikistan",
                "Tanzania",
                "Thailand",
                "Togo",
                "Tokelau",
                "Tonga",
                "Trinidad and Tobago",
                "Tunisia",
                "Turkey",
                "Turkmenistan",
                "Turks and Caicos Islands",
                "Tuvalu",
                "U.S. Virgin Islands",
                "Uganda",
                "Ukraine",
                "United Arab Emirates",
                "United Kingdom",
                "United States",
                "Uruguay",
                "Uzbekistan",
                "Vanuatu",
                "Vatican",
                "Venezuela",
                "Vietnam",
                "Wallis and Futuna",
                "Western Sahara",
                "Yemen",
                "Zambia",
                "Zimbabwe"].toArray()
    }


    def getOriginCodeForCountries(){
        return [
                [name:"Afghanistan",code:"AF"],
                [name:"Albania",code:"AL"],
                [name:"Algeria",code:"DZ"],
                [name:"American Samoa",code:"AS"],
                [name:"Andorra",code:"AD"],
                [name:"Angola",code:"AO"],
                [name:"Anguilla",code:"AI"],
                [name:"Antarctica",code:"AQ"],
                [name:"Antigua and Barbuda",code:"AG"],
                [name:"Argentina",code:"AR"],
                [name:"Armenia",code:"AM"],
                [name:"Aruba",code:"AW"],
                [name:"Australia",code:"AU"],
                [name:"Austria",code:"AT"],
                [name:"Azerbaijan",code:"AZ"],
                [name:"Bahamas",code:"BS"],
                [name: "Bahrain",code:"BH"],
                [name: "Bangladesh",code:"BD"],
                [name: "Barbados",code:"BB"],
                [name: "Belarus",code:"BY"],
                [name:"Belgium",code:"BE"],
                [name:"Belize",code:"BZ"],
                [name:"Benin",code:"BJ"],
                [name:"Bermuda",code:"BM"],
                [name:"Bhutan",code:"BT"],
                [name:"Bolivia",code:"BO"],
                [name:"Bosnia and Herzegovina",code:"BA"],
                [name:"Botswana",code:"BW"],
                [name:"Brazil",code:"BR"],
                [name:"British Indian Ocean Territory",code:"IO"],
                [name:"British Virgin Islands",code:"VG"],
                [name:"Brunei",code:"BN"],
                [name: "Bulgaria",code:"BG"],
                [name:"Burkina Faso",code:"BF"],
                [name: "Burundi",code:"BI"],
                [name: "Cambodia",code:"KH"],
                [name: "Cameroon",code:"CM"],
                [name: "Canada",code:"CA"],
                [name:"Cape Verde",code:"CV"],
                [name:"Cayman Islands",code:"KY"],
                [name:"Central African Republic",code:"CF"],
                [name:"Chad",code:"TD"],
                [name:"Chile",code:"CL"],
                [name:"China",code:"CN"],
                [name:"Christmas Island",code:"CX"],
                [name:"Cocos Islands",code:"CC"],
                [name:"Colombia",code:"CO"],
                [name:"Comoros",code:"KM"],
                [name:"Cook Islands",code:"CK"],
                [name: "Costa Rica",code:"CR"],
                [name:"Croatia",code:"HR"],
                [name:"Cuba",code:"CU"],
                [name:"Curacao",code:"CW"],
                [name:"Cyprus",code:"CY"],
                [name: "Czech Republic",code:"CZ"],
                [name:"Democratic Republic of the Congo",code:"CD"],
                [name:"Denmark",code:"DK"],
                [name:"Djibouti",code:"DJ"],
                [name:"Dominica",code:"DM"],
                [name: "Dominican Republic",code:"DO"],
                [name: "East Timor",code:"TL"],
                [name:"Ecuador",code:"EC"],
                [name:"Egypt",code:"EG"],
                [name:"El Salvador",code:"SV"],
                [name: "Equatorial Guinea",code:"GQ"],
                [name: "Eritrea",code:"ER"],
                [name:"Estonia",code:"EE"],
                [name:"Ethiopia",code:"ET"],
                [name:"Falkland Islands",code:"FK"],
                [name:"Faroe Islands",code:"FO"],
                [name:"Fiji",code:"FJ"],
                [name:"Finland",code:"FI"],
                [name:"France",code:"FR"],
                [name: "French Polynesia",code:"PF"],
                [name:"Gabon",code:"GA"],
                [name:"Gambia",code:"GM"],
                [name:"Georgia",code:"GE"],
                [name:"Germany",code:"DE"],
                [name:"Ghana",code:"GH"],
                [name:"Gibraltar",code:"GI"],
                [name:"Greece",code:"GR"],
                [name:"Greenland",code:"GL"],
                [name:"Grenada",code:"GD"],
                [name:"Guam",code:"GU"],
                [name:"Guatemala",code:"GT"],
                [name:"Guernsey",code:"GG"],
                [name:"Guinea",code:"GN"],
                [name:"Guinea-Bissau",code:"GW"],
                [name:"Guyana",code:"GY"],
                [name:"Haiti",code:"HT"],
                [name:"Honduras",code:"HN"],
                [name:"Hong Kong",code:"HK"],
                [name:"Hungary",code:"HU"],
                [name:"Iceland",code:"IS"],
                [name: "India",code:"IN"],
                [name: "Indonesia",code:"ID"],
                [name: "Iran",code:"IR"],
                [name:"Iraq",code:"IQ"],
                [name: "Ireland",code:"IE"],
                [name: "Isle of Man",code:"IM"],
                [name:"Israel",code:"IL"],
                [name: "Italy",code:"IT"],
                [name: "Ivory Coast",code:"CI"],
                [name:"Jamaica",code:"JM"],
                [name:"Japan",code:"JP"],
                [name:"Jersey",code:"JE"],
                [name:"Jordan",code:"JO"],
                [name:"Kazakhstan",code:"KZ"],
                [name:"Kenya",code:"KE"],
                [name:"Kiribati",code:"KI"],
                [name:"Kosovo",code:"XK"],
                [name:"Kuwait",code:"KW"],
                [name:"Kyrgyzstan",code:"KG"],
                [name:"Laos",code:"LA"],
                [name:"Latvia",code:"LV"],
                [name:"Lebanon",code:"LB"],
                [name: "Lesotho",code:"LS"],
                [name:"Liberia",code:"LR"],
                [name:"Libya",code:"LY"],
                [name: "Liechtenstein",code:"LI"],
                [name:"Lithuania",code:"LT"],
                [name: "Luxembourg",code:"LU"],
                [name: "Macao",code:"MO"],
                [name:"Macedonia",code:"MK"],
                [name: "Madagascar",code:"MG"],
                [name: "Malawi",code:"MW"],
                [name: "Malaysia",code:"MY"],
                [name: "Maldives",code:"MV"],
                [name:"Mali",code:"ML"],
                [name:"Malta",code:"MT"],
                [name: "Marshall Islands",code:"MH"],
                [name: "Mauritania",code:"MR"],
                [name:"Mauritius",code:"MU"],
                [name: "Mayotte",code:"YT"],
                [name: "Mexico",code:"MX"],
                [name: "Micronesia",code:"FM"],
                [name: "Moldova",code:"MD"],
                [name: "Monaco",code:"MC"],
                [name:"Mongolia",code:"MN"],
                [name:"Montenegro",code:"ME"],
                [name: "Montserrat",code:"MS"],
                [name:"Morocco",code:"MA"],
                [name:"Mozambique",code:"MZ"],
                [name: "Myanmar",code:"MM"],
                [name: "Namibia",code:"NA"],
                [name:"Nauru",code:"NR"],
                [name:"Nepal",code:"NP"],
                [name:"Netherlands",code:"NL"],
                [name:"Netherlands Antilles",code:"AN"],
                [name:"New Caledonia",code:"NC"],
                [name:"New Zealand",code:"NZ"],
                [name:"Nicaragua",code:"NI"],
                [name:"Niger",code:"NE"],
                [name:"Nigeria",code:"NG"],
                [name:"Niue",code:"NU"],
                [name:"North Korea",code:"KP"],
                [name:"Northern Mariana Islands",code:"MP"],
                [name:"Norway",code:"NO"],
                [name:"Oman",code:"OM"],
                [name:"Pakistan",code:"PK"],
                [name:"Palau",code:"PW"],
                [name:"Palestine",code:"PS"],
                [name:"Panama",code:"PA"],
                [name:"Papua New Guinea",code:"PG"],
                [name:"Paraguay",code:"PY"],
                [name:"Peru",code:"PE"],
                [name:"Philippines",code:"PH"],
                [name:"Pitcairn",code:"PN"],
                [name:"Poland",code:"PL"],
                [name:"Portugal",code:"PT"],
                [name:"Puerto Rico",code:"PR"],
                [name:"Qatar",code:"QA"],
                [name:"Republic of the Congo",code:"CG"],
                [name:"Reunion",code:"RE"],
                [name:"Romania",code:"RO"],
                [name:"Russia",code:"RU"],
                [name:"Rwanda",code:"RW"],
                [name:"Saint Barthelemy",code:"BL"],
                [name:"Saint Helena",code:"SH"],
                [name:"Saint Kitts and Nevis",code:"KN"],
                [name:"Saint Lucia",code:"LC"],
                [name:"Saint Martin",code:"MF"],
                [name:"Saint Pierre and Miquelon",code:"PM"],
                [name:"Saint Vincent and the Grenadines",code:"VC"],
                [name:"Samoa",code:"WS"],
                [name:"San Marino",code:"SM"],
                [name:"Sao Tome and Principe",code:"ST"],
                [name:"Saudi Arabia",code:"SA"],
                [name:"Senegal",code:"SN"],
                [name:"Serbia",code:"RS"],
                [name:"Seychelles",code:"SC"],
                [name:"Sierra Leone",code:"SL"],
                [name:"Singapore",code:"SG"],
                [name:"Sint Maarten",code:"SX"],
                [name:"Slovakia",code:"SK"],
                [name:"Slovenia",code:"SI"],
                [name:"Solomon Islands",code:"SB"],
                [name:"Somalia",code:"SO"],
                [name:"South Africa",code:"ZA"],
                [name:"South Korea",code:"KR"],
                [name:"South Sudan",code:"SS"],
                [name:"Spain",code:"ES"],
                [name:"Sri Lanka",code:"LK"],
                [name:"Sudan",code:"SD"],
                [name:"Suriname",code:"SR"],
                [name:"Svalbard and Jan Mayen",code:"SJ"],
                [name:"Swaziland",code:"SZ"],
                [name:"Sweden",code:"SE"],
                [name:"Switzerland",code:"CH"],
                [name:"Syria",code:"SY"],
                [name:"Taiwan",code:"TW"],
                [name:"Tajikistan",code:"TJ"],
                [name:"Tanzania",code:"TZ"],
                [name: "Thailand",code:"TH"],
                [name:"Togo",code:"TG"],
                [name:"Tokelau",code:"TK"],
                [name:"Tonga",code:"TO"],
                [name:"Trinidad and Tobago",code:"TT"],
                [name:"Tunisia",code:"TN"],
                [name:"Turkey",code:"TR"],
                [name:"Turkmenistan",code:"TM"],
                [name:"Turks and Caicos Islands",code:"TC"],
                [name:"Tuvalu",code:"TV"],
                [name:"U.S. Virgin Islands",code:"VI"],
                [name:"Uganda",code:"UG"],
                [name:"Ukraine",code:"UA"],
                [name:"United Arab Emirates",code:"AE"],
                [name:"United Kingdom",code:"GB"],
                [name:"United States",code:"US"],
                [name:"Uruguay",code:"UY"],
                [name:"Uzbekistan",code:"UZ"],
                [name:"Vanuatu",code:"VU"],
                [name:"Vatican",code:"VA"],
                [name:"Venezuela",code:"VE"],
                [name:"Vietnam",code:"VN"],
                [name:"Wallis and Futuna",code:"WF"],
                [name:"Western Sahara",code:"EH"],
                [name:"Yemen",code:"YE"],
                [name:"Zambia",code:"ZM"],
                [name:"Zimbabwe",code:"ZW"],
        ].toArray()
    }

    def getTimeZoneData(){
        return [
                [description: "(GMT-12:00) International Date Line West", code: -12.00],
                [description: "(GMT-11:00) Midway Island, Samoa", code: -11.00],
                [description: "(GMT-10:00) Hawaii", code:  -10.00],
                [description: "(GMT-09:00) Alaska", code:  -09.00],
                [description: "(GMT-08:00) Pacific Time (US and Canada); Tijuana", code:  -08.00],
                [description: "(GMT-07:00) Mountain Time (US and Canada)", code:  -07.00],
                [description: "(GMT-07:00) Chihuahua, La Paz, Mazatlan", code:  -07.00],
                [description: "(GMT-07:00) Arizona", code:  -07.00],
                [description: "(GMT-06:00) Central Time (US and Canada)", code:  -06.00],
                [description: "(GMT-06:00) Saskatchewan" -06.00],
                [description: "(GMT-06:00) Guadalajara, Mexico City, Monterrey", code:  -06.00],
                [description: "(GMT-06:00) Central America", code:  -06.00],
                [description: "(GMT-05:00) Eastern Time (US and Canada)", code:  -05.00],
                [description: "(GMT-05:00) Indiana (East)", code:  -05.00],
                [description: "(GMT-05:00) Bogota, Lima, Quito", code:  -05.00],
                [description: "(GMT-04:00) Atlantic Time (Canada)", code:  -04.00],
                [description: "(GMT-04:00) Caracas, La Paz", code:  -04.00],
                [description: "(GMT-04:00) Santiago" -04.00],
                [description: "(GMT-03:30) Newfoundland and Labrador", code:  -03.30],
                [description: "(GMT-03:00) Brasilia" -03.00],
                [description: "(GMT-03:00) Buenos Aires, Georgetown", code:  -03.00],
                [description: "(GMT-03:00) Greenland", code:  -03.00],
                [description: "(GMT-02:00) Mid-Atlantic", code:  -02.00],
                [description: "(GMT-01:00) Azores", code:  -01.00],
                [description: "(GMT-01:00) Cape Verde Islands", code:  -01.00],
                [description: "(GMT) Greenwich Mean Time: Dublin, Edinburgh, Lisbon, London", code: 00],
                [description: "(GMT) Casablanca, Monrovia", code: 00],
                [description: "(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague", code:  +01.00],
                [description: "(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb", code:  +01.00],
                [description: "(GMT+01:00) Brussels, Copenhagen, Madrid, Paris", code:  +01.00],
                [description: "(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna", code:  +01.00],
                [description: "(GMT+01:00) West Central Africa", code:  +01.00],
                [description: "(GMT+02:00) Bucharest", code:  +02.00],
                [description: "(GMT+02:00) Cairo", code:  +02.00],
                [description: "(GMT+02:00) Helsinki, Kiev, Riga, Sofia, Tallinn, Vilnius", code:  +02.00],
                [description: "(GMT+02:00) Athens, Istanbul, Minsk", code:  +02.00],
                [description: "(GMT+02:00) Jerusalem", code:  +02.00],
                [description: "(GMT+02:00) Harare, Pretoria", code:  +02.00],
                [description: "(GMT+03:00) Moscow, St. Petersburg, Volgograd", code:  +03.00],
                [description: "(GMT+03:00) Kuwait, Riyadh", code:  +03.00],
                [description: "(GMT+03:00) Nairobi", code:  +03.00],
                [description: "(GMT+03:00) Baghdad", code:  +03.00],
                [description: "(GMT+03:30) Tehran", code:  +03.30],
                [description: "(GMT+04:00) Abu Dhabi, Muscat", code:  +04.00],
                [description: "(GMT+04:00) Baku, Tbilisi, Yerevan", code:  +04.00],
                [description: "(GMT+04:30) Kabul", code:  +04.30],
                [description: "(GMT+05:00) Ekaterinburg", code:  +05.00],
                [description: "(GMT+05:00) Islamabad, Karachi, Tashkent", code:  +05.00],
                [description: "(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi", code:  +05.30],
                [description: "(GMT+05:45) Kathmandu", code:  +05.45],
                [description: "(GMT+06:00) Astana, Dhaka", code:  +06.00],
                [description: "(GMT+06:00) Sri Jayawardenepura", code:  +06.00],
                [description: "(GMT+06:00) Almaty, Novosibirsk", code:  +06.00],
                [description: "(GMT+06:30) Yangon Rangoon", code:  +06.30],
                [description: "(GMT+07:00) Bangkok, Hanoi, Jakarta", code:  +07.00],
                [description: "(GMT+07:00) Krasnoyarsk", code:  +07.00],
                [description: "(GMT+08:00) Beijing, Chongqing, Hong Kong SAR, Urumqi", code:  +08.00],
                [description: "(GMT+08:00) Kuala Lumpur, Singapore", code:  +08.00],
                [description: "(GMT+08:00) Taipei" +08.00],
                [description: "(GMT+08:00) Perth" +08.00],
                [description: "(GMT+08:00) Irkutsk, Ulaanbaatar", code:  +08.00],
                [description: "(GMT+09:00) Seoul" +09.00],
                [description: "(GMT+09:00) Osaka, Sapporo, Tokyo", code:  +09.00],
                [description: "(GMT+09:00) Yakutsk", code:  +09.00],
                [description: "(GMT+09:30) Darwin", code:  +09.30],
                [description: "(GMT+09:30) Adelaide", code:  +09.30],
                [description: "(GMT+10:00) Canberra, Melbourne, Sydney", code:  +10.00],
                [description: "(GMT+10:00) Brisbane", code:  +10.00],
                [description: "(GMT+10:00) Hobart", code:  +10.00],
                [description: "(GMT+10:00) Vladivostok", code:  +10.00],
                [description: "(GMT+10:00) Guam, Port Moresby", code:  +10.00],
                [description: "(GMT+11:00) Magadan, Solomon Islands, New Caledonia", code:  +11.00],
                [description: "(GMT+12:00) Fiji Islands, Kamchatka, Marshall Islands", code:  +12.00],
                [description: "(GMT+12:00) Auckland, Wellington", code:  +12.00],
                [description: "(GMT+13:00) Nuku'alofa", code:  +13.00],
        ].toArray()
    }

    def getBOMInstructionType(){
        return ["Mandatory","Optional","Informational"].toArray()
    }

    def getReceiptTypes(){
        return ["Customer Return"].toArray()
    }


}

