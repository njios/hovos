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
    
    var object = Volunteer()
    var name = ""
    var indexpath:IndexPath?
    var location:CLLocation!
    
    let photosDelegate = PhotosCollection()
    weak var VMObject:LandingVM!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var loaderView:UIView!
    @IBOutlet weak var footerlabel:UILabel!
    @IBOutlet weak var searchText:UILabel!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var favButton:UIButton!
    var showMatching = false
    weak var menu_delegate:LandingVC!
    var loadMore:(()->([VolunteerItem]))!
    var copyModal:HostSearchModel!
    var searchModal:HostSearchModel!
    var searchInCountry = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let modal = copyModal{
            searchModal = modal
            searchHostApi(completion: { })
        }
        menuView.frame = self.view.frame
       
        menuView.delegate = menu_delegate
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
        VMObject.getAllHosts(completion: { (items) in
            DispatchQueue.main.async {
                self.loaderView.isHidden = true
                self.object.hosts = items!
                self.collView.reloadData()
                self.loaderView.isHidden = true
            }
        })
    }
    
    
    @IBAction func searchByCountryClicked(_ sender:UIButton){
        searchModal = HostSearchModel()
        let volItem = object.hosts![sender.tag]
        searchModal.cntry = volItem.location!.countryCode!
        searchModal.countries = [volItem.location!.country!]
        searchInCountry = volItem.location!.country!
         searchModal.latlng = "\(volItem.location!.latitude!)|\(volItem.location!.longitude!)"
         self.loaderView?.isHidden = false
        searchHostApi {
            
        }
    }
    
    func searchHostApi(_ minOffset:Int = 0, _ maxOffset:Int = 12,completion:@escaping (()->())){
        let countriesText = searchModal.countries.joined(separator: ",")
        searchModal.min_offset = minOffset
        searchModal.max_offset = maxOffset
        let continent = (searchModal.continent )
        let date = (searchModal.dt?.replacingOccurrences(of: "|", with: "-"))
        var qs = ""
        if let value = searchModal.qs{
            qs = value
        }
        let jobs = searchModal.jobsArray.joined(separator: ",")
        if searchModal.min_offset == 0{
            object.hosts?.removeAll()
        }
        if qs.last == " "{
            qs.removeLast()
        }
        if location != nil && searchModal.latlng == ""{
            searchModal.latlng = "\(String(location.coordinate.latitude))|\(String(location.coordinate.longitude))"
        }
        VMObject.getHostBySearchWithSearchItems(modal: searchModal) { (vol) in
            DispatchQueue.main.async {
                self.loaderView?.isHidden = true
                self.searchText.text = qs + ","
                self.searchText.text =  self.searchText.text! + continent + ","
                self.searchText.text =  self.searchText.text! + countriesText + ","
                self.searchText.text =  self.searchText.text! + (date ?? "") + ","
                self.searchText.text =  self.searchText.text! + jobs
                var isContinue = true
                while isContinue {
                    if self.searchText.text?.first == ","{
                        self.searchText.text?.removeFirst()
                    }else if self.searchText.text?.last == ","{
                        self.searchText.text?.removeLast()
                    }else{
                        isContinue = false
                    }
                }
                self.searchText.text = self.searchText.text?.replacingOccurrences(of: ",,,,", with: ",")
                self.searchText.text = self.searchText.text?.replacingOccurrences(of: ",,,", with: ",")
                self.searchText.text = self.searchText.text?.replacingOccurrences(of: ",,", with: ",")
                if self.searchModal.min_offset == 0{
                    self.object = vol!
                }else{
                    self.object.hosts?.append(contentsOf: (vol?.hosts!)!)
                }
                self.collView.reloadData()
                completion()
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
    
    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
    @IBAction func searchHost(_ sender:UIButton){
        let vc = HostSearchVC(nibName: "HostSearchVC", bundle: nil)
        vc.dependency = self
        if searchModal != nil{
            vc.copySearchModel = searchModal
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favSelected(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.FavHosts.rawValue
            identifyYourself.header = header
            identifyYourself.data = ["data":object.hosts?[sender.tag].id ?? ""]
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                print("fav selected \(code)")
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
        cell.imageData = volItem.images ?? []
        cell.dependency = self
        cell.AddGesture()
        cell.name?.text = volItem.member?.firstName ?? ""
        let jobs = volItem.jobs?.values
        cell.countries = Array(jobs!)
        cell.countryHeight.constant = CGFloat((cell.countries.count) * 30)
        cell.countryTable.reloadData()
        
        
        if self.location != nil{
            let distance = self.location.distance(from: CLLocation(latitude: Double(volItem.location?.latitude ?? "")!, longitude: Double(volItem.location?.longitude ?? "")!))
            self.titleLabel.text = "Hosts nearby \(Int(distance/1000)) km"
        }else{
            if searchModal == nil{
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
        
        
        
        footerlabel.text = "  CONTACT \(cell.name!.text!.uppercased())  "
        footerlabel.tag = indexPath.row
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
        cell.imageV?.kf.setImage(with: URL(string: volItem.image?.medium ?? ""))
        
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
        favButton.tag = indexPath.row
        cell.countryButton.tag = indexPath.row
        if let img = volItem.images, img.count > 0{
            cell.photosCount.text = " 1/\(img.count)"
            cell.photosCount.isComplete = true
        }
        
        
        if let payment = volItem.member?.ratings?.payment, payment == "Y"{
            cell.verifiedStatus[0].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[0].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[0].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[0].image = UIImage(named: "startUnselected")
        }
        
        if let phone = volItem.member?.ratings?.phone, phone == "Y"{
            cell.verifiedStatus[1].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[1].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[1].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[1].image = UIImage(named: "startUnselected")
        }
        if let response = volItem.member?.ratings?.response, response == "Y"{
            cell.verifiedStatus[2].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[2].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[2].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[2].image = UIImage(named: "startUnselected")
        }
        if let review = volItem.member?.ratings?.reviews, review == "Y"{
            cell.verifiedStatus[3].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[3].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[3].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[3].image = UIImage(named: "startUnselected")
        }
        if let email = volItem.member?.ratings?.email, email == "Y"{
            cell.verifiedStatus[4].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[4].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[4].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[4].image = UIImage(named: "startUnselected")
        }
        if let passport = volItem.member?.ratings?.passport, passport == "Y"{
            cell.verifiedStatus[5].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[5].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[5].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[5].image = UIImage(named: "startUnselected")
        }
        if let experience = volItem.member?.ratings?.experienced, experience == "Y"{
            cell.verifiedStatus[6].font = UIFont(name: "Lato-bold", size: 15.0)
            cell.startSelection[6].image = UIImage(named: "starSelected")
        }else{
            cell.verifiedStatus[6].font = UIFont(name: "Lato-Regular", size: 15.0)
            cell.startSelection[6].image = UIImage(named: "startUnselected")
        }
        
        
        if indexPath.item == object.hosts!.count-1{
            if searchModal == nil{
                ViewHelper.shared().showLoader(self)
                if LandingVM().location == nil{
                    LandingVM().getAllHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                        self.object.hosts!.append(contentsOf: (items!))
                        collectionView.reloadData()
                        ViewHelper.shared().hideLoader()
                    }
                }else{
                LandingVM().getNearByHosts(object.hosts!.count, object.hosts!.count+12) { (items) in
                    self.object.hosts!.append(contentsOf: (items!))
                    collectionView.reloadData()
                    ViewHelper.shared().hideLoader()
                }
                }
            }else{
                searchHostApi(searchModal.min_offset+12,searchModal.max_offset+12, completion: {})
            }
        }
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
