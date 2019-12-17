//
//  NetworkPackets.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
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
    var header:[String:String] = [:]
    var data:[String:Any] = [:]
    var encoding:URLEncoding?
}
func ApiCall(packet:NetworkPacket,completion: @escaping (Data?,Bool,Int)->()){
    Alamofire.request(packet.url!, method: HTTPMethod(rawValue: packet.method!)!, parameters: packet.data, encoding: packet.encoding!, headers: packet.header).responseJSON { (response) in
        if response.response?.statusCode == 200 || response.response?.statusCode == 201{
            completion(response.data!, true, 200)
        }else{
            completion(nil, false, response.response?.statusCode ?? 0)
        }
    }
}
