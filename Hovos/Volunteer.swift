//
//  Volunteer.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/29/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
struct Volunteer:Codable{
    var facetContinent:[facetContinent]?
    var facetCountry:[facetCountry]?
    var totalResults:Int?
    var travellers:[VolunteerItem]?
    var hosts:[VolunteerItem]?
}

struct facetContinent :Codable{
    var cnt:String?
    var id:String?
    var name:String?
}

struct facetCountry:Codable {
    var cnt:String?
    var id:String?
    var name:String?
    var fld_continentIdNo:String?
    var iso2:String?
}

struct VolunteerItem:Codable{
    var id:String?
    var memberId:String?
    var memberListingId:String?
    var isPaid:String?
    var photo:String?
    var slogan:String?
    var status:String?
    var isPublished:String?
    var lang:String?
    var lastLogin:String?
    var publishedOn:String?
    var isCompanion:String?
    var companionAge:String?
    var companionGender:String?
    var responseType:String?
    var currentLocation:String?
    var isFlaxibleDates:String?
    var companion:String?
    var image:String?
    var name:String?
    var slug:String?
    var additionalDesc:String?
    var languageDesc:String?
    var skillDescription:String?
    var placeDescription:String?
    var rating:String?
    var likes:String?
    var dislikes:String?
    var location:location?
    var images:[images]?
    var accommodations:[String]?
    var accommodationImages:[images]?
    var jobs:[String]?
    var countries:[String:String?]?
    var schedules:[schedules]?
    var friends:[friends]?
    var member:User?
    var reviews:[review]?
    func getFullimage(completion:@escaping (UIImage?)->()){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:(self.image!))!)
            let image = UIImage(data: data ?? Data())
           completion(image ?? UIImage())
        }
        
    }
}

struct location:Codable{
       var latitude:String?
       var city:String?
       var country:String?
       var countryCode:String?
       var countryId:String?
       var location:String?
       var longitude:String?
    }

struct review:Codable {
    var member:User?
    var age:Int?
    var review:String?
    var time:String?
}

struct images:Codable{
  // var id:Int?
   var large:String?
   var medium:String?
   var title:String?
}

struct schedules:Codable {
    var end:String?
    var start:String?
}

struct friends:Codable {
    
}


