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
    
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var loaderView:UIView!
    @IBOutlet weak var footerlabel:UILabel!
    @IBOutlet weak var searchText:UILabel!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var favButton:UIButton!
    var object = Volunteer()
    var name = ""
    var indexpath:IndexPath?
    var location:CLLocation!
    let photosDelegate = PhotosCollection()
    weak var VMObject:LandingVM!
    var showMatching = false
    weak var menu_delegate:LandingVC!
    var loadMore:(()->([VolunteerItem]))!
    var copyModal:HostSearchModel!
    var searchModal:HostSearchModel!
    var searchInCountry = ""
    var isAllHost = false
    var type  = ""
    var favAvailable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let modal = copyModal{
            searchModal = modal
            searchHostApi(hostSearchModal: searchModal, completion: { _,_  in })
        }
        menuView.frame = self.view.frame
        if let _ = UserDefaults.standard.value(forKey: constants.accessToken.rawValue){
           // menuView.delegate = (self.navigationController!.viewControllers.first as! TabBarController).children.first as! DashboardVC
        }else{
            menuView.delegate = menu_delegate
        }
        
        if object.hosts?.count == 0 || object.hosts == nil{
            if searchModal == nil {
                getHost()
            }else{
                self.loaderView.isHidden = false
            }
        }else{
            self.loaderView.isHidden = true
        }
    }
    
    private func getHost(){
        self.loaderView.isHidden = false
        VMObject.getAllHosts(completion: { volunteerObj in
            DispatchQueue.main.async {
                self.loaderView.isHidden = true
                self.object = volunteerObj!
                self.collView.reloadData()
                self.loaderView.isHidden = true
            }
        })
    }
    
    
    @IBAction func searchByCountryClicked(_ sender:UIButton){
        searchModal = HostSearchModel()
        let volItem = object.hosts![sender.tag]
        searchModal.cntry = volItem.location!.countryCode
        searchModal.countries = [volItem.location!.country!]
        searchInCountry = volItem.location!.country!
        //searchModal.latlng = "\(volItem.location!.latitude!)|\(volItem.location!.longitude!)"
        self.loaderView?.isHidden = false
        self.object.hosts?.removeAll()
        self.collView.reloadData()
        searchHostApi(hostSearchModal: searchModal) {_,_  in
            
        }
    }
    
    
    
    func searchHostApi(hostSearchModal: HostSearchModel,_ minOffset:Int = 0, _ maxOffset:Int = 12,completion:@escaping ((_ vol:Volunteer?,_ searchModal:HostSearchModel)->())){
        
        if location != nil && hostSearchModal.latlng == ""{
            searchModal.latlng = "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"
        }
        
        hostSearchModal.min_offset = minOffset
        hostSearchModal.max_offset = maxOffset
        if hostSearchModal.min_offset == 0{
            object.hosts?.removeAll()
        }
        let minOffset = hostSearchModal.min_offset
        VMObject.getHostBySearchWithSearchItems(modal: hostSearchModal) { (vol) in
            
            DispatchQueue.main.async {
                if minOffset == 0{
                    self.indexpath = nil
                    self.object.hosts?.removeAll()
                    self.collView.reloadData()
                    completion(vol, hostSearchModal)
                }else{
                    completion(vol, hostSearchModal)
                }
            }
        }
    }
    
    func updateDataAfterSearch(vol:Volunteer?){
        self.searchText.text = ""
        let countriesText = searchModal.countries.joined(separator: ", ")
        
        let continent = (searchModal.continent )
        let date = (searchModal.dt?.replacingOccurrences(of: "|", with: " - "))
        var qs = ""
        if let value = searchModal.qs{
            qs = value
        }
        let jobs = searchModal.jobsArray.joined(separator: ", ")
        
        if qs.last == " "{
            qs.removeLast()
        }
        
        self.loaderView?.isHidden = true
        
        var rangeArray = [NSRange]()
        
        if qs.count > 0{
            rangeArray.append(NSRange(location: 0, length: qs.count))
            self.searchText.text = qs + ", "
        }
        
        if continent.count > 0{
            self.searchText.text =  self.searchText.text! + continent + ", "
        }
        
        if countriesText.count > 0{
            rangeArray.append(NSRange(location: self.searchText.text!.count, length: continent.count +  countriesText.count + 2))
            self.searchText.text =  self.searchText.text! + countriesText + ", "
        }
        
        
        
        if (date?.count ?? 0) > 0{
            rangeArray.append(NSRange(location: self.searchText.text!.count, length: (date?.count ?? 0)))
            self.searchText.text =  self.searchText.text! + (date ?? "") + ", "
        }
        
        if jobs.count > 0{
            rangeArray.append(NSRange(location: self.searchText.text!.count, length: jobs.count))
            self.searchText.text =  self.searchText.text! + jobs
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
        
        self.searchText.text = self.searchText.text?.replacingOccurrences(of: ", , , , ", with: ", ")
        self.searchText.text = self.searchText.text?.replacingOccurrences(of: ", , , ", with: ", ")
        self.searchText.text = self.searchText.text?.replacingOccurrences(of: ", , ", with: ", ")
        
        if self.searchModal.min_offset == 0{
            self.object = vol!
            self.collView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            self.collView.reloadData()
        }else{
            self.object.hosts?.append(contentsOf: (vol?.hosts!)!)
            self.collView.reloadData()
        }
        
        self.searchText.attributedText = getUnderlineString(text: self.searchText.text!, range: rangeArray)
        
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
    
    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
    @IBAction func searchHost(_ sender:UIButton){
        //        indexpath = nil
        //        object.hosts?.removeAll()
        //        collView.reloadData()
        
        let vc = HostSearchVC(nibName: "HostSearchVC", bundle: nil)
        vc.dependency = self
        if searchModal != nil{
            vc.copySearchModel = searchModal
            DispatchQueue.main.async {
                
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favSelected(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.FavHosts(id: object.hosts?[sender.tag].id  ?? "").rawValue
            identifyYourself.header = header
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                print("fav selected \(code)")
                if code == 200{
                    FavoriteData.shared.favoriteHosts.append((self.object.hosts?[sender.tag])!)
                }
                DispatchQueue.main.async {
                    self.collView.reloadData()
                }
                
            }
            
        }else{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.FavHosts(id: object.hosts?[sender.tag].id  ?? "").rawValue
            identifyYourself.header = header
            identifyYourself.method = "DELETE"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                print("fav selected \(code)")
                if code == 200{
                    let newFav = FavoriteData.shared.favoriteHosts.filter { (item) -> Bool in
                        if item.id == (self.object.hosts?[sender.tag].id  ?? ""){
                            return false
                        }else{
                            return true
                        }
                    }
                    FavoriteData.shared.favoriteHosts = newFav
                    DispatchQueue.main.async {
                        self.collView.reloadData()
                    }
                }
            }
            
        }
    }
    
    @IBAction func contactSelected(_ sender:UIButton){
        if let _ = UserDefaults.standard.value(forKey: constants.accessToken.rawValue){
            if SharedUser.manager.auth.user?.isPaid == "Y"{
                let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                vc.user = object.hosts?[footerlabel.tag]
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
            }else{
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
                
            }
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "RegistrationAddVC") as! RegistrationAddVC
            vc.isHost = true
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    
}
extension HostsVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object.hosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "volunteer", for: indexPath) as! listCell
        
        let volItem = object.hosts![indexPath.row]
        cell.imageMain = (volItem.image?.medium ?? "")
        if let img = volItem.member?.image {
            cell.imageData = [img] + (volItem.images ?? [])
        }else{
            cell.imageData =  (volItem.images ?? [])
        }
        cell.dependency = self
        cell.AddGesture()
        if let age = volItem.member?.age{
            cell.name?.text = (volItem.member?.firstName ?? "") + " (\(age))"
        }else{
            cell.name?.text = (volItem.member?.firstName ?? "")
        }
        cell.role = "H"
        cell.nameText = (volItem.member?.firstName ?? "")
        let jobs = volItem.jobs?.values
        cell.countries = Array(jobs!)
        cell.countryHeight.constant = CGFloat((cell.countries.count) * 30)
        cell.countryTable.reloadData()
        cell.jobs.text = Array(jobs!).joined(separator: " | ")
        
        if self.location != nil{
            let distance = self.location.distance(from: CLLocation(latitude: Double(volItem.location?.latitude ?? "")!, longitude: Double(volItem.location?.longitude ?? "")!))
            self.titleLabel.text = "Hosts nearby \(Int(distance/1000)) km"
        }else{
            if searchModal == nil && isAllHost == false{
                if showMatching{
                    self.titleLabel.text = "Recomm. hosts. Matching:\(volItem.totalMatching ?? "") "
                }else{
                    self.titleLabel.text = "New Hosts, signed up \((volItem.addedOn ?? "").getDate().getDay()) \((volItem.addedOn ?? "").getDate().getMonth()) "
                }
            }else{
                self.titleLabel.text = "Hosts, \(indexPath.row + 1 ) of \(object.totalResults ?? 0)"
            }
        }
        
        if searchInCountry != ""{
            self.titleLabel.text = "Hosts in \(searchInCountry), \(indexPath.row + 1 ) of \(object.totalResults ?? 0)"
        }
        
        
        
        footerlabel.text = "  CONTACT \((volItem.member?.firstName ?? "").uppercased())  "
        footerlabel.tag = indexPath.row
        let country = volItem.location?.country ?? ""
        let city = volItem.location?.city ?? ""
        cell.place?.text = country + ", " + city
        cell.hoursLabel.text = "\(volItem.workingHours ?? "") Hours a day"
        cell.daysLabel.text = "\(volItem.workingDays ?? "") Days a week"
        
        cell.volunteerSlogan.text = volItem.title ?? ""
        cell.additionalInfo.text = "we need \(volItem.volunteers ?? "") volunteers \n" + (volItem.description ?? "")
        cell.additionalInfo?.numberOfLines = 4
        cell.additionalInfo?.collapsed = true
        let attributedString = NSMutableAttributedString(string:"read more")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "orangeColor")  , range: NSRange(location: 0, length: attributedString.length))
        cell.additionalInfo?.collapsedAttributedLink = attributedString
        
        cell.paymentDescription.text = volItem.paymentDescription ?? ""
        
        cell.imageV?.image = nil
        cell.imageV?.kf.indicatorType = .activity
        cell.imageV?.kf.setImage(with: URL(string: volItem.image?.medium ?? ""))
        
        
        
        cell.memberPic?.kf.indicatorType = .activity
        cell.memberPic?.kf.setImage(with: URL(string:volItem.member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") ?? ""))
        let lastSeen = "Last seen on \((volItem.member?.lastOnline ?? "").getDate().getMonth()) \((volItem.member?.lastOnline ?? "").getDate().getDay())"
        let memberSince = "member since \((volItem.publishedOn ?? "").getDate().getYear())"
        cell.lastSeen_memberSince.text = lastSeen + ", " + memberSince
        cell.lastSeen.text = "\((volItem.member?.lastOnline ?? "").getDate().getMonth()) \((volItem.member?.lastOnline ?? "").getDate().getDay())"
        cell.year.text = "\((volItem.publishedOn ?? "").getDate().getYear())"
        
        let languages = volItem.member?.languages?.values
        cell.language.text = languages?.joined(separator: " | ")
        cell.language2.text = languages?.joined(separator: " | ")
        
        cell.personaldesc.text = volItem.member?.personalDescription ?? ""
        cell.status.text = "\(volItem.workingHours ?? "") Hours/day | \(volItem.workingDays ?? "") days/week"
        var schedule:String = ""
        for item in volItem.schedules ?? []{
            schedule = schedule + item.start + " - " + item.end
            schedule = schedule + "\n"
        }
        cell.place!.setUnderLine()
        cell.mealDesc.text = volItem.mealDescription ?? ""
        cell.photosCount.text = ""
        favButton.tag = indexPath.row
        
        var isFav:Bool = false
        for item in FavoriteData.shared.favoriteHosts{
            if (item.id ?? "") == (volItem.id ?? ""){
                isFav = true
            }
        }
        favButton.isSelected = isFav
        
        cell.countryButton.tag = indexPath.row
        if let img = volItem.images, img.count > 0{
            cell.photosCount.text = " 1/\(img.count)"
            cell.photosCount.isComplete = true
        }
        cell.aboutMelabel.text = "About me (\(volItem.member?.firstName ?? ""))"
        
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
        
        
        if indexPath.item == object.hosts!.count-1 && favAvailable == false{
            if searchModal == nil{
                
                
                if type == "latest"{
                    LandingVM().getLatestHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                        DispatchQueue.main.async {
                            self.object.hosts!.append(contentsOf: ((items?.hosts!)!))
                            collectionView.reloadData()
                            ViewHelper.shared().hideLoader()
                        }
                    }
                }else if type == "recommended"{
                    LandingVM().getRecommenededHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                    
                            self.object.hosts!.append(contentsOf: ((items?.hosts!)!))
                            collectionView.reloadData()
                            ViewHelper.shared().hideLoader()
                        print("Reloaded")
                    }
                }else{
                    ViewHelper.shared().showLoader(self)
                    if location == nil{
                        LandingVM().getAllHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                            self.object.hosts!.append(contentsOf: ((items?.hosts!)!))
                            collectionView.reloadData()
                            ViewHelper.shared().hideLoader()
                        }
                    }else{
                        let landingVMobject = LandingVM()
                        landingVMobject.location = location
                        landingVMobject.getNearByHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                            DispatchQueue.main.async {
                                self.object.hosts!.append(contentsOf: (items!))
                                collectionView.reloadData()
                                ViewHelper.shared().hideLoader()
                            }
                            
                        }
                    }
                }
            }else{
                ViewHelper.shared().showLoader(self)
                searchHostApi(hostSearchModal: searchModal, searchModal.min_offset+12,searchModal.max_offset+12, completion: {items,_  in
                    DispatchQueue.main.async {
                        self.object.hosts!.append(contentsOf: ((items?.hosts ?? [])))
                        collectionView.reloadData()
                        ViewHelper.shared().hideLoader()
                    }
                })
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
