//
//  MessageModal.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/19/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct MessageModal:Codable{
    
    var id:String?
    var groupId:String?
    var memberId:String?
    var listingId:String?
    var from: String?
    var image:String?
    var text: String?
    var city: String?
    var country: String?
    var isRead: Bool?
    var isMine: Bool?
    var type: String?
    var time: String?
    var date: String?
   
    var chat: [MessageModal]?
}
