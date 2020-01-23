//
//  OTPVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/22/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {

    @IBOutlet weak var text:UILabel!
    @IBOutlet var otp: [UITextField]!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.text = "A reset code has been sent to your email id : \(email). Please enter the code below. "
    }
    
    override func viewDidAppear(_ animated: Bool) {
        otp[0].becomeFirstResponder()
    }
    
    private func goTochangePassword(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        var code = ""
        for item in otp{
            code = code + item.text!
        }
       
        vc.code = code
        vc.email = email
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension OTPVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       var blank = false
        for item in otp{
            if item.text?.count == 0{
                item.becomeFirstResponder()
                blank = true
                break
            }
        }
        if blank == false{
            textField.resignFirstResponder()
           goTochangePassword()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        if textField.text?.count == 0{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
               self.textFieldDidBeginEditing(textField)
            })
             
            return true
        }else{
            self.textFieldDidBeginEditing(textField)
            return true
        }
    }
    
    
}
