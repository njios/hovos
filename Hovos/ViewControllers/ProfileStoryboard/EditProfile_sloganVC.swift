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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if SharedUser.manager.auth.listing?.slogan == ""{
            sloganTextField.text = "Create your own slogan"
        }else{
             sloganTextField.text = SharedUser.manager.auth.listing?.slogan
        }
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.languages.rawValue
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileContinentCell") as! EditProfileContinentCell
        cell.continetName.text = (slogans[indexPath.row]).capitalized
        if  SharedUser.manager.auth.listing?.slogan == (slogans[indexPath.row]) {
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
        return slogans.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if  SharedUser.manager.auth.listing?.slogan == (slogans[indexPath.row]){
            SharedUser.manager.auth.listing?.slogan = ""
             
             sloganTextField.text = "Create your own slogan"
        }else{
            SharedUser.manager.auth.listing?.slogan = slogans[indexPath.row]
   
            sloganTextField.text = SharedUser.manager.auth.listing?.slogan
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
            SharedUser.manager.auth.listing?.slogan = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  SharedUser.manager.auth.listing?.slogan == ""{
        textView.text = ""
        }
    }
    
}

