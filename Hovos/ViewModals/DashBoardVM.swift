//
//  DashBoardVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/7/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class DashBoardVM {
    var mapItems:[VolunteerItem]?
    var recommendedItems:[VolunteerItem]?
    var latestItems:[VolunteerItem]?
    
    var dispatchGroup = DispatchGroup()
    
    func getVolunteersData(completion:@escaping ()->()){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.id ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var recommendedRequest = NetworkPacket()
        recommendedRequest.apiPath = ApiEndPoints.volunteersRecommended.rawValue
        recommendedRequest.header = header
        recommendedRequest.method = "GET"
        
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                print("dataRecieve")
            }
        }
    }
    func getHostsData(completion:@escaping ()->()){
       let header = ["auth":SharedUser.manager.auth.auth ?? "",
                            "id":SharedUser.manager.auth.id ?? "",
                            "API_KEY":constants.Api_key.rawValue]
        var recommendedRequest = NetworkPacket()
             recommendedRequest.apiPath = ApiEndPoints.hostsRecommended.rawValue
             recommendedRequest.header = header
             recommendedRequest.method = "GET"
        
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                print("dataRecieve")
            }
        }
    }
}
