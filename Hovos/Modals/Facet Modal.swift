//
//  Facet Modal.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/3/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct facets:Codable{
   var countries:[countries]
   var continents:[continents]
}

struct countries:Codable,Equatable{
    
    
    
    var counts:String?
    var continentId:String?
    var latitude:String?
    var longitude:String?
    var title:String?
    var zoom:String?
    var countryId:String?
}
struct continents:Codable,Hashable{
    
    var counts:String?
    var continentId:String?
    var latitude:String?
    var longitude:String?
    var title:String?
    var zoom:String?
    var countryCode:String?
    var countryId:String?
}
