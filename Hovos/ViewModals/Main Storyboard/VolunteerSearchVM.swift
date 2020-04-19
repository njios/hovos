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
            if modal.skills.count > 0 || modal.conti != nil || modal.dt != nil || modal.qs != nil || modal.languagesArray.count > 0 {
              
                volunteerSearchVC.clearButton.isHidden = false
            }
            if modal.skills.count == 0 && modal.conti == nil  && modal.dt == nil && modal.qs == nil && modal.languagesArray.count == 0 {
                volunteerSearchVC.clearButton.isHidden = true
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
    
    func getDataWithModal(modalObject:@escaping (_ modalObject:[VolunteerItem]?)->()){
        
        var str = "https://www.hovos.com\(ApiEndPoints.volunteersAll.rawValue)?"
              var qs = ""
              qs = qs + "cntry=\(modal.cntry ?? "")"
              qs = qs + "&conti=\(modal.conti ?? "")"
              qs = qs + "&dt=\(modal.dt ?? "")"
              qs = qs + "&skills=\(modal.skills.joined(separator: "|"))"
              qs = qs + "&latlng=\(modal.latlng ?? "")"
              qs = qs + "&qs=\(modal.qs ?? "")"
              qs = qs + "&age=\(modal.age ?? "")"
              str = str + qs.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
              let url =  URL(string: str)
              getApiCall(url: url! ) { (data, status, code) in
                  if code == 200{
                      let decoder =  JSONDecoder()
                      if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                         
                        modalObject(Volunteer.travellers!)
                      }else{
                        modalObject(nil)
                    }
                  }else{
                    self.getDataWithModal(modalObject: modalObject)
                  }
              }
        }
    
    
}
