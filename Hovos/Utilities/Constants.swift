//
//  Constants.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation

enum constants:String{
    case accessToken = "login"
    case Api_key = "HOVOS-842145-API"
    case BaseUrl = "https://www.hovos.com"
    func remove(){
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}

enum ApiEndPoints:String{
    case login = "/api/user/login/"
    case signup = "/api/user/"
    case forgetPassword = "/api/user/forgot_password"
    case changePassword = "/api/user/reset_password/"
    case volunteers = "/api/get/travellers/all"
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
