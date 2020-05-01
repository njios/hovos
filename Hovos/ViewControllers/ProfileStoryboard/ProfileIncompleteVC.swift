//
//  ProfileIncompleteVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/30/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ProfileIncompleteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func startEditProfile(_ sender:UIButton){
        
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                let stb = UIStoryboard(name: "Profile", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "CompleteProfileVC")
                vc.modalPresentationStyle = .overCurrentContext
                topViewController()?.present(vc, animated: false, completion: nil)
            }
        }
        
       
    }

}
