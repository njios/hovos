//
//  DashBoardVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/7/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
class DashBoardVM:NSObject {
    var mapItems = [VolunteerItem]()
    var recommendedItems = [VolunteerItem]()
    var latestItems = [VolunteerItem]()
   
    var location = CLLocation()
    var callback:((Int)->())!
    
    
    private func getVolunteersData(){
        
        // recommended volunteer
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var recommendedRequest = NetworkPacket()
        recommendedRequest.apiPath = ApiEndPoints.volunteersRecommended.rawValue
        recommendedRequest.header = header
        recommendedRequest.method = "GET"
        
        // latest volunteer
        var latestRequest = NetworkPacket()
        latestRequest.apiPath = ApiEndPoints.volunteersLatest.rawValue
        latestRequest.method = "GET"
        
        // NearBy Volunteer
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.hovos.com"
        urlComponents.path = ApiEndPoints.volunteersNearBy.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "latlng", value: "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"),
            URLQueryItem(name: "radius", value: String(500)),
            URLQueryItem(name: "min_offset", value: String(0)),
            URLQueryItem(name: "min_offset", value: String(0))
        ]
        
        let url =  URL(string: (urlComponents.url?.absoluteString)!)
        
      
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.mapItems = Volunteer.travellers!
                     self.callback(0)
                }
            }
          
        }
        
        
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.recommendedItems = Volunteer.travellers!
                     self.callback(1)
                }
            }
          
        }
       
        ApiCall(packet: latestRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.latestItems = Volunteer.travellers!
                     self.callback(2)
                }
            }
          
        }
       
           
        
    }
    
    
    
   
    
    func getLocation(location:CLLocation, completion:@escaping (Int)->()){
        
        self.location = location
        
            if SharedUser.manager.auth.role!.lowercased() == "h"{
                getVolunteersData()
            }else{
                getHostsData()
            }
       
          
        
        callback = completion
    }
    
    func getHostsData(){
      
        // recommended volunteer
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var recommendedRequest = NetworkPacket()
        recommendedRequest.apiPath = ApiEndPoints.hostsRecommended.rawValue
        recommendedRequest.header = header
        recommendedRequest.method = "GET"
        
        // latest volunteer
        var latestRequest = NetworkPacket()
        latestRequest.apiPath = ApiEndPoints.hostsLatest.rawValue
        latestRequest.method = "GET"
        
        // NearBy Volunteer
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.hovos.com"
        urlComponents.path = ApiEndPoints.hostByLocation.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "latlng", value: "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"),
            URLQueryItem(name: "radius", value: String(500)),
            URLQueryItem(name: "min_offset", value: String(0)),
            URLQueryItem(name: "min_offset", value: String(0))
        ]
        
        let url =  URL(string: (urlComponents.url?.absoluteString)!)
        
       
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.mapItems = Volunteer.hosts!
                    self.callback(0)
                }
            }
       
        }
        
  
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.recommendedItems = Volunteer.hosts!
                     self.callback(1)
                }
            }
   
        }

        ApiCall(packet: latestRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.latestItems = Volunteer.hosts!
                     self.callback(2)
                }
            }
        }
    }
}

