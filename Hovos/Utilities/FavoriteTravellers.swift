//
//  FavoriteTravellers.swift
//  Hovos
//
//  Created by neeraj joshi on 30/08/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

class FavoriteData{
    
    static var shared = FavoriteData()
    
    var favoriteTravellers = [VolunteerItem]()
    var favoriteHosts = [VolunteerItem]()
    
     func getTravellers(){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var identifyYourself = NetworkPacket()
        identifyYourself.apiPath = ApiEndPoints.getTravellerFavorites.rawValue
        identifyYourself.header = header
        identifyYourself.method = "GET"
        ApiCall(packet: identifyYourself) { (data, status, code) in
            if  let vol = try? JSONDecoder().decode(Volunteer.self, from: data!){
                self.favoriteTravellers = vol.travellers!
            }
        }
    }
    
    func getHosts(){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var identifyYourself = NetworkPacket()
        identifyYourself.apiPath = ApiEndPoints.getHostfavorites.rawValue
        identifyYourself.header = header
        identifyYourself.method = "GET"
        ApiCall(packet: identifyYourself) { (data, status, code) in
            if let vol = try? JSONDecoder().decode(Volunteer.self, from: data!) {
            self.favoriteHosts = vol.hosts!
            }
        }
    }

    
}
