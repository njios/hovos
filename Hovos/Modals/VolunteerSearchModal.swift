//
//  VolunteerSearchModal.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/2/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct VolunteerSearchModel:Codable{
    
//    var searchKeyword:String = ""
    var continent:String = ""
    var countries = [String]()
//    var exchangeDate:String = ""
    var skillsArray = [String]()
    var languagesArray = [String]()
//
    
    var qs:String!
    var dt:String!
    var skills = [String]()
    var cntry:String!
    var conti:String!
    var latlng:String!
    var radius:String!
    var age:String!
    
}
