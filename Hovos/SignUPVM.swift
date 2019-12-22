//
//  SignUPVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
class SignUPVM: NSObject {
    
    func signUp(firstname:String,lastname:String,emailId:String,password:String,type:String, completion: @escaping (Bool,Data?)->()){
        var packet = NetworkPacket()
        packet.apiPath = "/api/account/"
        packet.data = ["email":emailId,
                       "password":password,
                       "apptoken":"testtoken123",
                       "firstName":firstname,
                       "lastName":lastname,
                       "type":type]
        packet.header = ["Content-Type":"application/x-www-form-urlencoded"]
        packet.method = HTTPMethod.post.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                completion(true,data)
            }else{
                
                completion(false,data)
            }
        }
    }
}


