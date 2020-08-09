//
//  ProfileViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/17/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

protocol UpdateProfile {
    func reloadData()
}

class ProfileViewController: UIViewController,UpdateProfile {
    
    @IBOutlet weak var headerTitle:UILabel?
    @IBOutlet weak var imageV:UIImageView?
    @IBOutlet weak var name:UILabel?
    @IBOutlet weak var place:CustomLabels?
    @IBOutlet weak var lastSeen_memberSince:UILabel!
    @IBOutlet weak var volunteerSlogan:UILabel!
    @IBOutlet weak var jobs:UILabel!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var schedule:UILabel!
    @IBOutlet weak var photosCount:CustomLabels!
    @IBOutlet weak var language:UILabel!
    @IBOutlet weak var additionalInfo:UILabel!
    @IBOutlet weak var skills:UILabel!
    @IBOutlet weak var placeDescription:UILabel!
    @IBOutlet var verifiedStatus:[UILabel]!
    @IBOutlet var startSelection:[UIImageView]!
    @IBOutlet weak var countryHeight:NSLayoutConstraint!
    @IBOutlet weak var countryTable:UITableView!
    @IBOutlet weak var photosCollview:UICollectionView!
    @IBOutlet weak var photosHeight:NSLayoutConstraint!
    @IBOutlet weak var menuView:MenuVC!
    
    var countries = [String]()
    
    let photosDelegate = PhotosCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        menuView.delegate = self
        SharedUser.manager.delegate = self
        self.loadUI()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SharedUser.manager.delegate = nil
    }
    
    func reloadData() {
        loadUI()
    }
    
    private func loadUI(){
        let user = SharedUser.manager.auth.user
        let listing = SharedUser.manager.auth.listing
        
        headerTitle?.text = (user?.firstName ?? "")
        headerTitle?.text = (headerTitle?.text!)! + (user?.lastName ?? "")
        
        imageV?.image = nil
        imageV?.kf.indicatorType = .activity
        imageV?.kf.setImage(with: URL(string: listing?.image?.medium ?? ""))
        
        name?.text = user?.firstName ?? ""
        name?.text = (name?.text!)! + (user?.lastName ?? "")
        
        let country = listing?.location?.country ?? "Unknown"
        let city = listing?.location?.city ?? ""
        place?.text = country + ", " + city
        
        
        let lastSeen = "Last seen on \((listing?.lastLogin ?? "").getDate().getMonth()) \((listing?.lastLogin ?? "").getDate().getDay())"
        let memberSince = "member since \((listing?.publishedOn ?? "").getDate().getYear())"
               lastSeen_memberSince.text = lastSeen + ", " + memberSince
        
        if let slogan = listing?.slogan{
        volunteerSlogan.text = " \"\(slogan)\" "
        }
        
        
        let job = listing?.jobs?.values
            jobs.text = job?.joined(separator: " | ")
        
        location.text = (listing?.location?.country ?? "") + ", Last seen on " + "\((listing?.lastLogin ?? "").getDate().getMonth()) \((listing?.lastLogin ?? "").getDate().getDay())"
        
        status.text = "I am open for meeting travelers"
        skills.text = listing?.skillDescription ?? ""
        
      
        let personalDesc = user?.personalDescription ?? ""
        let additionalDesc = listing?.additionalDesc ?? ""
        additionalInfo.text = personalDesc + "\n" + additionalDesc
        
        if let countriesValue = listing?.countries?.values{
              countries =  Array<String>( countriesValue )
              countryTable.reloadData()
              countryHeight.constant = CGFloat(countries.count * 30)
              }
        
        placeDescription.text = listing?.placeDescription ?? ""
       
        let languages = listing?.member?.languages?.values
        language.text = languages?.joined(separator: " | ")
        
        let rem = (listing?.images?.count ?? 0) % 3
        var quo = (listing?.images?.count ?? 0) / 3
        var width = (photosCollview.frame.width / 3)
        if rem == 0 && quo == 0{
            photosHeight.constant = 0
        }
        if rem > 0 && quo > 0{
            quo = (quo + 1)
            width = (width * CGFloat(quo))
            photosHeight.constant = width + 50
        }
        if rem == 0 && quo > 0{
            width = (width * CGFloat(quo))
            photosHeight.constant = width + 50
        }
        if rem > 0 && quo == 0{
            photosHeight.constant = width  + 50
        }
        photosDelegate.objects = listing?.images
        photosCollview.delegate = photosDelegate
        photosCollview.dataSource = photosDelegate
        photosCollview.reloadData()
        place?.setUnderLine()
        photosCount.text = ""
        if let img = listing?.images, img.count > 0{
            photosCount.text = " 1/\(img.count)"
            photosCount.isComplete = true
        }
    }
    
}
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
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
extension ProfileViewController:Menudelegates{
    func menuItemDidSelect(for action: MenuAction) {
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
                  
                   vc.VMObject = (self.parent as! TabBarController).VMObject
                   vc.isAllHost = true
                   self.navigationController?.pushViewController(vc, animated: true)
                   break
        case .volunteers:
                   let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                   let vc = storyBoard.instantiateViewController(withIdentifier: "VolunteerVC") as! VolunteerVC
                      self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}
