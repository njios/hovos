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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if sender.tag == 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
            
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        }
    }
    
}
