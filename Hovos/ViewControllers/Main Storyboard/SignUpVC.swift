//
//  SignUpVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class SignUpVc: UIViewController {
    @IBOutlet weak var emailId:UITextField!
    @IBOutlet weak var password:UITextField!
    @IBOutlet weak var firstName:UITextField!
    @IBOutlet weak var lastName:UITextField!
    @IBOutlet weak var titlelabel:UILabel!
    @IBOutlet weak var subtitle:UILabel!
    @IBOutlet weak var titleDetaillabel:UILabel!
    @IBOutlet weak var subtitleDetail:UILabel!
    @IBOutlet weak var titleCheck:UIImageView!
    @IBOutlet weak var subtitleCheck:UIImageView!
    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var signUpButton:UIView!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var firstnameIcon:UIImageView!
    @IBOutlet weak var lastnameIcon:UIImageView!
    @IBOutlet weak var emailIcon:UIImageView!
    @IBOutlet weak var eyeIcon:UIImageView!
     @IBOutlet weak var passwordIcon:UIImageView!
    
    var type:String? = "v" // used to identify Volunteer or host
    var vmObject:SignUPVM?
    override func viewDidLoad() {
        vmObject = SignUPVM()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if type == "v"{
                   titlelabel.text = "I am a volunteer"
                   titleDetaillabel.text = "(I offer my help to hosts)"
                   subtitle.text = "I am a host"
                   subtitleDetail.text = "(I need volunteers to help me)"
                   icon.image = UIImage(named: "volunteer")
                   titleCheck.image = UIImage(named: "selectedBlueTick")
                   titlelabel.textColor = UIColor(named: "greenColor")
                   titleDetaillabel.textColor = UIColor(named: "greenColor")
                   signUpButton.backgroundColor = UIColor(named: "greenColor")
                   headerView.backgroundColor = UIColor(named: "greenColor")
                   firstnameIcon.image = UIImage(named: "VolName")
                   lastnameIcon.image = UIImage(named: "VolName")
                   emailIcon.image = UIImage(named: "VolEmail")
                   passwordIcon.image = UIImage(named: "VolPassword")
                   eyeIcon.image = UIImage(named: "blueEyes")
                   
                   
                   
               }else{
                   titlelabel.text = "I am a host"
                   subtitle.text = "I am a volunteer"
                   titleDetaillabel.text = "(I need volunteers to help me)"
                   subtitleDetail.text = "(I offer my help to hosts)"
                   icon.image = UIImage(named: "host")
                   titleCheck.image = UIImage(named: "selectedTick")
                   titlelabel.textColor = UIColor(named: "orangeColor")
                   titleDetaillabel.textColor = UIColor(named: "orangeColor")
                   signUpButton.backgroundColor = UIColor(named: "orangeColor")
                   headerView.backgroundColor = UIColor(named: "orangeColor")
                   
                   firstnameIcon.image = UIImage(named: "HostName")
                   lastnameIcon.image = UIImage(named: "HostName")
                   emailIcon.image = UIImage(named: "HostEmail")
                   passwordIcon.image = UIImage(named: "HostPassword")
                   eyeIcon.image = UIImage(named: "eyeprotected")
                   
                   
                   
               }
    }
    
    @IBAction func eyeClicked(_ sender:UIButton){
        password.isSecureTextEntry = !password.isSecureTextEntry
    }
    
    @IBAction func signUpClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        vmObject?.signUp(firstname: firstName.text!, lastname: lastName.text!, emailId: emailId.text!, password: password.text!, type: type!, completion:updateUiAfterSignup(status:data:))
    }
    
    @IBAction func switchUser(_ sender:UIButton){
        type = type == "v" ? "h" : "v"
        
        if type == "v"{
            titlelabel.text = "I am a volunteer"
            titleDetaillabel.text = "(I offer my help to hosts)"
            subtitle.text = "I am a host"
            subtitleDetail.text = "(I need volunteers to help me)"
            icon.image = UIImage(named: "volunteer")
            titleCheck.image = UIImage(named: "selectedBlueTick")
            titlelabel.textColor = UIColor(named: "greenColor")
            titleDetaillabel.textColor = UIColor(named: "greenColor")
            signUpButton.backgroundColor = UIColor(named: "greenColor")
            headerView.backgroundColor = UIColor(named: "greenColor")
            firstnameIcon.image = UIImage(named: "VolName")
            lastnameIcon.image = UIImage(named: "VolName")
            emailIcon.image = UIImage(named: "VolEmail")
            passwordIcon.image = UIImage(named: "VolPassword")
            eyeIcon.image = UIImage(named: "blueEyes")
        }else{
            titlelabel.text = "I am a host"
            subtitle.text = "I am a volunteer"
            titleDetaillabel.text = "(I need volunteers to help me)"
            subtitleDetail.text = "(I offer my help to hosts)"
            icon.image = UIImage(named: "host")
            titleCheck.image = UIImage(named: "selectedTick")
            titlelabel.textColor = UIColor(named: "orangeColor")
            titleDetaillabel.textColor = UIColor(named: "orangeColor")
            signUpButton.backgroundColor = UIColor(named: "orangeColor")
            headerView.backgroundColor = UIColor(named: "orangeColor")
            firstnameIcon.image = UIImage(named: "HostName")
            lastnameIcon.image = UIImage(named: "HostName")
            emailIcon.image = UIImage(named: "HostEmail")
            passwordIcon.image = UIImage(named: "HostPassword")
            eyeIcon.image = UIImage(named: "eyeprotected")
        }
    }
    
    func updateUiAfterSignup(status:Bool,data:Data?){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                
                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "dashboradnav") as! UINavigationController
                (vc.viewControllers.first as! TabBarController).registration = true
                
                let appdel = UIApplication.shared.delegate as? AppDelegate
                appdel?.window?.rootViewController = vc
            }else{
                let alert = UIAlertController(title: "Error!", message: data?.html2String, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}
