//
//  NetworkPackets.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
struct NetworkPacket {
    var url:String?
    var apiPath:String?{
       // var completeUrl:String
        get{
            return url
        }set{
            url = constants.BaseUrl.rawValue + newValue!
        }
        
    }
    var method:String?
    var header:[String:String] = ["Content-Type":"application/x-www-form-urlencoded",
                                  "API_KEY":constants.Api_key.rawValue]
    var data:[String:Any] = [:]
    var encoding:URLEncoding?
    var rawData = Data()
}
func ApiCall(packet:NetworkPacket,completion: @escaping (Data?,Bool,Int)->()){
    
    Alamofire.request(packet.url!, method: HTTPMethod(rawValue: packet.method!)!, parameters: packet.data, encoding: packet.encoding ?? URLEncoding.default, headers: packet.header).responseJSON { (response) in

        if response.response?.statusCode == 200 || response.response?.statusCode == 201{
            completion(response.data!, true, 200)
        }else{
            completion(response.data, false, response.response?.statusCode ?? 0)
        }
    }
}

func ApiCallWithJsonEncoding(packet:NetworkPacket,completion: @escaping (Data?,Bool,Int)->()){
    
    Alamofire.request(packet.url!, method: HTTPMethod(rawValue: packet.method!)!, parameters: packet.data, encoding: JSONEncoding.default , headers: packet.header).responseJSON { (response) in

        if response.response?.statusCode == 200 || response.response?.statusCode == 201{
            completion(response.data!, true, 200)
        }else{
            completion(response.data, false, response.response?.statusCode ?? 0)
        }
    }
}

func getApiCall(url:URL,completion: @escaping (Data?,Bool,Int)->()){

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
        guard let res = response as? HTTPURLResponse else {
                 print(String(describing: error))
            return
        }
        if res.statusCode == 200 || res.statusCode == 201{
         completion(data, true, 200)
     }else{
         completion(data, false, res.statusCode )
     }
    }
    task.resume()
        
    
}


func postApiCall(packet:NetworkPacket,completion: @escaping (Data?,Bool,Int)->()){
    let url = URL(string: packet.url!)
    var request = URLRequest(url: url!)
    request.httpMethod = packet.method ?? "POST"
    request.allHTTPHeaderFields = packet.header
    request.httpBody = try! JSONSerialization.data(withJSONObject: packet.data, options: [])


    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
        guard let res = response as? HTTPURLResponse else {
                 print(String(describing: error))
            return
        }
        if res.statusCode == 200 || res.statusCode == 201{
         completion(data, true, 200)
     }else{
         completion(data, false, res.statusCode )
     }
    }
    task.resume()
        
    
}
