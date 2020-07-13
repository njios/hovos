//
//  CalenderHelper.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/17/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct CalenderHelper{
    var dateFormatter = DateFormatter()
    var mmmddyyy = DateFormatter()
    var dateComponents: DateComponents!
    var months = [String]()
    let calendar = Calendar.current
    var calenderDatesForYear = [Int]()
    var currentDate:Date
    static var shared = CalenderHelper()
    private init(){
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        mmmddyyy.timeZone = calendar.timeZone
        mmmddyyy.dateFormat = "MMM dd, yyyy"
        currentDate = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        dateComponents = calendar.dateComponents([.month,.day,.year,.minute,.hour,.second], from: dateFormatter.date(from: dateFormatter.string(from: Date()))!)
        for i in dateComponents.month! ..< dateComponents.month!+12{
            months.append(getMonth(i%12))
        }
    }
    
    func firstDayOfcurrentMonth(month:String)->Int{
     
        let firstDate = dateFormatter.date(from: "\(String(dateComponents.year!))-\(month)-01T00:00:00+0000")
        let firstDateComponent = calendar.dateComponents([.day,.weekday], from: firstDate!)
        return firstDateComponent.weekday!
        
    }
    
    func lastDayOfcurrentMonth(month:String)->Int{
     
        let firstDate = dateFormatter.date(from: "\(String(dateComponents.year!))-\(month)-01T00:00:00+0000")
        let components = DateComponents(day:1)
        let startOfNextMonth = calendar.nextDate(after:firstDate!, matching: components, matchingPolicy: .nextTime)!
        let lastDateComponent = calendar.dateComponents([.day,.weekday], from: calendar.date(byAdding:.day, value: -1, to: startOfNextMonth)!)
        return lastDateComponent.day!
        
        
    }
    
    func getMonth(_ monthinInt:Int)->String{
    switch monthinInt {
    case 0:
        return "December"
        case 1:
               return "January"
        case 2:
               return "February"
        case 3:
               return "March"
        case 4:
               return "April"
        case 5:
               return "May"
        case 6:
               return "June"
        case 7:
               return "July"
        case 8:
               return "August"
        case 9:
               return "September"
        case 10:
               return "October"
        case 11:
        return "November"
     
        
    default:
        return ""
    }
    }
        func getMonth(_ monthinString:String)->Int{
           switch monthinString {
           case "December":
               return 0
               case "January":
                      return 1
               case "February":
                      return 2
               case "March":
                      return 3
               case "April":
                      return 4
               case "May":
                      return 5
               case "June":
                      return 6
               case "July":
                      return 7
               case "August":
                      return 8
               case "September":
                      return 9
               case "October":
                      return 10
               case "November":
               return 11
            
               
           default:
               return 12
           }
}
    
    
}
