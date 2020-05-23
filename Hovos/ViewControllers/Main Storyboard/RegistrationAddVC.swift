//
//  RegistrationAddVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/13/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class RegistrationAddVC: UIViewController {
    
    @IBOutlet weak var titleView:UIView!
    var isHost = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHost == true{
            titleView.backgroundColor = UIColor(named: "orangeColor")
        }else{
            titleView.backgroundColor = UIColor(named: "greenColor")
        }
    }
    
    @IBAction func registrationClicked(){
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
        if isHost == true{
            registerVC?.type = "h"
        }else{
            registerVC?.type = "v"
        }
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                topViewController()?.present(registerVC!, animated: false, completion: nil)
            }
        }
    }
    
}
