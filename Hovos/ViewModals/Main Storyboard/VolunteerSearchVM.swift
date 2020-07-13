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
            var ages = temp.map({String($0)})
            if  ages.contains((volunteerSearchVC.age1.titleLabel?.text!)!){
                volunteerSearchVC.age1.backgroundColor = UIColor(named: "greenColor")
                volunteerSearchVC.age1.setTitleColor(.white, for: .normal)
            }else{
                volunteerSearchVC.age1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                volunteerSearchVC.age1.setTitleColor(.darkGray, for: .normal)
            }
            if  ages.contains((volunteerSearchVC.age2.titleLabel?.text!)!){
                volunteerSearchVC.age2.backgroundColor = UIColor(named: "greenColor")
                volunteerSearchVC.age2.setTitleColor(.white, for: .normal)
            }else{
                volunteerSearchVC.age2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                volunteerSearchVC.age2.setTitleColor(.darkGray, for: .normal)
            }
            if  ages.contains((volunteerSearchVC.age3.titleLabel?.text!)!){
                volunteerSearchVC.age3.backgroundColor = UIColor(named: "greenColor")
                volunteerSearchVC.age3.setTitleColor(.white, for: .normal)
            }else{
                volunteerSearchVC.age3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                volunteerSearchVC.age3.setTitleColor(.darkGray, for: .normal)
            }
            if  ages.contains((volunteerSearchVC.age4.titleLabel?.text!)!){
                volunteerSearchVC.age4.backgroundColor = UIColor(named: "greenColor")
                volunteerSearchVC.age4.setTitleColor(.white, for: .normal)
            }else{
                volunteerSearchVC.age4.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                volunteerSearchVC.age4.setTitleColor(.darkGray, for: .normal)
            }
            
            
            
            if  modal.qs == nil{
                volunteerSearchVC.searchTextView.serachText.text = ""
            }else{
                volunteerSearchVC.searchTextView.serachText.text = modal.qs
            }
            
            if modal.dt == nil{
                volunteerSearchVC.anytime.isSelected = true
                volunteerSearchVC.dateRange.isSelected = false
                volunteerSearchVC.fromLabel.text = "Start Date"
                volunteerSearchVC.toLabel.text = "End Date"
            }else{
                volunteerSearchVC.anytime.isSelected = false
                volunteerSearchVC.dateRange.isSelected = true
                volunteerSearchVC.fromLabel.text = String(modal.dt.split(separator: "|").first ?? "Start Date")
                volunteerSearchVC.toLabel.text = String(modal.dt.split(separator: "|").last ?? "End Date")
            }
            
            if modal.conti != nil {
                volunteerSearchVC.changeApperance(button: volunteerSearchVC.countriesButton, text: modal.countries.joined(separator: ", "), textLabel: volunteerSearchVC.countrieslabel)
            }else{
                volunteerSearchVC.resetApperance(button: volunteerSearchVC.countriesButton, textLabel: volunteerSearchVC.countrieslabel)
            }
            
            if  modal.skillsArray.count > 0{
                volunteerSearchVC.changeApperance(button: volunteerSearchVC.skillsButton, text: modal.skillsArray.joined(separator: ", "), textLabel: volunteerSearchVC.skillsLabel)
            }else{
                volunteerSearchVC.resetApperance(button: volunteerSearchVC.skillsButton, textLabel: volunteerSearchVC.skillsLabel)
            }
            
            if  modal.languagesArray.count > 0{
                volunteerSearchVC.changeApperance(button: volunteerSearchVC.languageButton, text: modal.languagesArray.joined(separator: ", "), textLabel: volunteerSearchVC.languageLabel)
            }else{
                volunteerSearchVC.resetApperance(button: volunteerSearchVC.languageButton, textLabel: volunteerSearchVC.languageLabel)
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
        qs = qs + "&dt=\(modal.dt ?? "")"
        qs = qs + "&skills=\(modal.skills.joined(separator: "|"))"
        qs = qs + "&latlng=\(modal.latlng ?? "")"
        qs = qs + "&qs=\(modal.qs ?? "")"
        qs = qs + "&age=\(modal.age ?? "")"
        qs = qs + "&gender=\(modal.gender ?? "")"
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
        qs = qs + "&dt=\(object.dt ?? "")"
        qs = qs + "&skills=\(object.skills.joined(separator: "|"))"
        qs = qs + "&latlng=\(object.latlng ?? "")"
        qs = qs + "&qs=\(object.qs ?? "")"
        qs = qs + "&age=\(object.age ?? "")"
        qs = qs + "&gender=\(object.gender ?? "")"
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
