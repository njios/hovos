//
//  HostSearchModel.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/15/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct HostSearchModel:Codable{
    
//    var searchKeyword:String = ""
    var continent:String = ""
    var countries = [String]()
//    var exchangeDate:String = ""
//    var jobs = [String]()
//
    
    var qs:String!
    var dt:String!
    var jobs = String()
    var cntry:String!
    var conti:String!
    var latlng:String!
    var radius:String!
}
