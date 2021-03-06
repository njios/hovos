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
     @IBOutlet weak var cover:UIView!
    var registration = false
    var VMObject:LandingVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        VMObject = LandingVM()
        cover.isHidden = false
            if let data = UserDefaults.standard.data(forKey: constants.accessToken.rawValue){
                let decoder = JSONDecoder()
                SharedUser.manager.auth = try! decoder.decode(Auth.self, from: data)
            }
        
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "API_KEY":constants.Api_key.rawValue,
                         ]
        
                          var recommendedRequest = NetworkPacket()
                          recommendedRequest.apiPath = ApiEndPoints.user.rawValue
                          recommendedRequest.header = header
                          recommendedRequest.method = "GET"
                   ApiCall(packet: recommendedRequest) { (data, status, code) in
                            if code == 200{
                                let decoder = JSONDecoder()
                                let userData = try! decoder.decode(Auth.self, from: data!)
                                
                                if userData.user == nil {
                                    let userData1 = try! decoder.decode(Auth1.self, from: data!)
                                    SharedUser.manager.auth.user = userData1.user
                                    SharedUser.manager.auth.listing = Listing()
                                    SharedUser.manager.auth.listing?.member = User1()
                                }else{
                                    if userData.listing == nil {
                                      SharedUser.manager.auth.listing = Listing()
                                      SharedUser.manager.auth.listing?.member = User1()
                                    }else{
                                    SharedUser.manager.auth.listing = userData.listing
                                    }
                                    SharedUser.manager.auth.user = userData.user
                                }
                               
                                if let updatedData = try? JSONEncoder().encode(SharedUser.manager.auth){
                                    
                                UserDefaults.standard.set(updatedData, forKey: constants.accessToken.rawValue)
                                }
                                    DispatchQueue.main.async {
                                        if self.registration == true{
                                            
                                            let stb = UIStoryboard(name: "Profile", bundle: nil)
                                            let vc = stb.instantiateViewController(withIdentifier: "CompleteProfileVC")
                                            vc.modalPresentationStyle = .overCurrentContext
                                            topViewController()?.present(vc, animated: false, completion: {
                                                DispatchQueue.main.async {
                                                     self.updateUser()
                                                }
                                            })
                                        }else{
                                    self.updateUser()
                                        }
                                }
                              
                            }
                          
                }
        
    }
    
    
    func updateUser(){
          self.cover.isHidden = true
        home.alpha = 1.0
        message.alpha = 0.5
        profile.alpha = 0.5
        fav.alpha = 0.5
        setting.alpha = 0.5
        
        
        
        
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
        
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
            if SharedUser.manager.auth.user?.role?.lowercased() == "v"{
             vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
            }else{
                 vc = storyboard?.instantiateViewController(withIdentifier: "HostProfileViewController")
            }
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
