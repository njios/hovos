//
//  EditProfile_sloganVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_sloganVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var sloganTextField:UITextView!
    @IBOutlet weak var sloganHeight:NSLayoutConstraint!
    var skills = [Jobs]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if EditProfile.sharedManger().profilePassById.selectedSlogan == ""{
            sloganTextField.text = "Create your own slogan"
        }else{
             sloganTextField.text = EditProfile.sharedManger().profilePassById.selectedSlogan
        }
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.languages.rawValue
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
        if  EditProfile.sharedManger().profilePassById.selectedSlogan == (skills[indexPath.row].value ?? "") {
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
     
        if  EditProfile.sharedManger().profilePassById.selectedSlogan == (skills[indexPath.row].value ?? ""){
            EditProfile.sharedManger().profilePassById.selectedSlogan = ""
             EditProfile.sharedManger().profileForDisplay.selectedSlogan = ""
             sloganTextField.text = "Create your own slogan"
        }else{
            EditProfile.sharedManger().profilePassById.selectedSlogan = (skills[indexPath.row].value ?? "")
            EditProfile.sharedManger().profileForDisplay.selectedSlogan = (skills[indexPath.row].title ?? "")
            sloganTextField.text = EditProfile.sharedManger().profileForDisplay.selectedSlogan
        }
        tableView.reloadData()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraints) in
            if constraints.firstAttribute == .height{
                constraints.constant = estimateSize.height + 10
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Create your own slogan"
        }else{
            EditProfile.sharedManger().profilePassById.selectedSlogan = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  EditProfile.sharedManger().profilePassById.selectedSlogan == ""{
        textView.text = ""
        }
    }
    
}

