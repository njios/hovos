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
    
    var type:String? // used to identify Volunteer or host
    var vmObject:SignUPVM?
    override func viewDidLoad() {
        vmObject = SignUPVM()
    }
    @IBAction func signUpClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        vmObject?.signUp(firstname: firstName.text!, lastname: lastName.text!, emailId: emailId.text!, password: password.text!, type: type!, completion: updateUiAfterSignup(status:))
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
