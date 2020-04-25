//
//  EditProfileModal.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/25/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation

struct EditProfile{
    
    static var object:EditProfile!
    static func sharedManger()->EditProfile{
        if object == nil{
            object = EditProfile()
        }
        return object
    }
    
    private init(){
        
    }
    var profilePassById = ProfilePassByID()
    var profileForDisplay = ProfileForDisplay()
}
class ProfilePassByID {
    var selectedContinets = [String:[String]]()
    var selectedSkills = [String]()
    var aboutSkills = ""
    var selectedLanguages = [String]()
}

class ProfileForDisplay {
    var selectedContinents = [String:[String]]()
    var selectedSkills = [String]()
    var selectedLanguages = [String]()
}
