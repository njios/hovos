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
    case BaseUrl = "https://www.hovos.com"
    func remove(){
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}
