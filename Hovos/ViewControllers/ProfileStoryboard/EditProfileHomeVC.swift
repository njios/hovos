//
//  EditProfileHomeVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/4/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfileHomeVC: UIViewController {

    @IBOutlet weak var hostView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if SharedUser.manager.auth.user?.role?.lowercased() == "h"{
            hostView.isHidden = false
        }else{
             hostView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
