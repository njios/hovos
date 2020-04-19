//
//  ContactVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

     @IBOutlet weak var name:UILabel!
     @IBOutlet weak var email:UILabel!
     @IBOutlet weak var query:UITextView!
     override func viewDidLoad() {
        super.viewDidLoad()

        name.text = "  " + (SharedUser.manager.auth.user?.firstName!)! + " " + (SharedUser.manager.auth.user?.lastName!)!
        email.text = "  " + (SharedUser.manager.auth.user?.email! ?? "")
        
    
    }
    
    @IBAction  func contactUpClicked(_ sender:UIButton){
        if query.text != ""{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                                 "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
                  identifyYourself.apiPath = ApiEndPoints.contactUs.rawValue
                  identifyYourself.header = header
            identifyYourself.data = ["message":query.text!,
                                     "email":(SharedUser.manager.auth.user?.email! ?? ""),
                                     "name":(SharedUser.manager.auth.user?.firstName!)! + " " + (SharedUser.manager.auth.user?.lastName!)!,
            "hdnSubmit":"1"]
            
                  identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                 ViewHelper.shared().hideLoader()
                if code == 200{
                    Hovos.showAlert(vc: self, mssg: "Query submitted successfully")
                    self.query.text = ""
                }else{
                    Hovos.showAlert(vc: self, mssg: "Error in submission, Try again ")
                }
            }
        }
    }

}
