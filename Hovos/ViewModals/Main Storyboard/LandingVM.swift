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
import CoreLocation
class LandingVM {
    var location:CLLocation!
    var Hosts:[VolunteerItem]!
    var Volunteers:Volunteer?
    func getVolunteerList(_ minOffeset:Int = 0,_ maxOffset:Int = 12, completion:@escaping (Volunteer?)->())  {
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.volunteersAll.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let VolunteerList = try! decoder.decode(Volunteer.self, from: data!)
                self.Volunteers = VolunteerList
                completion(VolunteerList)
                
            }else{
                completion(nil)
            }
        }
    }
    
    func getRecommendedVolunteer(_ minOffeset:Int = 0,_ maxOffset:Int = 12, completion:@escaping (Volunteer?)->())  {
        var packet = NetworkPacket()
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        packet.apiPath = ApiEndPoints.volunteersRecommended.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.header = header
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let VolunteerList = try! decoder.decode(Volunteer.self, from: data!)
                self.Volunteers = VolunteerList
                completion(VolunteerList)
                
            }else{
                completion(nil)
            }
        }
    }
    
    
    func getLatestVolunteer(_ minOffeset:Int = 0,_ maxOffset:Int = 12, completion:@escaping (Volunteer?)->())  {
        var packet = NetworkPacket()
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        packet.apiPath = ApiEndPoints.volunteersLatest.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.header = header
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let VolunteerList = try! decoder.decode(Volunteer.self, from: data!)
                self.Volunteers = VolunteerList
                completion(VolunteerList)
                
            }else{
                completion(nil)
            }
        }
    }
    
    func getNearByHosts(_ minOffeset:Int = 0,_ maxOffset:Int = 12,completion:@escaping ([VolunteerItem]?)->()){
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.hovos.com"
        urlComponents.path = ApiEndPoints.hostByLocation.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "latlng", value: "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"),
            URLQueryItem(name: "radius", value: String(500)),
            URLQueryItem(name: "min_offset", value: String(minOffeset)),
            URLQueryItem(name: "max_offset", value: String(maxOffset))
        ]
        
        let url =  URL(string: (urlComponents.url?.absoluteString)!)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let volunteer = try! decoder.decode(Volunteer.self, from: data!)
                self.Hosts = volunteer.hosts
                completion(volunteer.hosts)
                
            }
        }
    }
    
    func getAllHosts(_ minOffeset:Int = 0,_ maxOffset:Int = 12,completion:@escaping (Volunteer?)->()){
        
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.hostsAll.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let volunteerList = try! decoder.decode(Volunteer.self, from: data!)
                completion(volunteerList)
                
            }else{
                completion(nil)
            }
        }
        
    }
    
    
    func getRecommenededHosts(_ minOffeset:Int = 0,_ maxOffset:Int = 12,completion:@escaping (Volunteer?)->()){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue,
                      "id":SharedUser.manager.auth.user?.listingId ?? ""]
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.hostsRecommended.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        packet.header = header
        ApiCall(packet: packet) { (data, status, code) in
            DispatchQueue.main.async {
                if code == 200{
                    let decoder =  JSONDecoder()
                    let volunteerList = try! decoder.decode(Volunteer.self, from: data!)
                    completion(volunteerList)
                    
                }else{
                    completion(nil)
                }
            }
        }
    }
    
    func getLatestHosts(_ minOffeset:Int = 0,_ maxOffset:Int = 12,completion:@escaping (Volunteer?)->()){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue,
                      "id":SharedUser.manager.auth.user?.listingId ?? ""]
        
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.hostsLatest.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        packet.url = packet.url! + "?&min_offset=\(minOffeset)"
        packet.url = packet.url! + "&max_offset=\(maxOffset)"
        packet.header = header
        ApiCall(packet: packet) { (data, status, code) in
            DispatchQueue.main.async {
                if code == 200{
                    let decoder =  JSONDecoder()
                    let volunteerList = try! decoder.decode(Volunteer.self, from: data!)
                    completion(volunteerList)
                }else{
                    completion(nil)
                }
            }
        }
        
    }
    
    func getHostBySearch(modal:HostSearchModel,completion:@escaping ([VolunteerItem]?)->()){
        var str = "https://www.hovos.com\(ApiEndPoints.hostsAll.rawValue)?"
        var qs = ""
        qs = qs + "cntry=\(modal.cntry ?? "")"
        qs = qs + "&conti=\(modal.conti ?? "")"
        qs = qs + "&dt=\(modal.queryDate ?? "")"
        qs = qs + "&jobs=\(modal.jobs.joined(separator: "|"))"
        qs = qs + "&latlng=\(modal.latlng ?? "")"
        qs = qs + "&qs=\(modal.qs ?? "")"
        str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url =  URL(string: str)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let volunteer = try! decoder.decode(Volunteer.self, from: data!)
                self.Hosts = volunteer.hosts
                completion(volunteer.hosts)
                
            }else{
                self.getHostBySearch(modal: modal, completion: completion)
            }
        }
        
        
    }
    
    
    func getHostBySearchWithSearchItems(modal:HostSearchModel,completion:@escaping (Volunteer?)->()){
        var str = "https://www.hovos.com\(ApiEndPoints.hostsAll.rawValue)?"
        var qs = ""
        qs = qs + "&min_offset=\(modal.min_offset)"
        qs = qs + "&max_offset=\(modal.max_offset)"
        qs = qs + "&cntry=\(modal.cntry ?? "")"
        qs = qs + "&conti=\(modal.conti ?? "")"
        qs = qs + "&dt=\(modal.queryDate ?? "")"
        qs = qs + "&jobs=\(modal.jobs.joined(separator: "|"))"
        qs = qs + "&latlng=\(modal.latlng ?? "")"
        qs = qs + "&qs=\(modal.qs ?? "")"
        str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url =  URL(string: str)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                let volunteer = try! decoder.decode(Volunteer.self, from: data!)
                completion(volunteer)
                
            }else{
                
                self.getHostBySearchWithSearchItems(modal: modal, completion: completion)
            }
        }
        
        
    }
    
    private func getfacetdata(){
    }
}


