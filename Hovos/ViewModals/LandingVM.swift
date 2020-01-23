//
//  LandingVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/29/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
class LandingVM {
    var VolunteerList:Volunteer!

    func getVolunteerList()  {
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.volunteers.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                self.VolunteerList = try! decoder.decode(Volunteer.self, from: data!)
                
                
            }else{
             
            }
        }
    }
    
    func getNearByHosts(location:CLLocation, completion:@escaping ([VolunteerItem]?)->()){
    
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "www.hovos.com"
            urlComponents.path = ApiEndPoints.hostByLocation.rawValue
            urlComponents.queryItems = [
                URLQueryItem(name: "latlng", value: "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"),
                URLQueryItem(name: "radius", value: String(500)),
                URLQueryItem(name: "min_offset", value: String(500)),
                URLQueryItem(name: "min_offset", value: String(500))
            ]
            
            let url =  URL(string: (urlComponents.url?.absoluteString)!)
            getApiCall(url: url! ) { (data, status, code) in
                if code == 200{
                    let decoder =  JSONDecoder()
                    if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                        completion(Volunteer.hosts)
                    }
                }else{
                    completion(nil)
                }
            }
        
    }
    
    
    private func getfacetdata(){
       
       
    }
}


