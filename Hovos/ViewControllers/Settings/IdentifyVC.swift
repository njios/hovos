//
//  IdentifyVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class IdentifyVC: UIViewController {

    @IBOutlet weak var phoneno:UITextField!
    @IBOutlet weak var countryCode:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (SharedUser.manager.auth.user?.phoneNumber ?? "") != ""{
        phoneno.text = (SharedUser.manager.auth.user?.phoneNumber ?? "").components(separatedBy: "-")[1]
        
        }// Do any additional setup after loading the view.
    }
    

    @IBAction func identifyClicked(_ sender:UIButton){
        if  phoneno.text != "" {
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                             "API_KEY":constants.Api_key.rawValue]
        var identifyYourself = NetworkPacket()
              identifyYourself.apiPath = ApiEndPoints.smsOtp.rawValue
              identifyYourself.header = header
            identifyYourself.data = ["countrycode":countryCode.titleLabel?.text ?? "",
                                     "phone":phoneno.text ?? ""]
              identifyYourself.method = "POST"
        ViewHelper.shared().showLoader(self)
        ApiCall(packet: identifyYourself) { (data, status, code) in
             ViewHelper.shared().hideLoader()
            if code == 200{
                Hovos.showAlert(vc: self, mssg: "Verification code sent to phone number")
            }else{
                Hovos.showAlert(vc: self, mssg: "Phone number not valid.")
            }
        }
        }
    }
    
}

func showAlert(vc:UIViewController,mssg:String){
    let alert = UIAlertController(title: "", message: mssg, preferredStyle: .alert)
                             let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
                             alert.addAction(okButton)
              vc.present(alert, animated: true) {
                 
    }
}
