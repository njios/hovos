//
//  ChangePasswordVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/22/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Foundation
class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var newPassword:UITextField!
    @IBOutlet weak var confirmPassword:UITextField!
    var vmObject:ChangePasswordVM!
    var code = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vmObject = ChangePasswordVM()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changePassword(_ sender:UIButton){
        if newPassword.text == confirmPassword.text{
        ViewHelper.shared().showLoader(self)
        vmObject.changePasswordService(emailId: email, password: confirmPassword.text!, code: code, completion: changePasswordResponseRecieved)
        }else{
            let alert = UIAlertController(title: "Error!", message: "New password and confirm password is not same, please try again", preferredStyle: .alert)
                           let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
                           alert.addAction(okButton)
            self.present(alert, animated: true) {
                DispatchQueue.main.async {
                    self.newPassword.text = ""
                    self.confirmPassword.text = ""
                }
            }
        }
    }
    
    private func changePasswordResponseRecieved(status:Bool){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                for item in self.navigationController!.viewControllers {
                    if let vc = item as? LoginVC{
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }else{
                let alert = UIAlertController(title: "Error!", message: "Something wrong, please try", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}
