//
//  SettingsViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsViewController: UIViewController {

    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var profileIMG:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = (SharedUser.manager.auth.user?.firstName ?? "" ) + " " + (SharedUser.manager.auth.user?.lastName ?? "")
       
    }
    

}
