//
//  LandingVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreLocation
import MapKit
class LandingVC: UIViewController {

  
    @IBOutlet weak var scrollContainer:UIScrollView!
    @IBOutlet weak var volunteerSignupView:UIView!
    @IBOutlet weak var sliderCollView:UICollectionView!
    @IBOutlet weak var hostCollView:UICollectionView!
    @IBOutlet weak var volCollView:UICollectionView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var countries:ContinentView!
    @IBOutlet weak var sliderTitle:CustomLabels!
    @IBOutlet weak var sliderSubTitle:UILabel!
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var prevButton:UIButton!
    var sliderDelegates = Dashboardslider()
    var listDelegates = VolunteerListCollView()
    var sliderIndex = 0
    var VMObject:LandingVM!
    var locManager = CLLocationManager()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderDelegates.vc = self
        VMObject = LandingVM()
        sliderCollView.delegate = sliderDelegates
        sliderCollView.dataSource = sliderDelegates
        sliderCollView.reloadData()
       
    
        
        menuView.frame = self.view.frame
        menuView.delegate = self
       
        countries.delegate = self
        sliderTitle.text = self.sliderDelegates.titlesOfimage[sliderIndex]
        sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
         sliderTitle.isComplete = true
        ViewHelper.shared().showLoader(self)
        DispatchQueue.global().async {
            self.VMObject.getVolunteerList { (status) in
                ViewHelper.shared().hideLoader()
                if status == true{
                    DispatchQueue.main.async {
                        self.listDelegates.modalObject = self.VMObject.VolunteerList.travellers
                        self.volCollView.delegate = self.listDelegates
                        self.volCollView.dataSource = self.listDelegates
                        self.volCollView.reloadData()
                    }
                }
            }
        }
        
        locManager.requestWhenInUseAuthorization()
      
    }
    override func viewWillLayoutSubviews() {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpVc{
            if segue.identifier == "volunteer"{
                vc.type = "v"
            }
        else if segue.identifier == "host"{
            vc.type = "h"
            }
    }
    
        if let vollist = segue.destination as? VolunteerVC{
            vollist.object = VMObject.VolunteerList.travellers ?? nil
        }
        
    }

    @IBAction func volunteerSignup(_ sender:UIButton){
        self.performSegue(withIdentifier: "volunteer", sender: nil)
    }
    
    @IBAction func hostSignup(_ sender:UIButton){
           self.performSegue(withIdentifier: "host", sender: nil)
       }
    
    @IBAction func loadMenu(_ sender:UIButton){
        
        self.view.addSubview(menuView)
   
        
    }
    
    @IBAction func showVolunteers(_ sender:UIButton){
          
    //
      self.performSegue(withIdentifier: "vollist", sender: nil)
          
      }
    
    @IBAction func loadCountries(_ sender:UIButton){
         
        countries.isHidden = false
    
         
     }
    
    @IBAction func nextSlide(_ sender:UIButton){
        sender.isUserInteractionEnabled = false
        if self.sliderCollView.scrollToNextItem(){
            sliderIndex = sliderIndex + 1
            sliderTitle.text = self.sliderDelegates.titlesOfimage[sliderIndex]
             sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
            sliderTitle.isComplete = true
          
        }
        
        
    }
    @IBAction func prevSlide(_ sender:UIButton){
                sender.isUserInteractionEnabled = false
        if self.sliderCollView.scrollToPreviousItem(){
            sliderIndex = sliderIndex - 1
            sliderTitle.text = self.sliderDelegates.titlesOfimage[sliderIndex]
             sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
             sliderTitle.isComplete = true
          
          
        }
       }
    
}

extension LandingVC:Menudelegates{
    func menuItemDidSelect(for action: Action) {
        menuView.removeFromSuperview()
        switch action {
        case .login:
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            if registerVC != nil, loginVC != nil{
                self.navigationController?.viewControllers = [self,registerVC!,loginVC!]
            }
        case .logout:
            break
        case .register:
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
           
            if registerVC != nil{
                self.navigationController?.viewControllers = [self,registerVC!]
            }
            break
        case .other:
            countries.isHidden = true
            self.showProgressAlert()
        }
       
    }
}
extension UICollectionView {
    func scrollToNextItem()->Bool {
        if self.contentOffset.x + self.bounds.size.width < self.contentSize.width{
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
            return true
        }else{
            return false
        }
    }

    func scrollToPreviousItem()->Bool {
         if self.contentOffset.x  > 0{
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
              return true
         }else{
            return false
        }
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
