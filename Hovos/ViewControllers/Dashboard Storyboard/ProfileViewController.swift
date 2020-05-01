//
//  ProfileViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/17/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

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
           var countries = [String]()
           var imageData = [images]()
           let photosDelegate = PhotosCollection()
           
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI(volItem: SharedUser.manager.auth.listing ?? Listing())
       
        // Do any additional setup after loading the view.
    }
    
    private func loadUI(volItem:Listing){
        imageData = volItem.images ?? []
                                         headerTitle?.text = volItem.name ?? ""
                                         name?.text = volItem.name ?? ""
                                         countries = ((volItem.countries?.values) as? [String]) ?? []
                                         countryTable.reloadData()
                                         countryHeight.constant = CGFloat((volItem.countries?.count ?? 0) * 30)
                                         let country = volItem.location?.country ?? ""
                                         let city = volItem.location?.city ?? ""
                                         place?.text = country + ", " + city
                                         volunteerSlogan.text = " \"\(volItem.slogan ?? "")\" "
                                         skills.text = volItem.skillDescription ?? ""
                                         let personalDesc = volItem.member?.personalDescription ?? ""
                                         let additionalDesc = volItem.additionalDesc ?? ""
                                         additionalInfo.text = personalDesc + "\n" + additionalDesc
                                         placeDescription.text = volItem.placeDescription ?? ""
                                         imageV?.image = nil
                                         imageV?.kf.indicatorType = .activity
                                         imageV?.kf.setImage(with: URL(string: volItem.image ?? ""))
                                         let lastSeen = "Last seen on \((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
                                         let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
                                         
                                         lastSeen_memberSince.text = lastSeen + ", " + memberSince
                                        
                                         location.text = (volItem.location?.country ?? "") + ", Last seen on " + "\((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
                                         let languages = volItem.member?.languages?.values
                                        
                                         language.text = languages?.joined(separator: " | ")
                                         status.text = "I am open for meeting travelers"
                                         let job = volItem.jobs?.values
                                         jobs.text = job?.joined(separator: " | ") //"Elderly care | Help in the house | Hostel support | House sitting | Teaching"
                                         let rem = (volItem.images?.count ?? 0) % 3
                                         var quo = (volItem.images?.count ?? 0) / 3
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
        photosDelegate.objects = volItem.images
                                         photosCollview.delegate = photosDelegate
                                         photosCollview.dataSource = photosDelegate
                                         photosCollview.reloadData()
                                         place?.setUnderLine()
                                         photosCount.text = ""
                                         if let img = volItem.images, img.count > 0{
                                             photosCount.text = " 1/\(img.count)"
                                             photosCount.isComplete = true
                                         }
    }

}
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
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
