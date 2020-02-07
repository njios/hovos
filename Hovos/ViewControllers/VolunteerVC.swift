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
    var indexpath:IndexPath?
    let photosDelegate = PhotosCollection()
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var footerlabel:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var menuView:MenuVC!
    override func viewDidLoad() {
        super.viewDidLoad()
      menuView.frame = self.view.frame
      menuView.delegate = self
      if let _ = self.indexpath{
        ViewHelper.shared().showLoader(self)
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
      if let index = self.indexpath{
            self.collView.scrollToItem(at: index, at: .left, animated: false)
        ViewHelper.shared().hideLoader()
        }
    }
    
    @IBAction func favSelected(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func loadMenu(_ sender:UIButton){
         
         self.view.addSubview(menuView)
    
         
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
        cell.countries = Array(volItem.countries!.values) as! [String]
        cell.countryTable.reloadData()
        cell.countryHeight.constant = CGFloat((volItem.countries?.count ?? 0) * 30)
        titleLabel.text = "Volunteers, \(indexPath.row + 1) of \(object?.count ?? 0)"
        footerlabel.text = "  CONTACT \(cell.name!.text!.uppercased())  "
        let country = volItem.location?.country ?? ""
        let city = volItem.location?.city ?? ""
        cell.place?.text = country + ", " + city
        cell.volunteerSlogan.text = " \"\(volItem.slogan ?? "")\" "
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
       
        cell.location.text = (volItem.location?.country ?? "") + ", Last seen on " + "\((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        let languages = volItem.member?.languages?.values
       
        cell.language.text = languages?.joined(separator: " | ")
        cell.status.text = "I am open for meeting travelers"
        let jobs = volItem.jobs?.values
        cell.jobs.text = jobs?.joined(separator: " | ") //"Elderly care | Help in the house | Hostel support | House sitting | Teaching"
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start! + " - " + item.end!
            schedule = schedule + "\n"
        }
        cell.schedule.text = schedule
        
        let rem = (volItem.images?.count ?? 0) % 3
        var quo = (volItem.images?.count ?? 0) / 3
        var width = (cell.photosCollview.frame.width / 3)
        if rem == 0 && quo == 0{
            cell.photosHeight.constant = 0
        }
        if rem > 0 && quo > 0{
            quo = (quo + 1)
            width = (width * CGFloat(quo))
            cell.photosHeight.constant = width + 50
        }
        if rem == 0 && quo > 0{
            width = (width * CGFloat(quo))
               cell.photosHeight.constant = width + 50
        }
        if rem > 0 && quo == 0{
            cell.photosHeight.constant = width  + 50
        }
        photosDelegate.objects = volItem
        cell.photosCollview.delegate = photosDelegate
        cell.photosCollview.dataSource = photosDelegate
        cell.photosCollview.reloadData()
        cell.place?.setUnderLine()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var hieght = self.view.frame.size.height - collectionView.frame.origin.y - 50
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            hieght = hieght - (topPadding ?? 0) - (bottomPadding ?? 0)
        }
        return CGSize(width: self.view.frame.size.width, height: hieght)
        
    }
    
}


class PhotosCollection:NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var objects:VolunteerItem?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (objects?.images?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
            cell.imageV?.kf.indicatorType = .activity
            cell.imageV?.kf.setImage(with: URL(string:( objects?.images?[indexPath.row - 1].medium)?.replacingOccurrences(of: "large", with: "small").replacingOccurrences(of: "medium", with: "small") ?? ""))
                       return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
         return CGSize(width: collectionView.frame.size.width, height: 50)
        }else{
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
        }
    }
    
}
extension VolunteerVC:Menudelegates{
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
         
            self.showProgressAlert()
        case .hostlist:
            if let vc  = self.navigationController?.viewControllers.first as? LandingVC{
                           vc.performSegue(withIdentifier: "hostlist", sender: nil)
                       }
        break
        case .volunteers:
           
            
         break
        case .AboutUS:
            break
        }
       
    }
}
