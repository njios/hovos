//
//  DashboardVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/23/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleMaps
class DashboardVC: UIViewController {
    @IBOutlet weak var recommended:UICollectionView!
    @IBOutlet weak var latest:UICollectionView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var nearByLabel:CustomLabels!
    @IBOutlet weak var RecommendedLabel:CustomLabels!
    @IBOutlet weak var NewLabel:CustomLabels!
    var recommendedDelegates = VolunteerListCollView()
    var latestDelegates = VolunteerListCollView()
    
    var VMObject = DashBoardVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        menuView.delegate = self
        VMObject.getLocation(completion: updateUI)
        
        if SharedUser.manager.auth.role!.lowercased() == "v"{
            nearByLabel.text = "Hosts nearby"
            RecommendedLabel.text = "Recommended Hosts"
            NewLabel.text = "New Hosts"
            nearByLabel.textColor = UIColor(named: "orangeColor")
            RecommendedLabel.textColor = UIColor(named: "orangeColor")
            NewLabel.textColor = UIColor(named: "orangeColor")
        }else{
            nearByLabel.text = "Volunteers nearby"
            RecommendedLabel.text = "Recommended volunteers"
            NewLabel.text = "New volunteers"
            nearByLabel.textColor = UIColor(named: "greenColor")
            RecommendedLabel.textColor = UIColor(named: "greenColor")
            NewLabel.textColor = UIColor(named: "greenColor")
        }
        nearByLabel.isComplete = true
        NewLabel.isComplete = true
        RecommendedLabel.isComplete = true
    }
    private func updateUI(){
        
        recommendedDelegates.modalObject = VMObject.recommendedItems
        latestDelegates.modalObject = VMObject.latestItems
        recommended.delegate = recommendedDelegates
        recommended.dataSource = recommendedDelegates
        recommendedDelegates.delegate = self
        recommended.reloadData()
        latest.delegate = latestDelegates
        latest.dataSource = latestDelegates
        latestDelegates.delegate = self
        latest.reloadData()
        
    }
    @IBAction func loadMenu(_ sender:UIButton){
        
        self.view.addSubview(menuView)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
extension DashboardVC:ListViewDelegate{
    func collViewdidUpdate(index: IndexPath) {
        
    }
}
