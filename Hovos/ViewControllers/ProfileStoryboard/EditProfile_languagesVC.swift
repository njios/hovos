//
//  EditProfile_languagesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_languagesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView:UITableView!
     @IBOutlet weak var titleText:UILabel!
    var skills = [Jobs]()
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var packet = NetworkPacket()
        if type == "accommodations"{
            titleText.text = "Accomodation you offer"
             packet.apiPath = ApiEndPoints.accomodation.rawValue
        }else{
        packet.apiPath = ApiEndPoints.languages.rawValue
        }
        ViewHelper.shared().showLoader(self)
        
        
        getApiCall(url: URL(string: packet.url ?? "")!) { (data, status, code) in
            if code == 200{
                DispatchQueue.main.async {
                    ViewHelper.shared().hideLoader()
                    self.skills = try! JSONDecoder().decode([Jobs].self, from: data!)
                    self.tblView.dataSource = self
                    self.tblView.delegate = self
                    self.tblView.reloadData()
                }
                
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileContinentCell") as! EditProfileContinentCell
        cell.continetName.text = (skills[indexPath.row].title ?? "").capitalized
        
        if type == "accommodations"{
            if  SharedUser.manager.auth.listing?.accommodations?.contains(where: {$0.key == (skills[indexPath.row].value ?? "")}) ?? false{
                       cell.selectimage.image = UIImage(named: "selectedTick")
                       cell.continetName.font = UIFont(name: "Lato-Bold", size: 20.0)
                       cell.continetName.textColor = .darkGray
                   }else{
                       cell.selectimage.image = UIImage(named: "greyCheck")
                       cell.continetName.textColor = .lightGray
                   }
        }else{
        if  SharedUser.manager.auth.user?.languages?.contains(where: {$0.key == (skills[indexPath.row].value ?? "")}) ?? false{
            if SharedUser.manager.auth.user?.role?.lowercased() == "v"{
               cell.selectimage.image = UIImage(named: "selectedBlueTick")
            }else{
               cell.selectimage.image = UIImage(named: "selectedTick")
            }
            cell.continetName.font = UIFont(name: "Lato-Bold", size: 20.0)
            cell.continetName.textColor = .darkGray
        }else{
            cell.selectimage.image = UIImage(named: "greyCheck")
            cell.continetName.textColor = .lightGray
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if type == "accommodations"{
            if  SharedUser.manager.auth.listing?.accommodations?.contains(where: {$0.key == (skills[indexPath.row].value ?? "")}) ?? false{
                        SharedUser.manager.auth.listing?.accommodations?.removeValue(forKey: (skills[indexPath.row].value ?? ""))
                   }else{
                       SharedUser.manager.auth.listing?.accommodations?[(skills[indexPath.row].value ?? "")] = (skills[indexPath.row].title ?? "")
                   }
        }else{
        if  SharedUser.manager.auth.user?.languages?.contains(where: {$0.key == (skills[indexPath.row].value ?? "")}) ?? false{
            SharedUser.manager.auth.user?.languages?.removeValue(forKey: (skills[indexPath.row].value ?? ""))
            
        }else{
            SharedUser.manager.auth.user?.languages?[(skills[indexPath.row].value ?? "")] = (skills[indexPath.row].title ?? "")
        }
        }

        
        
        
        tableView.reloadData()
    }
    
    
}

