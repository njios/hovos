//
//  VolunteerSearchVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/2/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
class VolunteerSearchVM{
    
    weak var volunteerSearchVC:VolunteerSearchVC!
    var jobs:[Jobs]!
    var languages:[Jobs]!
    // var searchParam = HostSearch()
    
    var modal = VolunteerSearchModel(){
        didSet{
            if modal.skills.count > 0 || modal.conti != nil || modal.dt != nil || modal.qs != nil || modal.languagesArray.count > 0  || modal.age != "" || modal.gender != nil{
                volunteerSearchVC.clearButton.isHidden = false
            }
            if modal.skills.count == 0 && modal.conti == nil  && modal.dt == nil && modal.qs == nil && modal.languagesArray.count == 0 && modal.age == "" && modal.gender == nil{
                volunteerSearchVC.clearButton.isHidden = true
            }
            
            if modal.gender != nil{
                if modal.gender == "M"{
                    volunteerSearchVC.gender1.isSelected = true
                }
                if modal.gender == "F"{
                    volunteerSearchVC.gender2.isSelected = true
                }
                if modal.gender == ""{
                    volunteerSearchVC.gender3.isSelected = true
                }
            }
            
            
            let temp = Array(modal.age.split(separator: "|"))
            let ages = temp.map({String($0)})
            
            DispatchQueue.main.async {
                
                if let companion = self.modal.isCompanion, companion == "Y"{
                    self.volunteerSearchVC.gender3.isSelected = true
                }else{
                    self.volunteerSearchVC.gender3.isSelected = false
                }
                
                if  ages.contains((self.volunteerSearchVC.age1.titleLabel?.text!)!){
                    self.volunteerSearchVC.age1.backgroundColor = UIColor(named: "greenColor")
                    self.volunteerSearchVC.age1.setTitleColor(.white, for: .normal)
                }else{
                    self.volunteerSearchVC.age1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    self.volunteerSearchVC.age1.setTitleColor(.darkGray, for: .normal)
                }
                if  ages.contains((self.volunteerSearchVC.age2.titleLabel?.text!)!){
                    self.volunteerSearchVC.age2.backgroundColor = UIColor(named: "greenColor")
                    self.volunteerSearchVC.age2.setTitleColor(.white, for: .normal)
                }else{
                    self.volunteerSearchVC.age2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    self.volunteerSearchVC.age2.setTitleColor(.darkGray, for: .normal)
                }
                if  ages.contains((self.volunteerSearchVC.age3.titleLabel?.text!)!){
                    self.volunteerSearchVC.age3.backgroundColor = UIColor(named: "greenColor")
                    self.volunteerSearchVC.age3.setTitleColor(.white, for: .normal)
                }else{
                    self.volunteerSearchVC.age3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    self.volunteerSearchVC.age3.setTitleColor(.darkGray, for: .normal)
                }
                if  ages.contains((self.volunteerSearchVC.age4.titleLabel?.text!)!){
                    self.volunteerSearchVC.age4.backgroundColor = UIColor(named: "greenColor")
                    self.volunteerSearchVC.age4.setTitleColor(.white, for: .normal)
                }else{
                    self.volunteerSearchVC.age4.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    self.volunteerSearchVC.age4.setTitleColor(.darkGray, for: .normal)
                }
                if  self.modal.qs == nil{
                    self.volunteerSearchVC.searchTextView.serachText.text = ""
                }else{
                    self.volunteerSearchVC.searchTextView.serachText.text = self.modal.qs
                }
                
                if self.modal.dt == nil{
                    self.volunteerSearchVC.anytime.isSelected = true
                    self.volunteerSearchVC.dateRange.isSelected = false
                    self.volunteerSearchVC.fromLabel.text = "Start Date"
                    self.volunteerSearchVC.toLabel.text = "End Date"
                }else{
                    self.volunteerSearchVC.anytime.isSelected = false
                    self.volunteerSearchVC.dateRange.isSelected = true
                    self.volunteerSearchVC.fromLabel.text = String(self.modal.dt.split(separator: "|").first ?? "Start Date")
                    self.volunteerSearchVC.toLabel.text = String(self.modal.dt.split(separator: "|").last ?? "End Date")
                }
                
                if self.modal.conti != nil {
                    self.volunteerSearchVC.changeApperance(button: self.volunteerSearchVC.countriesButton, text: self.modal.countries.joined(separator: ", "), textLabel: self.volunteerSearchVC.countrieslabel)
                }else{
                    self.volunteerSearchVC.resetApperance(button: self.volunteerSearchVC.countriesButton, textLabel: self.volunteerSearchVC.countrieslabel)
                }
                
                if  self.modal.skillsArray.count > 0{
                    self.volunteerSearchVC.changeApperance(button: self.volunteerSearchVC.skillsButton, text: self.modal.skillsArray.joined(separator: ", "), textLabel: self.volunteerSearchVC.skillsLabel)
                }else{
                    self.volunteerSearchVC.resetApperance(button: self.volunteerSearchVC.skillsButton, textLabel: self.volunteerSearchVC.skillsLabel)
                }
                
                if  self.modal.languagesArray.count > 0{
                    self.volunteerSearchVC.changeApperance(button: self.volunteerSearchVC.languageButton, text: self.modal.languagesArray.joined(separator: ", "), textLabel: self.volunteerSearchVC.languageLabel)
                }else{
                    self.volunteerSearchVC.resetApperance(button: self.volunteerSearchVC.languageButton, textLabel: self.volunteerSearchVC.languageLabel)
                }
                
            }
        }
    }
    init(dependency:VolunteerSearchVC) {
        volunteerSearchVC = dependency
        
    }
    
    
    
    func getJobs(completion:@escaping(()->())){
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.jobs.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder = JSONDecoder()
                self.jobs = try? decoder.decode([Jobs].self, from: data!)
                completion()
            }else{
                completion()
            }
        }
    }
    func getLanguages(completion:@escaping(()->())){
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.languages.rawValue
        packet.method = HTTPMethod.get.rawValue
        packet.encoding = Alamofire.URLEncoding.httpBody
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder = JSONDecoder()
                self.languages = try? decoder.decode([Jobs].self, from: data!)
                completion()
            }else{
                completion()
            }
        }
    }
    
    func getDataWithModal(modalObject:@escaping (_ modalObject:Volunteer?)->()){
        
        
        var str = "https://www.hovos.com\(ApiEndPoints.volunteersAll.rawValue)?"
        var qs = ""
        qs = qs + "cntry=\(modal.cntry ?? "")"
        qs = qs + "&conti=\(modal.conti ?? "")"
        qs = qs + "&dt=\(modal.queryDate!)"
        qs = qs + "&skills=\(modal.skills.joined(separator: "|"))"
        qs = qs + "&latlng=\(modal.latlng ?? "")"
        qs = qs + "&qs=\(modal.qs ?? "")"
        qs = qs + "&age=\(modal.age ?? "")"
        qs = qs + "&gender=\(modal.gender ?? "")"
        qs = qs + "&languages=\(modal.languagesArray.joined(separator: "|"))"
        if let companion = modal.isCompanion, companion == "Y"{
               qs = qs + "&isCompanion=\(companion)"
               }
        str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url =  URL(string: str)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    modalObject(Volunteer)
                }else{
                    modalObject(nil)
                }
            }else{
                self.getDataWithModal(modalObject: modalObject)
            }
        }
    }
    
    func searchVolunteer(object:VolunteerSearchModel, modalObject:@escaping (_ modalObject:Volunteer?)->()){
        
        var str = "https://www.hovos.com\(ApiEndPoints.volunteersAll.rawValue)?"
        var qs = ""
        qs = qs + "cntry=\(object.cntry ?? "")"
        qs = qs + "&conti=\(object.conti ?? "")"
        qs = qs + "&dt=\(modal.queryDate!)"
        qs = qs + "&skills=\(object.skills.joined(separator: "|"))"
        qs = qs + "&latlng=\(object.latlng ?? "")"
        qs = qs + "&qs=\(object.qs ?? "")"
        qs = qs + "&age=\(object.age ?? "")"
        qs = qs + "&gender=\(object.gender ?? "")"
        qs = qs + "&languages=\(modal.languagesArray.joined(separator: "|"))"
        if let companion = object.isCompanion, companion == "Y"{
        qs = qs + "&isCompanion=\(companion)"
        }
        str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url =  URL(string: str)
        getApiCall(url: url! ) { (data, status, code) in
            if code == 200{
                let decoder =  JSONDecoder()
                if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                    modalObject(Volunteer)
                }else{
                    modalObject(nil)
                }
            }
        }
    }
    
    
    
}
