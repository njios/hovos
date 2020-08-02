//
//  Constants.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
typealias returntype = (Bool)->()
enum constants:String{
    case accessToken = "login"
    case Api_key = "HOVOS-842145-API"
    case BaseUrl = "https://www.hovos.com"
    case testPaymentKey = "10001|8CCC18B1AE672FA48967D7D69AF0A0A52FF241D775AA05E27CD5027DF928E4B11AC83BE68DA6D7A9FCF8AACC6DFE425580B05F77D984213E5DAED5DEEB362181838807A1118C9502FC48916FDA83DE484F5EB062342CFD98FE3A385623BA3B7F4A342F9F0F6C49AB5E0D5EA49365C4AF7A03880D463B51B4367498AF5ADB6CB97C6A2A1BD3013891DD9BA5A5129C7AB48DFD7AD66B724B5D32464175EB845DE26896D72B6528D198B90A905CF47F4EDDF11657F7AE3CD15F16E5133D15F6F76F453BA65F6CF3F97AFBCB768B3E5D6F30E1B2DC67F11B55A77BCD6541F2572F157C1DE57D8CE4939A7C2B31FE9FC55ABA47EF34F1AA385677EF08B4D9DA794D15"
    
    //"10001|D185DF0D7F539E8EE32953188F2E6E9446DED5DC615E01D30C57218C96242CEF163C463920B4FFBA7C694D062CA0A700EC56A98CA35037C3A5C60AAEBFAD546F133611FBAF542C8766F0A2DAEDC582FE4725609C6C07B3109C91AD4A3EA6DDB382DA2B625D9D738A41EA365B094C67B36D9F48E3C2AC96A1DBCEBFE4B10D72A45F77C70392F916BDD9F5FC7BC58491A4BAC30505C761FF90C5D64470E910EEAD8E7E5122442EC96216A1FFCA4E88B9FDE4E60825B80BF25AFEE0FC9C09CA194A5A7D59E4DE387C14E6D338CCC3704E4C99FB38A0CB76931FFB9B7C9656328689C09B7ED78FA9997D0D60E79F78ACEE0D9BC8006BF03923B23943194C813FA0EB"
    
    //"10001|8CCC18B1AE672FA48967D7D69AF0A0A52FF241D775AA05E27CD5027DF928E4B11AC83BE68DA6D7A9FCF8AACC6DFE425580B05F77D984213E5DAED5DEEB362181838807A1118C9502FC48916FDA83DE484F5EB062342CFD98FE3A385623BA3B7F4A342F9F0F6C49AB5E0D5EA49365C4AF7A03880D463B51B4367498AF5ADB6CB97C6A2A1BD3013891DD9BA5A5129C7AB48DFD7AD66B724B5D32464175EB845DE26896D72B6528D198B90A905CF47F4EDDF11657F7AE3CD15F16E5133D15F6F76F453BA65F6CF3F97AFBCB768B3E5D6F30E1B2DC67F11B55A77BCD6541F2572F157C1DE57D8CE4939A7C2B31FE9FC55ABA47EF34F1AA385677EF08B4D9DA794D15"
    
    func remove(){
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}

enum ApiEndPoints{
    case login
    case signup
    case forgetPassword
    case changePassword
    case volunteersLatest
    case volunteersRecommended
    case volunteersNearBy
    case volunteersAll
    case hostByLocation
    case hostsAll
    case hostsRecommended
    case hostsLatest
    case facetData
    case volunteerFacet
    case jobs
    case languages
    case accomodation
    case user
    case smsOtp
    case contactUs
    case paymentMethod
    case paymentProcess
    case getMessages
    case userSave
    case volunteerStatus
    case transactions
    case postMessages
    case FavVolunteer
    case FavHosts
    case otpVerify(otp:String)
    case vol_Registration(id:String)
    case host_Registration(id:String)
    case travellerPublish(id:String)
    case hostPublished(id:String)
    var rawValue:String{
        switch self {
        case .login:
            return "/api/user/login/"
        case .signup:
            return "/api/user/"
        case .forgetPassword:
            return "/api/user/forgot_password"
        case .changePassword:
            return "/api/user/reset_password/"
        case .volunteersLatest:
            return "/api/get/travellers/latest/"
        case .volunteersAll:
            return "/api/get/travellers/all/"
        case .volunteersRecommended:
            return "/api/traveller/recommended/"
        case .volunteersNearBy:
            return "/api/get/travellers/nearby/"
        case .hostByLocation:
            return "/api/get/hosts/nearby/"
        case .hostsRecommended:
            return "/api/host/recommended/"
            
        case .hostsAll:
            return "/api/get/hosts/all/"
        case .hostsLatest:
            return "/api/get/hosts/latest/"
        case .facetData:
            return "/api/get/hosts/facet/"
            
        case .volunteerFacet:
            return "/api/get/travellers/facet/"
        case .jobs:
            return "/api/get/jobs"
        case .languages:
            return "/api/get/languages"
        case .accomodation:
            return "/api/get/accommodations"
        case .user:
            return "/api/user/"
        case .smsOtp:
            return "/api/user/otp/"
        case .contactUs:
            return "/page/contact_us/"
        case .paymentMethod:
            return "/api/adyen/payment_methods/"
        case .paymentProcess:
            return "/api/adyen/process/"
        case .getMessages:
            return "/api/user/messages/all/"
            
        case .userSave:
            return "/api/user/save"
            
        case .volunteerStatus:
            return "/api/traveller/status/"
            
        case .transactions:
            return "/api/get/transactions"
        case .postMessages:
            return "/api/user/message/"
        case .FavHosts:
            return "/api/user/config/favorite_hosts"
        case .FavVolunteer:
            return "/api/user/config/favorite_volunteers"
        case .otpVerify(let otp):
            return "/api/user/verify_otp/\(otp)"
            
        case .vol_Registration(let id):
            return "/api/traveller/\(id)"
        case .host_Registration(let id):
            return "/api/host/\(id)"
        case .hostPublished(let id):
            return "/api/host/publish/\(id)"
        case .travellerPublish(let id):
            return "/api/traveller/publish/\(id)"
        }
    }
    
    
}

enum CalenderMonth{
    
    case month(month:Int)
    case monthInString(month:String)
    func getMonth()->String{
        switch self {
        case .month(let month):
            switch month {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "Aug"
            case 9:
                return "Sept"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
            default:
                return ""
            }
        case .monthInString(let month):
            switch month {
            case "Jan":
                return "1"
            case "Feb":
                return "2"
            case "Mar":
                return "3"
            case "Apr":
                return "4"
            case "May":
                return "5"
            case "Jun":
                return "6"
            case "Jul":
                return "7"
            case "Aug":
                return "8"
            case "Sep":
                return "9"
            case "Oct":
                return "10"
            case "Nov":
                return "11"
            case "Dec":
                return "12"
            default:
                return ""
            }
        }
    }
}
