//
//  HostSearchVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/15/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire

class HostSearchVM{
    var jobs:[Jobs]!
    
   // var searchParam = HostSearch()
    
    func getJobs(completion:@escaping(()->())){
        var packet = NetworkPacket()
               packet.apiPath = ApiEndPoints.jobs.rawValue
               packet.method = HTTPMethod.get.rawValue
               packet.encoding = Alamofire.URLEncoding.httpBody
        
               ApiCall(packet: packet) { (data, status, code) in
                   if code == 200{
                     let decoder = JSONDecoder()
                     self.jobs = try? decoder.decode([Jobs].self, from: data!)
                       completion()
                   }else{
                       completion()
                   }
               }
    }
    
    
    
}
