//
//  LandingVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import CoreLocation
protocol MapViewResponsable {
    func mapViewClicked(loc:CLLocation)
}

class LandingVC: UIViewController {

  
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var countries:ContinentView!
    var VMObject:LandingVM!
    var searchModel = HostSearchModel()
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        VMObject = LandingVM()
        menuView.frame = self.view.frame
        menuView.delegate = self
        countries.delegate = self
        countries.host = true
        
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
            vollist.menu_delegate = self
            vollist.object = VMObject.Volunteers
        }
    
            if let vollist = segue.destination as? HostsVC{
                vollist.VMObject = VMObject
                vollist.menu_delegate = self
                vollist.location = VMObject.location
                vollist.object.hosts = VMObject.Hosts
              
                  }
        
    }
    
    @IBAction func volunteerSignup(_ sender:UIButton){
        self.performSegue(withIdentifier: "volunteer", sender: nil)
    }
    
    @IBAction func titleSearchClicked(_ sender:UIButton){
        let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as! LandingVCSliderCell
        let vollist = storyboard?.instantiateViewController(withIdentifier: "HostsVC") as! HostsVC
            vollist.VMObject = VMObject
            vollist.menu_delegate = self
        let value = cell.titlesOfimage[cell.sliderIndex]
        searchModel.jobs = [cell.valueOfImages[value]!]
            searchModel.jobsArray = [value]
            vollist.copyModal = searchModel
        self.navigationController?.pushViewController(vollist, animated: false)
    }
    
    @IBAction func hostSignup(_ sender:UIButton){
           self.performSegue(withIdentifier: "host", sender: nil)
       }
    
    @IBAction func loginClicked(_ sender:UIButton){
            
       let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        if registerVC != nil, loginVC != nil{
            self.navigationController?.viewControllers = [self,registerVC!,loginVC!]
        }
        
    }
    
    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
     @IBAction func loadHosts(_ sender:UIButton){
        
        
         performSegue(withIdentifier: "hostwithlocation", sender: nil)
        
     }
    @IBAction func showVolunteers(_ sender:UIButton){
      self.performSegue(withIdentifier: "vollist", sender: nil)
      }
    
    @IBAction func loadCountries(_ sender:UIButton){
        countries.isHidden = false
     }
}

extension LandingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 260.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandingVCSliderCell") as! LandingVCSliderCell
            return cell
            
        case 1:
             let cell = tableView.dequeueReusableCell(withIdentifier: "NearByHostMAPCell") as! NearByHostMAPCell
             if VMObject.Hosts == nil {
                cell.VMObject = VMObject
                cell.mapResponsibleDelegate = self
                cell.loadMap(dependency: self)
             }
                return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandingVCVolunteersCell") as! LandingVCVolunteersCell
            if VMObject.Volunteers == nil{
             cell.VMObject = VMObject
             cell.getVolunteers(vc: self)
            }
                return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "signup")
            return cell!
            
           
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension LandingVC:Menudelegates{
    
    func menuItemDidSelect(for action: Action) {
        let vollist = storyboard?.instantiateViewController(withIdentifier: "HostsVC") as! HostsVC
            vollist.VMObject = VMObject
            vollist.menu_delegate = self
            vollist.isAllHost = true
          self.navigationController?.popToRootViewController(animated: false)

        switch action {
        case .login:
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            if registerVC != nil, loginVC != nil{
                self.navigationController?.viewControllers = [self,registerVC!,loginVC!]
            }
        case .logout:
            break
        case .registerHost:
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
           registerVC?.type = "h"
            if registerVC != nil{
                self.navigationController?.pushViewController(registerVC!, animated: false)
               // self.navigationController?.viewControllers = [self,registerVC!]
            }
            break
        case .registerVolunteer:
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVc") as? SignUpVc
            if registerVC != nil{
                        registerVC?.type = "v"
                             self.navigationController?.pushViewController(registerVC!, animated: false)
                }
            break
        case .other:
            countries.isHidden = true
            self.showProgressAlert()
        case .hostlist:
      self.navigationController?.pushViewController(vollist, animated: false)
        case .volunteers:
            performSegue(withIdentifier: "vollist", sender: nil)
        case .AboutUS:
             performSegue(withIdentifier: "AboutUS", sender: nil)
            break
        case .Response(let data):
            let countriesData = data as? [continents:[countries]]
                    let keys = Array<continents>(countriesData!.keys)
                    searchModel.continent = keys.first?.title ?? ""
                    searchModel.countries = (countriesData?[keys.first!]?.map({ $0.title }))! as! [String]
                    searchModel.conti = keys.first?.continentId
                    searchModel.cntry = ((countriesData?[keys.first!]?.map({ $0.countryCode }))! as! [String]).joined(separator: "|")
        
            vollist.copyModal = searchModel
            self.navigationController?.pushViewController(vollist, animated: false)
            break
        default:
            break
        }
        
       
    }
    
   
}

extension LandingVC:ListViewDelegate,MapViewResponsable{
    func collViewdidUpdate(index: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VolunteerVC") as! VolunteerVC
        vc.indexpath = index
        vc.object = VMObject.Volunteers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func mapViewClicked(loc:CLLocation) {
                  
        let mapvc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapvc.location = VMObject.location
        mapvc.mapItems = VMObject.Hosts
      
        self.navigationController?.pushViewController(mapvc, animated: true)
                    
    }
}

