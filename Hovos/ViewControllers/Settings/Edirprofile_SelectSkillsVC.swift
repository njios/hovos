//
//  Edirprofile_SelectSkillsVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class Edirprofile_SelectSkillsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView:UITableView!
    var skills = [Jobs]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.jobs.rawValue
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
        if  EditProfile.sharedManger().profilePassById.selectedSkills.contains(skills[indexPath.row].value ?? "") {
            cell.selectimage.image = UIImage(named: "selectedBlueTick")
            cell.continetName.font = UIFont(name: "Lato-Bold", size: 20.0)
            cell.continetName.textColor = .darkGray
           
        }else{
            cell.selectimage.image = UIImage(named: "greyCheck")
            cell.continetName.textColor = .lightGray
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if  EditProfile.sharedManger().profilePassById.selectedSkills.contains(skills[indexPath.row].value ?? ""){
            EditProfile.sharedManger().profilePassById.selectedSkills.removeAll { (value) -> Bool in
                if value == (skills[indexPath.row].value ?? ""){
                    return true
                }else{
                    return false
                }
            }
        }else{
            EditProfile.sharedManger().profilePassById.selectedSkills.append((skills[indexPath.row].value ?? ""))
            EditProfile.sharedManger().profileForDisplay.selectedSkills.append((skills[indexPath.row].title ?? ""))
        }
        tableView.reloadData()
    }
    
    
}
