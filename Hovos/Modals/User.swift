//
//  User.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/3/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
struct Auth:Codable {
    var auth:String?
    var id:String?
    var role:String?
    var user:User?
    var listing:Listing?
}
struct Auth1:Codable {
    var auth:String?
    var id:String?
    var role:String?
    var user:User?
   
}
struct SharedUser{
    static var manager = SharedUser()
    var auth = Auth()
    
    func updateUser(){
        var packet = NetworkPacket()
               // recommended volunteer
               let header = ["auth":SharedUser.manager.auth.auth ?? "",
                                    "id":SharedUser.manager.auth.user?.listingId ?? "",
                                    "API_KEY":constants.Api_key.rawValue]
               let ob = try! JSONEncoder().encode(SharedUser.manager.auth.user!)
               packet.data = try! JSONSerialization.jsonObject(with: ob, options: []) as! [String : Any]
    
       
               packet.apiPath = ApiEndPoints.userSave.rawValue
      
               packet.header =  header
               packet.method = "POST"
               ApiCallWithJsonEncoding(packet: packet) { (data, status, code) in
                   print(status,code)
                let updatedObject = try! JSONEncoder().encode(SharedUser.manager.auth)
                UserDefaults.standard.set(updatedObject, forKey: constants.accessToken.rawValue)

               }
    }
}

struct Listing:Codable {
    var id:String?
    var memberId:String?
    var memberListingId:String?
    var title:String?
    var isPaid:String?
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
    var accommodations:[Int:String]?
    var accommodationImages:[images]?
    var jobs:[String:String]?
    var countries:[String:String?]?
    var schedules:[schedules]?
    var friends:[friends]?
    var member:User?
    var reviews:[review]?
    var mealDescription:String?
    var paymentDescription:String?
    func getFullimage(completion:@escaping (UIImage?)->()){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:(self.image!))!)
            let image = UIImage(data: data ?? Data())
           completion(image ?? UIImage())
        }
        
    }
}

struct User:Codable {
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

func getParams()->[String : Any]{

    var jobs = [""]
    var MemberLocation = location()
    if let jobsExist = SharedUser.manager.auth.listing?.jobs{
         jobs = Array<String>(jobsExist.keys)
  
    }
    if let locationMember = SharedUser.manager.auth.listing?.location{
        MemberLocation = locationMember
    }
    
let volunteerSaveParams:[String:Any] = ["additionalDesc":SharedUser.manager.auth.listing?.additionalDesc ?? "",
                           "countries":SharedUser.manager.auth.listing?.countries ?? [:],
                           "jobs": jobs,
                           "location": MemberLocation,
                           "skillDescription":SharedUser.manager.auth.listing?.skillDescription ?? "",
                           "slogans":SharedUser.manager.auth.listing?.slogan ?? "",
                           "member": SharedUser.manager.auth.user!,
    "jobs": jobs,
    ] as [String : Any]
        
        return volunteerSaveParams
}
