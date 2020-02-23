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
    var Volunteers:[VolunteerItem]!
    func getVolunteerList(completion:@escaping ([VolunteerItem]?)->())  {
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.volunteersAll.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let VolunteerList = try? decoder.decode(Volunteer.self, from: data!){
                    self.Volunteers = VolunteerList.travellers
                    completion(VolunteerList.travellers)
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getNearByHosts(completion:@escaping ([VolunteerItem]?)->()){
        
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
                    self.Hosts = Volunteer.hosts
                    completion(Volunteer.hosts)
                }
            }else{
                self.getNearByHosts(completion: completion)
            }
        }
        
    }
    
    func getHostBySearch(modal:HostSearchModel,completion:@escaping ([VolunteerItem]?)->()){
        var str = "https://www.hovos.com\(ApiEndPoints.hostsAll.rawValue)?"
        var qs = ""
        qs = qs + "cntry=\(modal.cntry ?? "")"
        qs = qs + "&conti=\(modal.conti ?? "")"
        qs = qs + "&dt=\(modal.dt ?? "")"
        qs = qs + "&jobs=\(modal.jobs.joined(separator: "|"))"
        qs = qs + "&latlng=\(modal.latlng ?? "")"
        qs = qs + "&qs=\(modal.qs ?? "")"
        str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url =  URL(string: str)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    self.Hosts = Volunteer.hosts
                    completion(Volunteer.hosts)
                }
            }else{
                self.getHostBySearch(modal: modal, completion: completion)
            }
        }
        
        
    }
    
    private func getfacetdata(){
    }
}


