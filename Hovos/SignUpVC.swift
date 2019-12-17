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
    @IBOutlet weak var icon:UIImageView!
    var type:String? // used to identify Volunteer or host
    var vmObject:SignUPVM?
    override func viewDidLoad() {
        vmObject = SignUPVM()
        if type == "v"{
                  titlelabel.text = "You are a traveler"
                  subtitle.text = "No, I am a Work exchange host"
                  icon.image = UIImage(named: "volunteer")
              }else{
                  titlelabel.text = "You are a work exchange host"
                  subtitle.text = "No, I am traveler"
                  icon.image = UIImage(named: "host")
              }
    }
    @IBAction func signUpClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        vmObject?.signUp(firstname: firstName.text!, lastname: lastName.text!, emailId: emailId.text!, password: password.text!, type: type!, completion: updateUiAfterSignup(status:))
       }
    
    @IBAction func switchUser(_ sender:UIButton){
        type = type == "v" ? "h" : "v"
        
        if type == "v"{
            titlelabel.text = "You are a traveler"
            subtitle.text = "No, I am a Work exchange host"
            icon.image = UIImage(named: "volunteer")
        }else{
            titlelabel.text = "You are a work exchange host"
            subtitle.text = "No, I am traveler"
            icon.image = UIImage(named: "host")
        }
    }
    
     func updateUiAfterSignup(status:Bool){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                       UserDefaults.standard.set(true, forKey: constants.accessToken.rawValue)
                       self.goToRootVC()
                   }
        }
       
    }
    
}
