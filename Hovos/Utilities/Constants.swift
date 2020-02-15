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
    case hostsRecommended
    case hostsLatest
    case facetData
    case jobs
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
        case .hostsLatest:
            return "/api/get/hosts/latest/"
        case .facetData:
            return "/api/get/hosts/facet/"
        case .jobs:
            return "/api/get/jobs"
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
