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
    override func viewDidLoad() {
        super.viewDidLoad()
        prevButton.isHidden = true
        nextButton.addTarget(self, action: #selector(self.nextClicked(_:)), for: .touchUpInside)
        nextClicked(nextButton)
    }
    
    
    @IBAction func removeChild(_ sender:UIButton){
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
            
        }
             
    }
    
    
    
    
    
    
}
