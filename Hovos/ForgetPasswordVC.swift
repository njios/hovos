//
//  ForgetPasswordVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/22/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailField:UITextField!
    var vmObject:ForgetPasswordVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        vmObject = ForgetPasswordVM()
    }
    
    @IBAction func forgetPasswordClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        vmObject?.ForgetPasswordService(emailId: emailField.text!, completion: forgetPasswordResponseRecieved(status:))
    }
    
    func forgetPasswordResponseRecieved(status:Bool){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                
            }
        }
        
    }
}
