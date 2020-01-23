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
    case volunteers
    case hostByLocation
    case allHosts
    case facetData
    case nearByHost(lat:Double,long:Double,radius:Int,min_offset:Int,max_offset:Int)
        
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
        case .volunteers:
            return "/api/get/travellers/latest/"
        case .hostByLocation:
              return "/api/get/hosts/nearby/"
        case .allHosts:
            return "/api/get/hosts/all/"
        case .facetData:
            return "/api/get/hosts/all/"
        case .nearByHost(let lat, let long, let radius, let min_offset, let max_offset):
             let first = "/api/get/hosts/nearby/?latlng=" + String(lat) + "|" + String(long)
             let second = first + "&radius=" + String(radius)
             let third = second +  "&min_offset=" + String(min_offset) + "&max_offset=" + String(max_offset)
             return third
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
