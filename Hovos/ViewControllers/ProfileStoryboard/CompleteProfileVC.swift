//
//  CompleteProfileVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/30/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class CompleteProfileVC: UIViewController {
    
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var completeProfile:UIImageView!
    @IBOutlet weak var completeProfileButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        prevButton.isHidden = true
        if SharedUser.manager.auth.user?.role?.lowercased() == "v"{
            nextButton.addTarget(self, action: #selector(self.nextClicked(_:)), for: .touchUpInside)
            prevButton.addTarget(self, action: #selector(self.removeChild(_:)), for: .touchUpInside)
            nextClicked(nextButton)
            
        }else{
            nextButton.addTarget(self, action: #selector(self.hostNextClicked(_:)), for: .touchUpInside)
            prevButton.addTarget(self, action: #selector(self.removeHostChild(_:)), for: .touchUpInside)
            hostNextClicked(nextButton)
            pageControl.numberOfPages = 11
        }
    }
    
    @IBAction func closeTheScreen(_ sender:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func removeChild(_ sender:UIButton){
        sender.tag = sender.tag - 1
        var vc :UIViewController!
        if sender.tag == 0{
            prevButton.isHidden = true
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_ContinentsVC") as? EditProfile_ContinentsVC
        }
        
        if sender.tag == 1{
            
            vc = storyboard?.instantiateViewController(withIdentifier: "Edirprofile_SelectSkillsVC") as? Edirprofile_SelectSkillsVC
            
        }
        
        if sender.tag == 2{
            vc = storyboard?.instantiateViewController(withIdentifier: "Editprofile_AboutSkillsVC") as? Editprofile_AboutSkillsVC
        }
        
        if sender.tag == 3{
            
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_DatesVC") as? EditProfile_DatesVC
        }
        
        if sender.tag == 4{
            
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
        }
        
        if sender.tag == 5{
            
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_locationVVC")
            
        }
        
        if sender.tag == 6{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC")
        }
        if sender.tag == 7{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_optionalLanguageVC") as? EditProfile_optionalLanguageVC
            
        }
        if sender.tag == 8{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_sloganVC")
        }
        
        if sender.tag == 9{
            
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_AboutYouselfVC")
        }
        nextButton.setTitle("NEXT >", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextClicked(_:)), for: .touchUpInside)
        nextButton.tag = sender.tag + 1
        if sender.tag >= 0{
            pageControl.currentPage = sender.tag
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        }
        
    }
    
    @objc func publish(){
        
    }
    
    @objc func nextClicked(_ sender:UIButton){
        if sender.tag < 10{
            var vc :UIViewController!
            if sender.tag == 0{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_ContinentsVC") as? EditProfile_ContinentsVC
            }
            if sender.tag == 1{
                vc = storyboard?.instantiateViewController(withIdentifier: "Edirprofile_SelectSkillsVC") as? Edirprofile_SelectSkillsVC
            }
            if sender.tag == 2{
                vc = storyboard?.instantiateViewController(withIdentifier: "Editprofile_AboutSkillsVC") as? Editprofile_AboutSkillsVC
            }
            if sender.tag == 3{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_DatesVC") as? EditProfile_DatesVC
            }
            if sender.tag == 4{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
            }
            if sender.tag == 5{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_locationVVC")
            }
            if sender.tag == 6{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC")
            }
            if sender.tag == 7{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_optionalLanguageVC") as? EditProfile_optionalLanguageVC
                
            }
            if sender.tag == 8{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_sloganVC")
            }
            
            if sender.tag == 9{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_AboutYouselfVC")
            }
            pageControl.currentPage = sender.tag
            
            if sender.tag != 0{
                prevButton.isHidden = false
            }else{
                prevButton.isHidden = true
            }
            sender.tag = sender.tag + 1
            prevButton.tag = sender.tag - 1
            
            if sender.tag == 10{
                nextButton.setTitle("PUBLISH >", for: .normal)
                
            }else{
                nextButton.setTitle("NEXT >", for: .normal)
                
            }
            
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        }else{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.vol_publish(id: SharedUser.manager.auth.user?.listingId ?? "").rawValue
            
            identifyYourself.header = header
            identifyYourself.data = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing), options: []) as! [String : Any]
            let member = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing?.member), options: []) as! [String : Any]
            identifyYourself.data["member"] = member
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCallWithJsonEncoding (packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                if code == 200{
                    SharedUser.manager.updateUser()
                    DispatchQueue.main.async{
                        self.completeProfile.isHidden = false
                        self.completeProfileButton.isHidden = false
                    }
                }else{
                    Hovos.showAlert(vc: self, mssg: "Error in publish")
                }
            }
        }
        
    }
    
    
    
    @objc func hostNextClicked(_ sender:UIButton){
        if sender.tag < 11{
            var vc :UIViewController!
            if sender.tag == 0{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_HostNeedVC") as? EditProfile_HostNeedVC
            }
            if sender.tag == 1{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_locationVVC") as? EditProfile_locationVVC
            }
            if sender.tag == 2{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_DatesVC") as? EditProfile_DatesVC
            }
            if sender.tag == 3{
                vc = storyboard?.instantiateViewController(withIdentifier: "Edirprofile_SelectSkillsVC") as? Edirprofile_SelectSkillsVC
            }
            if sender.tag == 4{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
                (vc as! EditProfile_photoesVC).type = "place"
            }
            if sender.tag == 5{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_ExchangeDealVc") as! EditProfile_ExchangeDealVc
            }
            if sender.tag == 6{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC") as! EditProfile_languagesVC
                (vc as! EditProfile_languagesVC).type = "accommodations"
                
            }
            if sender.tag == 7{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
                (vc as! EditProfile_photoesVC).type = "accommodations"
            }
            if sender.tag == 8{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC")
            }
            
            if sender.tag == 9{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_optionalLanguageVC") as? EditProfile_optionalLanguageVC
            }
            if sender.tag == 10{
                vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_AboutYouselfVC")
            }
            pageControl.currentPage = sender.tag
            
            if sender.tag != 0{
                prevButton.isHidden = false
            }else{
                prevButton.isHidden = true
            }
            sender.tag = sender.tag + 1
            prevButton.tag = sender.tag - 1
            
            if sender.tag == 11{
                nextButton.setTitle("PUBLISH >", for: .normal)
                
            }else{
                nextButton.setTitle("NEXT >", for: .normal)
                
            }
            
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        }else{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.host_publish(id: SharedUser.manager.auth.user?.listingId ?? "").rawValue
            
            identifyYourself.header = header
            identifyYourself.data = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing), options: []) as! [String : Any]
            let member = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(SharedUser.manager.auth.listing?.member), options: []) as! [String : Any]
            identifyYourself.data["member"] = member
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCallWithJsonEncoding(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                if code == 200{
                      SharedUser.manager.updateUser()
                    DispatchQueue.main.async{
                        self.completeProfile.isHidden = false
                        self.completeProfileButton.isHidden = false
                    }
                }else{
                    Hovos.showAlert(vc: self, mssg: "Error in publish")
                }
            }
        }
        
    }
    
    @objc func removeHostChild(_ sender:UIButton){
        sender.tag = sender.tag - 1
        var vc :UIViewController!
        
        if sender.tag == 0{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_HostNeedVC") as? EditProfile_HostNeedVC
            prevButton.isHidden = true
        }
        if sender.tag == 1{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_locationVVC") as? EditProfile_locationVVC
        }
        if sender.tag == 2{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_DatesVC") as? EditProfile_DatesVC
        }
        if sender.tag == 3{
            vc = storyboard?.instantiateViewController(withIdentifier: "Edirprofile_SelectSkillsVC") as? Edirprofile_SelectSkillsVC
        }
        if sender.tag == 4{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
        }
        if sender.tag == 5{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_ExchangeDealVc") as! EditProfile_ExchangeDealVc
        }
        if sender.tag == 6{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC")
        }
        if sender.tag == 7{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_photoesVC")
        }
        if sender.tag == 8{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_languagesVC")
        }
        
        if sender.tag == 9{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_optionalLanguageVC") as? EditProfile_optionalLanguageVC
        }
        if sender.tag == 10{
            vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_AboutYouselfVC")
        }
        
        nextButton.setTitle("NEXT >", for: .normal)
        nextButton.addTarget(self, action: #selector(self.hostNextClicked(_:)), for: .touchUpInside)
        nextButton.tag = sender.tag + 1
        if sender.tag >= 0{
            pageControl.currentPage = sender.tag
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            vc!.view.frame =  CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.addChild(vc!)
            self.containerView.addSubview(vc!.view)
        }
        
    }
    
    private func getVolparameters()->[String:Any]{
        let schedule = try!  JSONEncoder().encode((SharedUser.manager.auth.listing?.schedules! ?? [schedules()])!)
        return  [
            "additionalDesc": SharedUser.manager.auth.user?.additionalDesc ?? "",
            // "companion": "Y",
            "countries": (SharedUser.manager.auth.listing?.countries ?? [:])!,
            //"isAllergic": "N",
            //"isCompanion": "Y",
            //"isDriving": "N",
            //"isFlaxibleDates": "Y",
            //"isSmoker": "N",
            //"isVegetarian": "N",
            "jobs": Array(SharedUser.manager.auth.listing?.jobs?.keys ?? [:].keys),
            "location": (SharedUser.manager.auth.listing?.location ?? [:])!,
            "name": SharedUser.manager.auth.user?.firstName ?? "",
            "placeDescription": SharedUser.manager.auth.listing?.placeDescription ?? "",
            "schedules": try! JSONSerialization.jsonObject(with: schedule, options: []),
            "skillDescription": SharedUser.manager.auth.listing?.skillDescription ?? "",
            "slogan": SharedUser.manager.auth.listing?.slogan ?? ""
        ]
    }
}
