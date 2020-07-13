//
//  HostProfileViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/10/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class HostProfileViewController: UIViewController,UpdateProfile {
    @IBOutlet weak var imageV:UIImageView?
    @IBOutlet weak var name:UILabel?
    @IBOutlet weak var place:CustomLabels?
    @IBOutlet weak var lastSeen_memberSince:UILabel!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var schedule:UILabel!
    @IBOutlet weak var schedule2:UILabel!
    @IBOutlet weak var year:UILabel!
    @IBOutlet weak var lastSeen:UILabel!
    @IBOutlet weak var language:UILabel!
    @IBOutlet weak var additionalInfo:UILabel!
    @IBOutlet weak var mealDesc:UILabel!
    @IBOutlet weak var skills:UILabel!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var personalDescription:UILabel!
    @IBOutlet weak var paymentDescription:UILabel!
    @IBOutlet weak var hoursLabel:UILabel!
    @IBOutlet weak var daysLabel:UILabel!
    @IBOutlet weak var countryTable:UITableView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var headerTitle:UILabel?
    @IBOutlet weak var postTitle:UILabel?
    @IBOutlet weak var mealOption:UILabel?
    @IBOutlet weak var mealOption2:UILabel?
    @IBOutlet weak var paymentOption:UILabel?
    @IBOutlet weak var accomodations2:UILabel?
    @IBOutlet weak var accomodations:UILabel?
    @IBOutlet weak var profile:UIImageView?
    @IBOutlet weak var aboutMe:UILabel?
    @IBOutlet weak var countryHeight:NSLayoutConstraint!
    @IBOutlet var verifiedStatus:[UILabel]!
    @IBOutlet var startSelection:[UIImageView]!
    
    var countries = [String]()
    var imageData = [images]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        menuView.delegate = self
   SharedUser.manager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SharedUser.manager.delegate = nil
    }
    
    @IBAction func loadMenu(_ sender:UIButton){
        
        self.view.addSubview(menuView)

    }
    
    func reloadData() {
        self.loadUI(volItem: SharedUser.manager.auth.listing ?? Listing())
    }
    
    override func viewDidAppear(_ animated: Bool) {
          
            self.loadUI(volItem: SharedUser.manager.auth.listing ?? Listing())
    }
    
    private func loadUI(volItem:Listing){
        headerTitle?.text = volItem.title
        postTitle?.text = volItem.title
        
        let f_name = SharedUser.manager.auth.user?.firstName ?? ""
        let l_name = SharedUser.manager.auth.user?.lastName ?? ""
        
        let age = "(" + (SharedUser.manager.auth.user?.age ?? "") + ")"
        if age != "()"{
        name?.text = "\(f_name) \(l_name) \(age)"
        }else{
           name?.text = "\(f_name) \(l_name) "
        }
        imageV?.kf.indicatorType = .activity
        if let url = URL(string: volItem.image?.medium ?? ""){
            imageV?.kf.setImage(with: url)
        }
        place?.text = volItem.location?.country ?? ""
        let lastSeen = "Last seen on \((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
        lastSeen_memberSince.text = lastSeen + ", " + memberSince
        skills.text = volItem.jobs?.values.joined(separator: " | ")
        skills.text = skills.text?.capitalized
        status.text = "\(volItem.workingHours ?? "") Hours/day | \(volItem.workingDays ?? "") days/week"
        mealOption?.text = (volItem.mealsOption ?? "") == "1" ? "Self catering" : "Shared meals"
        accomodations?.text = volItem.accommodations?.values.joined(separator: " | ")
        accomodations2?.text = volItem.accommodations?.values.joined(separator: " | ")
        location.text = volItem.member?.languages?.values.joined(separator: ", ")
        additionalInfo.text = additionalInfo.text! + "\n" + (volItem.description ?? "")
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start + " - " + item.end
            schedule = schedule + "\n"
            
        }
        
        if schedule.last == "\n"{
            schedule.removeLast()
        }
        self.schedule.text = schedule != "" ? schedule : "Open for offers, contact us"
        
        self.schedule2.text = self.schedule.text
        
        hoursLabel.text = "\(volItem.workingHours ?? "") Hours/day"
        daysLabel.text = "\(volItem.workingDays ?? "") days/week"
        mealOption2?.text = (volItem.mealsOption ?? "") == "1" ? "Self catering" : "Shared meals"
        mealDesc.text = volItem.mealDescription ?? ""
        switch volItem.paymentOption ?? "" {
        case "1":
            paymentOption?.text = "No money is involved"
        case "2":
            paymentOption?.text = "Offer money for all working hours"
        case "3":
            paymentOption?.text = "Offer money for additional hours"
        default:
            break
        }
        self.lastSeen.text = "\((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        self.language.text = volItem.member?.languages?.values.joined(separator: ", ")
        year.text = "\((volItem.publishedOn ?? "").getDate().getYear())"
        
        paymentDescription.text = volItem.paymentDescription ?? ""
        personalDescription.text = volItem.member?.personalDescription ?? ""
        
        
        profile?.kf.indicatorType = .activity
        if let url = URL(string: volItem.member?.image?.medium ?? ""){
            profile?.kf.setImage(with: url)
        }
        
        aboutMe?.text = aboutMe!.text! + "(\(volItem.member?.firstName ?? ""))"
        
        
        if let jobs = volItem.jobs?.values{
        countries = Array(jobs)
        }
        countryHeight.constant = CGFloat((countries.count) * 30)
        countryTable.reloadData()
        
        
            
            if let payment = SharedUser.manager.auth.listing?.member?.ratings?.payment, payment == "Y"{
                verifiedStatus[0].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[0].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[0].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[0].image = UIImage(named: "startUnselected")
            }
            
            if let phone = SharedUser.manager.auth.listing?.member?.ratings?.phone, phone == "Y"{
                verifiedStatus[1].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[1].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[1].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[1].image = UIImage(named: "startUnselected")
            }
            if let response = SharedUser.manager.auth.listing?.member?.ratings?.response, response == "Y"{
                verifiedStatus[2].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[2].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[2].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[2].image = UIImage(named: "startUnselected")
            }
            if let review = SharedUser.manager.auth.listing?.member?.ratings?.reviews, review == "Y"{
                verifiedStatus[3].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[3].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[3].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[3].image = UIImage(named: "startUnselected")
            }
            if let email = SharedUser.manager.auth.listing?.member?.ratings?.email, email == "Y"{
                verifiedStatus[4].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[4].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[4].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[4].image = UIImage(named: "startUnselected")
            }
            if let passport = SharedUser.manager.auth.listing?.member?.ratings?.passport, passport == "Y"{
                verifiedStatus[5].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[5].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[5].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[5].image = UIImage(named: "startUnselected")
            }
            if let experience = SharedUser.manager.auth.listing?.member?.ratings?.experienced, experience == "Y"{
                verifiedStatus[6].font = UIFont(name: "Lato-bold", size: 15.0)
                startSelection[6].image = UIImage(named: "starSelected")
            }else{
                verifiedStatus[6].font = UIFont(name: "Lato-Regular", size: 15.0)
                startSelection[6].image = UIImage(named: "startUnselected")
            }
            
        
        
    }
}
extension HostProfileViewController:Menudelegates{
    func menuItemDidSelect(for action: Action) {
        self.navigationController?.popToRootViewController(animated: false)
        switch action {
        case .logout:
            UserDefaults.standard.removeObject(forKey: constants.accessToken.rawValue)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainnav")
            let appdel = UIApplication.shared.delegate as? AppDelegate
            appdel?.window?.rootViewController = vc
            break
        case .hostlist:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HostsVC") as! HostsVC
            vc.modalPresentationStyle = .overCurrentContext
            //vc.VMObject = landingVMObject
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
}
extension HostProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        cell.country.text = countries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
}
