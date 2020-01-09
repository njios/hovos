//
//  LandingVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/29/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class LandingVM {

    typealias returntype = (Bool)->()
    
    var VolunteerList:Volunteer!
    var Hosts:Volunteer!
    var callBack:returntype!
    var locationManger:CLLocationManager!
    var currentLocation:CurrentLocation!
    init() {
        currentLocation = CurrentLocation()
        locationManger = CLLocationManager()
        locationManger.delegate = currentLocation
        locationManger.requestLocation()
    }
    
    func getVolunteerList(completion:@escaping (Bool)->())  {
        callBack = completion
      
        var packet = NetworkPacket()
                packet.apiPath = ApiEndPoints.volunteers.rawValue
                packet.method = HTTPMethod.get.rawValue
                packet.encoding = Alamofire.URLEncoding.httpBody
                ApiCall(packet: packet) { (data, status, code) in
                    if code == 200{
                        let decoder =  JSONDecoder()
                        self.VolunteerList = try! decoder.decode(Volunteer.self, from: data!)

                        self.getNearByHosts()
                    }else{
                        completion(false)
                    }
                }
            }
    
    private func getNearByHosts(){
        
        if let location = locationManger.location{
           
     
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

            let url = URL(string: (urlComponents.url?.absoluteString)!)
               
            
            getApiCall(url: url! ) { (data, status, code) in
                                 if code == 200{
                                     let decoder =  JSONDecoder()
                                     self.Hosts = try! decoder.decode(Volunteer.self, from: data!)
                                    self.callBack(true)
                                     
                                 }else{
                                    self.callBack(true)
                                 }
                             }
            }
  
    }
}

class CurrentLocation:NSObject,CLLocationManagerDelegate{
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
