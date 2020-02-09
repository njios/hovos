//
//  HostsVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/9/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import CoreLocation
class HostsVC: UIViewController {
    
    var object = [VolunteerItem]()
    var name = ""
    var indexpath:IndexPath?
    var location:CLLocation!
    let photosDelegate = PhotosCollection()
    weak var VMObject:LandingVM!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var loaderView:UIView!
    @IBOutlet weak var footerlabel:UILabel!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var collView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        menuView.delegate = self
        if object.count == 0{
            ViewHelper.shared().showLoader(self)
            
            VMObject.getNearByHosts(completion: { (items) in
                DispatchQueue.main.async {
                    self.object = items!
                    
                    self.collView.reloadData()
                    
                }
            })
            
            
            
            
            
        }else{
            self.loaderView.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.indexpath{
            self.collView.scrollToItem(at: index, at: .left, animated: false)
            ViewHelper.shared().hideLoader()
        }
    }
    
    @IBAction func loadMenu(_ sender:UIButton){
        
        self.view.addSubview(menuView)
        
        
    }
    @IBAction func favSelected(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
    }
    
}
extension HostsVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "volunteer", for: indexPath) as! listCell
        
        
        let volItem = object[indexPath.row]
        cell.name?.text = volItem.member?.firstName ?? ""
        let jobs = volItem.jobs?.values
        cell.countries = Array(jobs!)
        cell.countryHeight.constant = CGFloat((cell.countries.count) * 30)
        cell.countryTable.reloadData()
        
        titleLabel.text = "Hosts, \(indexPath.row + 1) of \(object.count )"
        footerlabel.text = "  CONTACT \(cell.name!.text!.uppercased())  "
        let country = volItem.location?.country ?? ""
        let city = volItem.location?.city ?? ""
        cell.place?.text = country + ", " + city
        cell.hoursLabel.text = "\(volItem.workingHours ?? "") Hours a day"
        cell.daysLabel.text = "\(volItem.workingDays ?? "") Days a week"
        
        cell.volunteerSlogan.text = volItem.title ?? ""
        cell.additionalInfo.text = volItem.description ?? ""
        cell.paymentDescription.text = volItem.paymentDescription ?? ""
        
        cell.imageV?.image = nil
        cell.imageV?.kf.indicatorType = .activity
        cell.imageV?.kf.setImage(with: URL(string: volItem.image ?? ""))
        
        cell.memberPic?.kf.indicatorType = .activity
        cell.memberPic?.kf.setImage(with: URL(string:volItem.member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") ?? ""))
        let lastSeen = "Last seen on \((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
        cell.lastSeen_memberSince.text = lastSeen + ", " + memberSince
        cell.lastSeen.text = "\((volItem.lastLogin ?? "").getDate().getMonth()) \((volItem.lastLogin ?? "").getDate().getDay())"
        cell.year.text = "\((volItem.publishedOn ?? "").getDate().getYear())"
        let languages = volItem.member?.languages?.values
        cell.language.text = languages?.joined(separator: " | ")
        cell.language2.text = languages?.joined(separator: " | ")
        
        cell.personaldesc.text = volItem.member?.personalDescription ?? ""
        cell.status.text = "\(volItem.workingHours ?? "") Hours/day | \(volItem.workingDays ?? "") days/week"
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start! + " - " + item.end!
            schedule = schedule + "\n"
        }
        cell.place!.setUnderLine()
        cell.mealDesc.text = volItem.mealDescription ?? ""
        cell.photosCount.text = ""
        if let img = volItem.images, img.count > 0{
            cell.photosCount.text = " 1/\(img.count)"
            cell.photosCount.isComplete = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var hieght = collectionView.frame.height
        
        if #available(iOS 13.0, *) {
            hieght = self.view.frame.size.height - collectionView.frame.origin.y
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            hieght = hieght - (topPadding ?? 0) - (bottomPadding ?? 0)
        }
        return CGSize(width: self.view.frame.size.width, height: hieght)
        
    }
    
}
extension HostsVC:Menudelegates{
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
            break
        case .volunteers:
            if let vc  = self.navigationController?.viewControllers.first as? LandingVC{
                vc.performSegue(withIdentifier: "vollist", sender: nil)
            }
            
            break
        case .AboutUS:
            break
        }
        
    }
}
