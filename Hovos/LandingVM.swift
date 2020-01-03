//
//  LandingVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/29/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire
class LandingVM {

    
    
    var VolunteerList:Volunteer!
    
    
    func getVolunteerList(completion:@escaping (Bool)->())  {
        var packet = NetworkPacket()
                packet.apiPath = ApiEndPoints.volunteers.rawValue
                packet.method = HTTPMethod.get.rawValue
                packet.encoding = Alamofire.URLEncoding.httpBody
                ApiCall(packet: packet) { (data, status, code) in
                    if code == 200{
                        let decoder =  JSONDecoder()
                        self.VolunteerList = try! decoder.decode(Volunteer.self, from: data!)
                        
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }
    
    

}
