//
//  VolunteerVCViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/4/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class VolunteerVC: UIViewController {
  
    var object:[VolunteerItem]?
    var name = ""
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var footerButton:UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
}

extension VolunteerVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "volunteer", for: indexPath) as! listCell
    
       
        let volItem = object![indexPath.row]
        cell.name?.text = volItem.name ?? ""
        cell.countries = Array(volItem.countries!.values) as? [String]
        cell.countryTable.reloadData()
        cell.countryHeight.constant = CGFloat((volItem.countries?.count ?? 0) * 30)
        titleLabel.text = "Volunteers, \(indexPath.row + 1) of \(object?.count ?? 0)"
        footerButton.setTitle("CONTACT \(cell.name!.text!.uppercased())", for: .normal)
        let country = volItem.location?.country ?? ""
        let city = volItem.location?.city ?? ""
        cell.place?.text = country + ", " + city
        cell.volunteerSlogan.text = volItem.slogan ?? ""
        cell.skills.text = volItem.skillDescription ?? ""
        let personalDesc = volItem.member?.personalDescription ?? ""
        let additionalDesc = volItem.additionalDesc ?? ""
        cell.additionalInfo.text = personalDesc + "\n" + additionalDesc
        cell.placeDescription.text = volItem.placeDescription ?? ""
        cell.imageV?.image = nil
        cell.imageV?.kf.indicatorType = .activity
        cell.imageV?.kf.setImage(with: URL(string: volItem.image ?? ""))
        let lastSeen = "Last seen on \((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
        
        cell.lastSeen_memberSince.text = lastSeen + ", " + memberSince
       
        cell.location.text = (volItem.location?.country ?? "") + ", Last seen on" + "\((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        // let language = volItem.member?.languages?.joined(separator: " | ")
         cell.language.text = "English | French"
        cell.status.text = "I am open for meeting travelers"
        cell.jobs.text = "Elderly care | Help in the house | Hostel support | House sitting | Teaching"
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start! + " - " + item.end!
            schedule = schedule + "\n"
        }
        cell.schedule.text = schedule
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}


