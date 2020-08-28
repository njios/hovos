//
//  VolunteerVCViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/4/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import ExpandableLabel
enum typeOfVolunteer{
    case neraby
    case recommended
    case latest
    case all
}
class VolunteerVC: UIViewController {
    
    var object:Volunteer? = Volunteer()
    var name = ""
    var indexpath:IndexPath?
    let photosDelegate = PhotosCollection()
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var searchText:UILabel!
    @IBOutlet weak var footerlabel:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var favButton:UIButton!
    @IBOutlet weak var searchButton:UIButton!
    weak var menu_delegate:LandingVC!
    var location:CLLocation!
    var type:typeOfVolunteer = .all
    var searchInCountry = ""
    var newSearchModal:VolunteerSearchModel!
    let vc = VolunteerSearchVC( nibName: "VolunteerSearchVC", bundle: nil)
    var volSearchModal:VolunteerSearchModel!{
        didSet{
            searchText.text = ""
            indexpath = nil
            object?.travellers?.removeAll()
            collView.reloadData()
            newSearchModal = volSearchModal
            let countriesText = volSearchModal.countries.joined(separator: ", ")
            let continent = (volSearchModal.continent )
            let date = (volSearchModal.dt?.replacingOccurrences(of: "|", with: " - "))
            let skills = volSearchModal.skillsArray.joined(separator: ", ")
            let languaes = volSearchModal.languagesArray.joined(separator: "|")
            var qs = ""
            if let value = volSearchModal.qs{
                qs = value
            }
            let jobs = volSearchModal.skillsArray.joined(separator: ", ")
            var rangeArray = [NSRange]()
            if qs.last == " "{
                qs.removeLast()
            }
            
            if qs.count > 0{
                rangeArray.append(NSRange(location: 0, length: qs.count))
                searchText.text = qs + ","
            }
            
            if countriesText.count > 0 {
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: continent.count+countriesText.count + 2))
                searchText.text =  searchText.text! + continent + ", "
                searchText.text =  searchText.text! + countriesText + ", "
            }
            
            if (date ?? "").count > 0 {
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: (date ?? "").count))
                searchText.text =  searchText.text! + (date ?? "") + ", "
            }
            
            if volSearchModal.age.count > 0 {
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: volSearchModal.age.count+4))
                searchText.text =  searchText.text! + "Age:"  + volSearchModal.age + ", "
            }
            
            
            if volSearchModal.isCompanion == "Y"{
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: "travel partners only".count))
                searchText.text =  searchText.text! + "travel partners only"
            }
            
            if skills.count > 0{
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: skills.count))
                searchText.text =  searchText.text! + skills + ", "
            }
            
            if languaes.count > 0{
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: languaes.count))
                searchText.text =  searchText.text! + languaes + ", "
            }
            
            if let gender = volSearchModal.gender{
                rangeArray.append(NSRange(location: self.searchText.text!.count, length: (gender == "F" ? 5 : 4)))
                searchText.text = searchText.text! + (gender == "F" ? "Female" : "Male") + ", "
            }
            
            var isContinue = true
            while isContinue {
                if self.searchText.text?.first == "," || self.searchText.text?.first == " "{
                    self.searchText.text?.removeFirst()
                }else if self.searchText.text?.last == "," || self.searchText.text?.last == " "{
                    self.searchText.text?.removeLast()
                }else{
                    isContinue = false
                }
            }
            
            searchText.text = self.searchText.text?.replacingOccurrences(of: ", , , ,", with: ", ")
            searchText.text = self.searchText.text?.replacingOccurrences(of: ", , ,", with: ", ")
            searchText.text = self.searchText.text?.replacingOccurrences(of: ", ,", with: ", ")
            
            self.searchText.attributedText = getUnderlineString(text: self.searchText.text!, range: rangeArray)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        if let _ = UserDefaults.standard.value(forKey: constants.accessToken.rawValue){
            menuView.delegate = (self.navigationController!.viewControllers.first as! TabBarController).children.first as! DashboardVC
        }else{
            menuView.delegate = menu_delegate
        }
        location = CLLocationManager().location
        if type == .recommended{
            searchButton.isHidden = true
        }
        
        if  object?.travellers == nil {
            ViewHelper.shared().showLoader(self)
            LandingVM().getVolunteerList() { (items) in
                self.object = items
                self.collView.reloadData()
                ViewHelper.shared().hideLoader()
            }
        }
    }
    
    @IBAction func searchByCountryClicked(_ sender:UIButton){
        var SearchModal = VolunteerSearchModel()
        let vmobject = VolunteerSearchVM(dependency: vc)
        let volItem = object?.travellers![sender.tag]
        SearchModal.cntry = (volItem?.location!.countryCode)!
        SearchModal.countries = [(volItem?.location!.country)!]
        searchInCountry = (volItem?.location!.country)!
        // SearchModal.latlng = "\(volItem?.location!.latitude! ?? "")|\(volItem?.location!.longitude! ?? "")"
        
        self.object?.travellers?.removeAll()
        self.collView.reloadData()
        ViewHelper.shared().showLoader(self)
        vmobject.searchVolunteer(object: SearchModal) { (Volunteer) in
            ViewHelper.shared().hideLoader()
            DispatchQueue.main.async {
                
                self.object = Volunteer
                self.collView.reloadData()
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.indexpath{
            ViewHelper.shared().showLoader(self)
            self.collView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.collView.scrollToItem(at: index, at: .left, animated: false)
                ViewHelper.shared().hideLoader()
                self.indexpath = nil
            }
        }
    }
    
    @IBAction func favSelected(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.FavVolunteer.rawValue
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                print("fav selected \(code)")
            }
        }
    }
    
    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
    
    @IBAction func searchClicked(_ sender:UIButton){
        
        vc.startSearch = { Modal,SearchModal in
            self.volSearchModal = SearchModal
            DispatchQueue.main.async {
                self.object = Modal
                self.collView.reloadData()
            }
        }
        if volSearchModal != nil {
            vc.copySearchModel = volSearchModal
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactSelected(_ sender:UIButton){
        if let _ = UserDefaults.standard.value(forKey: constants.accessToken.rawValue){
            let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
            vc.user = object?.travellers![footerlabel.tag]
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "RegistrationAddVC") as! RegistrationAddVC
            vc.isHost = false
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
        
    }
}

extension VolunteerVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object?.travellers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "volunteer", for: indexPath) as! listCell
        let volItem = object!.travellers![indexPath.row]
        cell.imageMain = (volItem.image?.medium ?? "")
        
        if let img = volItem.member?.image {
            cell.imageData = [img] + (volItem.images ?? [])
        }else{
            cell.imageData =  (volItem.images ?? [])
        }
        cell.dependency = self
        cell.role = "V"
        cell.nameText = (volItem.name ?? "")
        cell.AddGesture()
        cell.additionalInfo?.collapsed = true
        if let age = volItem.member?.age{
            cell.name?.text = (volItem.name ?? "") + " (\(age))"
        }else{
            cell.name?.text = (volItem.name ?? "")
        }
        
        cell.countries = Array(volItem.countries!.values) as! [String]
        cell.countryTable.reloadData()
        cell.countryHeight.constant = CGFloat((volItem.countries?.count ?? 0) * 30)
        
        switch type {
        case .all:
            titleLabel.text = "Volunteers, \(indexPath.row + 1) of \(object?.totalResults ?? 0)"
        case .latest:
            titleLabel.text = "New volunteers, signed up: \((volItem.publishedOn ?? "").getDate().getMonth()) \((volItem.publishedOn ?? "").getDate().getDay())"
        case .neraby:
            if location != nil{
                let distance = self.location.distance(from: CLLocation(latitude: Double(volItem.location?.longitude ?? "")!, longitude: Double(volItem.location?.latitude ?? "")!))
                self.titleLabel.text = "Volunteers neerby, \(Int(distance/1000)) km"
            }
        case .recommended:
            titleLabel.text = "Recomm. volunteers, matching : \(volItem.totalMatching ?? "")"
        }
        
        if searchInCountry != ""{
            self.titleLabel.text = "Volunteers in \(searchInCountry), \(indexPath.row + 1 ) of \(object?.totalResults ?? 0)"
        }
        
        if volSearchModal != nil{
            
        }
        
        
        
        footerlabel.tag = indexPath.row
        footerlabel.text = "  CONTACT \((volItem.name ?? "").uppercased())  "
        let country = volItem.location?.country ?? ""
        let city = volItem.location?.city ?? ""
        cell.place?.text = country + ", " + city
        cell.volunteerSlogan.text = (volItem.slogan ?? "") == "" ? "" : "\"\((volItem.slogan ?? ""))\""
        cell.skills.text = volItem.skillDescription ?? ""
        let personalDesc = volItem.member?.personalDescription ?? ""
        let languageDesc = volItem.languageDesc ?? ""
        
        cell.additionalInfo.text = ""
        
        cell.additionalInfo.text = personalDesc + "\n" + languageDesc + "\n" + (volItem.additionalDesc ?? "")
        
        
        cell.additionalInfo?.numberOfLines = 4
        cell.additionalInfo?.collapsed = true
        let attributedString = NSMutableAttributedString(string:"read more")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "greenColor")  , range: NSRange(location: 0, length: attributedString.length))
        cell.additionalInfo?.collapsedAttributedLink = attributedString
        
        
        
        cell.placeDescription.text = volItem.placeDescription ?? ""
        cell.imageV?.image = nil
        cell.imageV?.kf.indicatorType = .activity
        cell.imageV?.kf.setImage(with: URL(string: volItem.image?.medium ?? ""))
        let lastSeen = "Last seen on \((volItem.member?.lastOnline ?? "").getDate().getMonth()) \((volItem.member?.lastOnline ?? "").getDate().getDay())"
        let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
        cell.countryButton.tag = indexPath.row
        cell.lastSeen_memberSince.text = lastSeen + ", " + memberSince
        
        cell.location.text = (volItem.location?.country ?? "") + ", Last seen on " + "\((volItem.member?.lastOnline ?? "").getDate().getMonth()) \((volItem.member?.lastOnline ?? "").getDate().getDay())"
        let languages = volItem.member?.languages?.values
        
        cell.language.text = languages?.joined(separator: " | ")
        cell.status.text = "I am open for meeting travelers"
        let jobs = volItem.jobs?.values
        cell.jobs.text = jobs?.joined(separator: " | ")
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start + " - " + item.end
            schedule = schedule + "\n"
        }
        cell.schedule.text = schedule == "" ? "Open for offers" : schedule
        
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
        photosDelegate.objects = volItem.images
        photosDelegate.dependency = self
        photosDelegate.name = (volItem.name ?? "")
        cell.photosCollview.delegate = photosDelegate
        cell.photosCollview.dataSource = photosDelegate
        cell.photosCollview.reloadData()
        cell.place?.setUnderLine()
        cell.photosCount.text = ""
        favButton.tag = indexPath.row
        if let img = volItem.images, img.count > 0{
            cell.photosCount.text = " 1/\(img.count)"
            cell.photosCount.isComplete = true
        }
        
        if let payment = volItem.member?.rating?.payment, payment == "Y"{
            cell.verifiedStatus[0].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[0].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[0].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[0].image = UIImage(named: "startUnselected")
        }
        
        if let phone = volItem.member?.rating?.phone, phone == "Y"{
            cell.verifiedStatus[1].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[1].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[1].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[1].image = UIImage(named: "startUnselected")
        }
        if let response = volItem.member?.rating?.response, response == "Y"{
            cell.verifiedStatus[2].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[2].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[2].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[2].image = UIImage(named: "startUnselected")
        }
        if let review = volItem.member?.rating?.reviews, review == "Y"{
            cell.verifiedStatus[3].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[3].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[3].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[3].image = UIImage(named: "startUnselected")
        }
        if let email = volItem.member?.rating?.email, email == "Y"{
            cell.verifiedStatus[4].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[4].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[4].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[4].image = UIImage(named: "startUnselected")
        }
        if let passport = volItem.member?.rating?.passport, passport == "Y"{
            cell.verifiedStatus[5].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[5].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[5].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[5].image = UIImage(named: "startUnselected")
        }
        if let experience = volItem.member?.rating?.experienced, experience == "Y"{
            cell.verifiedStatus[6].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[6].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[6].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[6].image = UIImage(named: "startUnselected")
        }
        
        if indexPath.item == object!.travellers!.count-1{
            if volSearchModal == nil{
            
            LandingVM().getVolunteerList(object!.travellers!.count, object!.travellers!.count+12) { (items) in
                ViewHelper.shared().showLoader(self)
                   DispatchQueue.main.async {
                self.object?.travellers?.append(contentsOf: (items?.travellers)!)
                collectionView.reloadData()
        
                ViewHelper.shared().hideLoader()
                }
            }
            }else{
                if ((self.object?.totalResults) ?? 0)-1 > indexPath.row{
                ViewHelper.shared().showLoader(self)
                 
                    
                newSearchModal.min_offset = newSearchModal.min_offset + 12
                newSearchModal.max_offset = newSearchModal.max_offset + 12
                    
                vc.vmObject.searchVolunteer(object: newSearchModal) { (volunteer) in
                    DispatchQueue.main.async {
                        self.object?.travellers?.append(contentsOf: (volunteer?.travellers)!)
                                collectionView.reloadData()
                                 ViewHelper.shared().hideLoader()
                    }
                    }
               }
            }
        }
        
        
        cell.reviews = volItem.reviews ?? []
        cell.liked?.setTitle("\(volItem.likes ?? "0")", for: .normal)
        cell.disliked?.setTitle("\(volItem.dislikes ?? "0")", for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var hieght = collectionView.frame.height
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.keyWindow
            if (window?.safeAreaInsets.bottom ?? 0.0) > 0.0{
                hieght = self.view.frame.size.height - collectionView.frame.origin.y
                
                let topPadding = window?.safeAreaInsets.top
                let bottomPadding = window?.safeAreaInsets.bottom
                hieght = hieght - (topPadding ?? 0) - (bottomPadding ?? 0)
            }
        }
        return CGSize(width: self.view.frame.size.width, height: hieght)
        
    }
    
}


class PhotosCollection:NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var objects:[images]?
    weak var dependency:UIViewController!
    var name:String!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (objects?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
            cell.imageV?.kf.indicatorType = .activity
            cell.imageV?.kf.setImage(with: URL(string:( objects?[indexPath.row - 1].medium)?.replacingOccurrences(of: "large", with: "small").replacingOccurrences(of: "medium", with: "small") ?? ""))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }else{
            return CGSize(width: (collectionView.frame.size.width/3 - 5), height: (collectionView.frame.size.width/3) - 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GalleryVC(nibName: "GalleryVC", bundle: nil)
        vc.role = "V"
        vc.imageData = objects!
        vc.name = name
        vc.modalPresentationStyle = .fullScreen
        dependency?.present(vc, animated: true, completion: nil)
    }
    
}
