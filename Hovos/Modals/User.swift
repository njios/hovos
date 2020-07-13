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
    
    private enum CoadingKeys:String,CodingKey{
        case auth = "auth"
        case id = "id"
        case role = "role"
        case user = "user"
        case listing = "listing"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let stringage =  try? values.decode(String.self, forKey: .id){
            id = stringage
        }
        if let intAge = try?  values.decode(Int.self, forKey: .id){
            id = String(intAge)
        }
        auth = try? values.decode(String.self, forKey: .auth)
        role = try? values.decode(String.self, forKey: .role)
        user = try? values.decode(User.self, forKey: .user)
        listing = try? values.decode(Listing.self, forKey: .listing)
    }
    init() {
        
    }
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
    var delegate:UpdateProfile!
    func updateUser(){
        var packet = NetworkPacket()
        // recommended volunteer
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        let ob = try! JSONEncoder().encode(SharedUser.manager.auth.listing?.member!)
        packet.data = try! JSONSerialization.jsonObject(with: ob, options: []) as! [String : Any]
        
        
        packet.apiPath = ApiEndPoints.userSave.rawValue
        
        packet.header =  header
        packet.method = "POST"
        
        ApiCallWithJsonEncoding(packet: packet) { (data, status, code) in
            print(status,code)
            self.delegate?.reloadData()
            let updatedObject = try! JSONEncoder().encode(SharedUser.manager.auth)
            UserDefaults.standard.set(updatedObject, forKey: constants.accessToken.rawValue)
            
        }
    }
    
    
    
    func saveVolunteer(completion:@escaping((_ status:Bool,_  mssg:String )->())){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var identifyYourself = NetworkPacket()
        identifyYourself.apiPath = ApiEndPoints.vol_Registration(id: SharedUser.manager.auth.id ?? "").rawValue
        identifyYourself.header = header
        updateVolParams()
        identifyYourself.data = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing), options: []) as! [String : Any]
        
        identifyYourself.method = "POST"
        ApiCallWithJsonEncoding(packet: identifyYourself) { (data, status, code) in
            if code == 200{
                SharedUser.manager.updateUser()
                let header = ["auth":SharedUser.manager.auth.auth ?? "",
                              "API_KEY":constants.Api_key.rawValue]
                var publishPacket = NetworkPacket()
                publishPacket.apiPath = ApiEndPoints.travellerPublish(id: SharedUser.manager.auth.id ?? "").rawValue
                publishPacket.header = header
                publishPacket.method = "POST"
                ApiCallWithJsonEncoding(packet: publishPacket) { (data, status, code) in
                    ViewHelper.shared().hideLoader()
                    if let response = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        if code == 200 && (response["success"] as! Bool) == true{
                            completion(true, response["msg"] as! String)
                            SharedUser.manager.auth.listing?.isPublished = "Y"
                        }else{
                            completion(false, response["msg"] as! String)
                        }
                    }else{
                        if code == 200 {
                            SharedUser.manager.auth.listing?.isPublished = "Y"
                            completion(true, "Profile published")
                        }else{
                            completion(false, "Profile Not published")
                        }
                    }
                }
            }else{
                completion(false,"Profile Not published")
            }
        }
    }
    
    func saveHost(completion:@escaping((_ status:Bool, _  mssg:String)->())){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.id ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var identifyYourself = NetworkPacket()
        identifyYourself.apiPath = ApiEndPoints.host_Registration(id: SharedUser.manager.auth.id ?? "").rawValue
        identifyYourself.header = header
        identifyYourself.data = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing), options: []) as! [String : Any]
        
        
        identifyYourself.method = "POST"
        
        ApiCallWithJsonEncoding(packet: identifyYourself) { (data, status, code) in
            ViewHelper.shared().hideLoader()
            if code == 200{
                SharedUser.manager.updateUser()
                let header = ["auth":SharedUser.manager.auth.auth ?? "",
                              "API_KEY":constants.Api_key.rawValue]
                var publishPacket = NetworkPacket()
                publishPacket.apiPath = ApiEndPoints.hostPublished(id: SharedUser.manager.auth.id ?? "").rawValue
                publishPacket.header = header
                publishPacket.method = "POST"
                ApiCallWithJsonEncoding(packet: publishPacket) { (data, status, code) in
                    ViewHelper.shared().hideLoader()
                    if let response = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        if code == 200 && (response["success"] as! Bool) == true{
                            completion(true, response["msg"] as! String)
                            SharedUser.manager.auth.listing?.isPublished = "Y"
                        }else{
                            completion(false, response["msg"] as! String)
                        }
                    }else{
                        if code == 200 {
                            SharedUser.manager.auth.listing?.isPublished = "Y"
                            completion(true, "Profile published")
                        }else{
                            completion(false, "Profile Not published")
                        }
                    }
                }
            }else{
                completion(false, "Not published")
            }
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
    var volunteers:String?
    var workingHours:String?
    var workingDays:String?
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
    var accommodations:[String:String]? = [String:String]()
    var accommodationImages:[images]?
    var jobs:[String:String]?
    var countries:[String:String]?
    var schedules:[Schedules]? = [Schedules]()
    var friends:[friends]?
    var member:User1?
    var reviews:[review]?
    var mealDescription:String?
    var paymentDescription:String?
    var accDescription:String?
    var paymentOption:String?
    var mealsOption:String?
    var languages:[String:String]? = [String:String]()
    func getFullimage(completion:@escaping (UIImage?)->()){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:(self.image?.medium ?? ""))!)
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
    var languages:[String:String]? = [String:String]()
    var ratings:ratings?
    var memberId:String?
    
    
}


struct User1:Codable {
    var additionalDesc:String?
    var age:String? = ""
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
    var gender:String? = ""
    var id:String?
    var image:images?
    var isDocumentVerified:String?
    var isEmailverified:String?
    var isPaid:String?
    var isPhoneVerified:String?
    var language:String?
    var languageDescription:String? = ""
    var lastName:String?
    var listingId:String?
    var password:String?
    var personalDescription:String? = ""
    var phoneNumber:String?
    var renewalAmount:String?
    var type:String?
    var role:String?
    var languages:[String:String]? = [String:String]()
    var ratings:ratings?
    
    
}

struct ratings:Codable {
    
    var email: String?
    var passport: String?
    var phone: String?
    var experienced: String?
    var payment: String?
    var reviews: String?
    var response: String?
    
}

func updateVolParams(){
    let personalDesc = SharedUser.manager.auth.listing?.member?.personalDescription ?? ""
    
    SharedUser.manager.auth.listing?.status = "active"
    SharedUser.manager.auth.listing?.isCompanion = "Y"
    SharedUser.manager.auth.listing?.additionalDesc = personalDesc
    
    
}
