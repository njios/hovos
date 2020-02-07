//
//  User.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/3/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct Auth:Codable {
    var auth:String?
    var id:String?
    var role:String?
    var user:User?
}

struct SharedUser{
    static var manager = SharedUser()
    var auth = Auth()
}

struct User:Codable {
    var additionalDesc:String?
    //var age:String?
    var appToken:String?
    var autoRenew:String?
    var currency:String?
    var currencyCode:String?
    var currencySign:String?
    var email:String?
    var expiredOn:String?
    var firstName:String?
    var fid_autoRenew:String?
    var fid_spammer:String?
    var gender:String?
    var id:String?
    var image:images?
    var isDocumentVerified:String?
    var isEmailverified:String?
    var isPaid:String?
    var isPhoneVerified:String?
    var language:String?
    var languageDescription:String?
    var lastName:String?
    var listingId:String?
    var password:String?
    var personalDescription:String?
    var phoneNumber:String?
    var renewalAmount:String?
    var type:String?
    var languages:[String:String]?
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        if let value = try? container.decode(Int.self, forKey: .age) {
//            age = String(value)
//        } else {
//            age = try container.decode(String.self, forKey: .id)
//        }
//
//
//    }
    
    
}



