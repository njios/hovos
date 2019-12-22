//
//  ChangePasswordVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/22/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
class  ChangePasswordVM: NSObject {
    
    func changePasswordService(emailId:String,password:String,code:String, completion: @escaping (Bool)->()){
         var packet = NetworkPacket()
         packet.apiPath = "/api/account/reset_password/"
        packet.data = ["email":emailId,"password":password,"code":code]
         packet.header = ["Content-Type":"application/x-www-form-urlencoded"]
         packet.method = HTTPMethod.post.rawValue
         packet.encoding = Alamofire.URLEncoding.httpBody
         ApiCall(packet: packet) { (data, status, code) in
             if code == 200{
                 completion(true)
             }else{
                 completion(false)
             }
         }
     }
}
