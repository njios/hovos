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
    var dispatchGroup = DispatchGroup()
    var locationManager = CLLocationManager()
    var callback:(()->())!
    
    
    
    private func getVolunteersData(){
        
        // recommended volunteer
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.id ?? "",
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
            URLQueryItem(name: "latlng", value: "\(String(locationManager.location!.coordinate.latitude))|\(String(locationManager.location!.coordinate.longitude))"),
            URLQueryItem(name: "radius", value: String(500)),
            URLQueryItem(name: "min_offset", value: String(0)),
            URLQueryItem(name: "min_offset", value: String(0))
        ]
        
        let url =  URL(string: (urlComponents.url?.absoluteString)!)
        
        dispatchGroup.enter()
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.mapItems = Volunteer.travellers!
                }
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.recommendedItems = Volunteer.travellers!
                }
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ApiCall(packet: latestRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.latestItems = Volunteer.travellers!
                }
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            self.callback()
        }
    }
    func getLocation(completion:@escaping ()->()){
        locationManager.delegate = self
        if locationManager.location != nil{
            if SharedUser.manager.auth.role!.lowercased() == "h"{
                getVolunteersData()
            }else{
                getHostsData()
            }
        }else{
            locationManager.startUpdatingLocation()
        }
        callback = completion
    }
    func getHostsData(){
      
        // recommended volunteer
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.id ?? "",
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
            URLQueryItem(name: "latlng", value: "\(String(locationManager.location!.coordinate.latitude))|\(String(locationManager.location!.coordinate.longitude))"),
            URLQueryItem(name: "radius", value: String(500)),
            URLQueryItem(name: "min_offset", value: String(0)),
            URLQueryItem(name: "min_offset", value: String(0))
        ]
        
        let url =  URL(string: (urlComponents.url?.absoluteString)!)
        
        dispatchGroup.enter()
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.mapItems = Volunteer.hosts!
                }
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ApiCall(packet: recommendedRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.recommendedItems = Volunteer.hosts!
                }
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ApiCall(packet: latestRequest) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.latestItems = Volunteer.hosts!
                }
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            self.callback()
        }
    }
}

extension DashBoardVM:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if SharedUser.manager.auth.role!.lowercased() == "h"{
            getVolunteersData()
        }else{
            getHostsData()
        }
        manager.stopUpdatingLocation()
        
    }
}
