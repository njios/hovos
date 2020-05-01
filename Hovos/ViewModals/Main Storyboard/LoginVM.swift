//
//  LoginVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
class LoginVM {
    var callBack:((Bool,Data?)->())!
    func signUp(emailId:String,password:String, completion: @escaping (Bool,Data?)->()){
         var packet = NetworkPacket()
        callBack = completion
         packet.apiPath = ApiEndPoints.login.rawValue
         packet.data = ["email":emailId,
                        "password":password,
                        "apptoken":"testtoken123",
                        ]
        
         packet.method = HTTPMethod.post.rawValue
         packet.encoding = Alamofire.URLEncoding.httpBody
         ApiCall(packet: packet) { (data, status, code) in
             if code == 200{
                UserDefaults.standard.set(data!, forKey: constants.accessToken.rawValue)
                completion(true,data)
            
                 
             }else{
                 completion(false,data)
             }
         }
     }
    
    
}
