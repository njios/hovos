//
//  LandingVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleSignIn
class LandingVC: UIViewController {

  
    @IBOutlet weak var scrollContainer:UIScrollView!
    @IBOutlet weak var volunteerSignupView:UIView!
    @IBOutlet weak var sliderCollView:UICollectionView!
    @IBOutlet weak var hostCollView:UICollectionView!
    @IBOutlet weak var volCollView:UICollectionView!
    var sliderDelegates = Dashboardslider()
    var listDelegates = VolunteerListCollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderCollView.delegate = sliderDelegates
        sliderCollView.dataSource = sliderDelegates
        sliderCollView.reloadData()
        hostCollView.delegate = listDelegates
        hostCollView.dataSource = listDelegates
        hostCollView.reloadData()
        volCollView.delegate = listDelegates
        volCollView.dataSource = listDelegates
        volCollView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollContainer.contentOffset.y = 0
        if UserDefaults.standard.bool(forKey: constants.accessToken.rawValue){
              scrollContainer.contentSize.height =  volunteerSignupView.frame.origin.y
               }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpVc{
            if segue.identifier == "volunteer"{
                vc.type = "v"
            }
        else{
            vc.type = "h"
        }
    }
    }

    @IBAction func volunteerSignup(_ sender:UIButton){
        self.performSegue(withIdentifier: "volunteer", sender: nil)
    }
    
    @IBAction func hostSignup(_ sender:UIButton){
           self.performSegue(withIdentifier: "host", sender: nil)
       }
    
    @IBAction func loadMenu(_ sender:UIButton){
        
        let nib = Bundle.main.loadNibNamed("MenuVc", owner: self, options: nil)
     
    }
}
