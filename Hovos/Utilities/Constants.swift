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
    case vol_publish(id:String)
    
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
            
        case .vol_publish(let id):
            return "/api/traveller/\(id)"
        }
    }
       
    
}

enum CalenderMonth{
    
    case month(month:Int)
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
        
        }
    }
}
