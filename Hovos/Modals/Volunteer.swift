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
    var image:images?
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
    var schedules:[Schedules]?
    var friends:[friends]?
    var member:ListingUser?
    var reviews:[review]?
    var mealDescription:String?
    var paymentDescription:String?
    var totalMatching:String?
    func getFullimage(completion:@escaping (UIImage?)->()){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:(self.image?.medium!)!)!)
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
    init() {
        self.latitude = ""
        self.longitude = ""
        self.city = ""
        self.country = ""
        self.countryCode = ""
        self.countryId = ""
        self.location = ""
        }
    
    init(latitude:String,city:String,country:String,countryCode:String,countryId:String,location:String,longitude:String) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.countryId = countryId
        self.location = location
    }
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



struct Schedules:Codable {
    var end:String
    var start:String
}

struct friends:Codable {
    
}


struct ListingUser:Codable {
    var additionalDesc:String?
    var age:String?
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
    var rating:ratings?

   
    private enum CodingKeys : String, CodingKey {
        case additionalDesc = "additionalDesc"
        case appToken = "appToken"
        case autoRenew = "autoRenew"
        case currency = "currency"
        case currencyCode = "currencyCode"
        case currencySign = "currencySign"
        case email = "email"
        case expiredOn = "expiredOn"
        case firstName = "firstName"
        case fid_autoRenew = "fid_autoRenew"
        case fid_spammer = "fid_spammer"
        case gender = "gender"
        case id = "id"
        case image = "image"
        case isDocumentVerified = "isDocumentVerified"
        case isEmailverified = "isEmailverified"
        case isPaid = "isPaid"
        case isPhoneVerified = "isPhoneVerified"
        case language = "language"
        case languageDescription = "languageDescription"
        case lastName = "lastName"
        case listingId = "listingId"
        case password = "password"
        case personalDescription = "personalDescription"
        case phoneNumber = "phoneNumber"
        case renewalAmount = "renewalAmount"
        case type = "type"
        case role = "role"
        case languages = "languages"
        case rating = "ratings"
        case age = "age"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let stringage =  try? values.decode(String.self, forKey: .age){
            age = stringage
        }
        if let intAge = try?  values.decode(Int.self, forKey: .age){
               age = String(intAge)
           }
        
         additionalDesc =  try? values.decode(String.self, forKey: .additionalDesc)
         age =  try? values.decode(String.self, forKey: .age)
         appToken =  try? values.decode(String.self, forKey: .appToken)
         autoRenew =  try? values.decode(String.self, forKey: .autoRenew)
         currency =  try? values.decode(String.self, forKey: .currency)
         currencyCode =  try? values.decode(String.self, forKey: .currencyCode)
         currencySign =  try? values.decode(String.self, forKey: .currencySign)
         email =  try? values.decode(String.self, forKey: .email)
         expiredOn =  try? values.decode(String.self, forKey: .expiredOn)
         firstName =  try? values.decode(String.self, forKey: .firstName)
         fid_autoRenew =  try? values.decode(String.self, forKey: .fid_autoRenew)
         fid_spammer =  try? values.decode(String.self, forKey: .fid_spammer)
         gender =  try? values.decode(String.self, forKey: .gender)
         id =  try? values.decode(String.self, forKey: .id)
         image =  try? values.decode(images.self, forKey: .image)
         isDocumentVerified =  try? values.decode(String.self, forKey: .isDocumentVerified)
         isEmailverified =  try? values.decode(String.self, forKey: .isEmailverified)
         isPaid =  try? values.decode(String.self, forKey: .isPaid)
         isPhoneVerified =  try? values.decode(String.self, forKey: .isPhoneVerified)
        language =  try? values.decode(String.self, forKey: .language)
        languageDescription =  try? values.decode(String.self, forKey: .languageDescription)
        lastName =  try? values.decode(String.self, forKey: .lastName)
        listingId =  try? values.decode(String.self, forKey: .listingId)
        password =  try? values.decode(String.self, forKey: .password)
        personalDescription =  try? values.decode(String.self, forKey: .personalDescription)
        phoneNumber =  try? values.decode(String.self, forKey: .phoneNumber)
        renewalAmount =  try? values.decode(String.self, forKey: .renewalAmount)
        type =  try? values.decode(String.self, forKey: .type)
        role =  try? values.decode(String.self, forKey: .role)
        languages =  try? values.decode([String:String].self, forKey: .languages)
        rating =  try? values.decode(ratings.self, forKey: .rating)
        
    }
    
}
