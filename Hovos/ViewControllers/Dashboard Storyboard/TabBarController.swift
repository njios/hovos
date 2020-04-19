//
//  TabBarController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/7/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {
    
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var home:UIView!
    @IBOutlet weak var message:UIView!
    @IBOutlet weak var profile:UIView!
    @IBOutlet weak var fav:UIView!
    @IBOutlet weak var setting:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home.alpha = 1.0
        message.alpha = 0.5
        profile.alpha = 0.5
        fav.alpha = 0.5
        setting.alpha = 0.5
        if let data = UserDefaults.standard.data(forKey: constants.accessToken.rawValue){
            let decoder = JSONDecoder()
            SharedUser.manager.auth = try! decoder.decode(Auth.self, from: data)
        }
        if SharedUser.manager.auth.role!.lowercased() == "v"{
        
            self.view.backgroundColor = UIColor(named: "greenColor")
            backView.backgroundColor = UIColor(named: "greenColor")
        }else{
            
            backView.backgroundColor = UIColor(named: "orangeColor")
            self.view.backgroundColor = UIColor(named: "orangeColor")
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.addChild(vc!)
        self.containerView.addSubview(vc!.view)
    }
    
    @IBAction func addChild(_ sender:UIButton){
        var vc :UIViewController!
        if sender.tag == 0{
            home.alpha = 1.0
            message.alpha = 0.5
            profile.alpha = 0.5
            fav.alpha = 0.5
            setting.alpha = 0.5
             vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        }
        if sender.tag == 1{
            home.alpha = 0.5
            message.alpha = 1.0
            profile.alpha = 0.5
            fav.alpha = 0.5
            setting.alpha = 0.5
            vc = storyboard?.instantiateViewController(withIdentifier: "MessageViewController")
            
        }
        if sender.tag == 2{
            home.alpha = 0.5
            message.alpha = 0.5
            profile.alpha = 1.0
            fav.alpha = 0.5
            setting.alpha = 0.5
             vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        }
        if sender.tag == 4{
            home.alpha = 0.5
            message.alpha = 0.5
            profile.alpha = 0.5
            fav.alpha = 0.5
            setting.alpha = 1.0
            vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
        }
        
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        
    }
    
}
