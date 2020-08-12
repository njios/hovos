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
    var dt:String!{
        didSet{
            if dt != nil {
            let splitedArray =  dt.split(separator: "|")
          
            for i in 0 ... 1 {
                if i == 0{
                    let startDateSplitted = splitedArray[0].split(separator: " ")

                    queryDate = queryDate + startDateSplitted[2] + "-"
                    queryDate = queryDate + CalenderMonth.monthInString(month: String(startDateSplitted[0])).getMonth()  + "-"
                    var copyItem = startDateSplitted[1]
                    if copyItem.last == ","{
                        copyItem.removeLast()
                    }
                    queryDate = queryDate + copyItem + "|"

                }else{
                    let endDateSplitted = splitedArray[1].split(separator: " ")
                    queryDate = queryDate + endDateSplitted[2] + "-"
                    queryDate = queryDate + CalenderMonth.monthInString(month: String(endDateSplitted[0])).getMonth() + "-"
                    var copyItem = endDateSplitted[1]
                    if copyItem.last == ","{
                        copyItem.removeLast()
                    }
                    queryDate = queryDate + copyItem

                }
            }
        }
        }
    }
    var skills = [String]()
    var cntry:String!
    var conti:String!
    var latlng:String!
    var radius:String!
    var age:String! = ""
    var gender:String!
    var isCompanion:String!
    var queryDate:String! = ""
    
    
}
