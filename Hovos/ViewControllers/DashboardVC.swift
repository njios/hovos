//
//  DashboardVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/23/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    @IBOutlet weak var hostCollView:UICollectionView!
       @IBOutlet weak var volCollView:UICollectionView!
     var listDelegates = VolunteerListCollView()
     @IBOutlet weak var menuView:MenuVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        hostCollView.delegate = listDelegates
               hostCollView.dataSource = listDelegates
               hostCollView.reloadData()
               volCollView.delegate = listDelegates
               volCollView.dataSource = listDelegates
               volCollView.reloadData()
        menuView.frame = self.view.frame
        menuView.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func loadMenu(_ sender:UIButton){
           
           self.view.addSubview(menuView)
      
           
       }


}
extension DashboardVC:Menudelegates{
    func menuItemDidSelect(for action: Action) {
        menuView.removeFromSuperview()
        switch action {
        case .logout:
            UserDefaults.standard.removeObject(forKey: constants.accessToken.rawValue)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainnav")
            let appdel = UIApplication.shared.delegate as? AppDelegate
            appdel?.window?.rootViewController = vc
            break
        default:
            break
        }
       
    }
}
