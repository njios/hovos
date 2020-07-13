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
    
    
    func returnCountries(index:Int)->[countries]{
        var filteredCountries:[countries] = []
        for item in self.countries{
            if item.continentId == continents[index].continentId{
                filteredCountries.append(item)
            }
        }
        return filteredCountries
    }
}

struct countries:Codable,Equatable{
    var counts:String?
    var continentId:String?
    var latitude:String?
    var longitude:String?
    var title:String?
    var zoom:String?
    var countryId:String?
    var countryCode:String?
    
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
