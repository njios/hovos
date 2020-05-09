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
    

    @IBAction func hostAccomodationClicked(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC") as! EditProfile_languagesVC
            vc.type = "accommodations"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
   
    @IBAction func hostPlaceImagesClicked(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC") as! EditProfile_photoesVC
            vc.type = "place"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func hostAccomodationImagesClicked(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC") as! EditProfile_photoesVC
            vc.type = "accommodations"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }


}
