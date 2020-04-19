//
//  AccountInformationVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class AccountInformationVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var firstName:UITextField!
    @IBOutlet weak var lastName:UITextField!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstName.text = SharedUser.manager.auth.user?.firstName!
        lastName.text = SharedUser.manager.auth.user?.lastName!
        email.text = SharedUser.manager.auth.user?.email!
        // Do any additional setup after loading the view.
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        SharedUser.manager.auth.user?.firstName = firstName.text!
        SharedUser.manager.auth.user?.lastName = lastName.text!
        SharedUser.manager.auth.user?.email = email.text!
        if textField.tag == 4{
            
        }else{
            SharedUser.manager.updateUser()
        }
    }
    

}
