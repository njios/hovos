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
