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
    var title:String?
    var isPaid:String?
    var addedOn:String?
    var photo:String?
    var slogan:String?
    var status:String?
    var isPublished:String?
    var lang:String?
    var lastLogin:String?
    var description:String?
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
    var workingDays:String?
    var workingHours:String?
    var slug:String?
    var additionalDesc:String?
    var languageDesc:String?
    var skillDescription:String?
    var placeDescription:String?
    var rating:Int?
    var likes:String?
    var dislikes:String?
    var location:location?
    var images:[images]?
    var accommodations:[String:String]?
    var accommodationImages:[images]?
    var jobs:[Int:String]?
    var countries:[String:String?]?
    var schedules:[schedules]?
    var friends:[friends]?
    var member:ListingUser?
    var reviews:[review]?
    var mealDescription:String?
    var paymentDescription:String?
    var totalMatching:String?
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
    var member:ListingUser?
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


struct ListingUser:Codable {
    var additionalDesc:String?
 
    var appToken:String?
    var autoRenew:String?
    var currency:String?
    var currencyCode:String?
    var currencySign:String?
    var email:String?
    var expiredOn:String?
    var firstName:String?
    var fid_autoRenew:String?
    var fid_spammer:String?
    var gender:String?
    var id:String?
    var image:images?
    var isDocumentVerified:String?
    var isEmailverified:String?
    var isPaid:String?
    var isPhoneVerified:String?
    var language:String?
    var languageDescription:String?
    var lastName:String?
    var listingId:String?
    var password:String?
    var personalDescription:String?
    var phoneNumber:String?
    var renewalAmount:String?
    var type:String?
    var role:String?
    var languages:[String:String]?
    var ratings:ratings?
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        if let value = try? container.decode(Int.self, forKey: .age) {
//            age = String(value)
//        } else {
//            age = try container.decode(String.self, forKey: .id)
//        }
//
//
//    }
    
    
}
