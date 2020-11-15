//
//  DashboardVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/23/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import GoogleMaps
import GoogleMapsUtils
import CoreLocation
class DashboardVC: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var recommended:UICollectionView!
    @IBOutlet weak var latest:UICollectionView!
    @IBOutlet weak var menuView:MenuVC!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var RecommendedLabel:CustomLabels!
    @IBOutlet weak var NewLabel:CustomLabels!
    @IBOutlet weak var forwardAngle1:UIImageView!
    @IBOutlet weak var forwardAngle2:UIImageView!
    @IBOutlet weak var nearByLabel:UILabel!
    
    @IBOutlet weak var membershipHightConstraints:NSLayoutConstraint!
    var recommendedDelegates = RecommendedVolunteers()
    var latestDelegates = NewHosts()
    var VMObject = DashBoardVM()
    var landingVMObject = LandingVM()
    var delegate:ListViewDelegate!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        menuView.frame = self.view.frame
       
        locationManager.delegate = self
       
        if locationManager.location != nil {
            ViewHelper.shared().showLoader(self)
            VMObject.getLocation(location:locationManager.location! ,completion: updateUI(status:))
        }else{
             locationManager.startUpdatingLocation()
        }
        
        if SharedUser.manager.auth.listing?.isPaid != nil{
            membershipHightConstraints.constant = 0
        }
        
        
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
             nearByLabel.text = "Nearby Hosts"
            RecommendedLabel.text = "Recommended Hosts"
            NewLabel.text = "New Hosts"
            nearByLabel.textColor = UIColor(named: "orangeColor")
            RecommendedLabel.textColor = UIColor(named: "orangeColor")
            NewLabel.textColor = UIColor(named: "orangeColor")
            forwardAngle1.image = UIImage(named: "orangeAngle")
            forwardAngle2.image = UIImage(named: "orangeAngle")
            
        }else{
            nearByLabel.text = "Nearby volunteers"
            RecommendedLabel.text = "Recommended volunteers"
            NewLabel.text = "New volunteers"
            membershipHightConstraints.constant = 0
            forwardAngle1.image = UIImage(named: "blueAngle")
            forwardAngle2.image = UIImage(named: "blueAngle")
            RecommendedLabel.textColor = UIColor(named: "greenColor")
            NewLabel.textColor = UIColor(named: "greenColor")
            nearByLabel.textColor = UIColor(named: "greenColor")
            
        }
        
        NewLabel.isComplete = true
        RecommendedLabel.isComplete = true
        mapView.delegate = self
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = false
        
        
    }
    

    private func updateUI(status:Int){
        ViewHelper.shared().hideLoader()
        recommendedDelegates.modalObject = VMObject.recommendedItems
        latestDelegates.modalObject = VMObject.latestItems
        
        recommended.delegate = recommendedDelegates
        recommended.dataSource = recommendedDelegates
        recommendedDelegates.delegate = self
        recommended.reloadData()
        
        latest.delegate = latestDelegates
        latest.dataSource = latestDelegates
        latestDelegates.delegate = self
        latest.reloadData()
        
        loadMap()
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
        landingVMObject.Hosts = VMObject.mapItems.hosts
        }else{
        landingVMObject.Hosts = VMObject.mapItems.travellers
        }
        landingVMObject.location = VMObject.location
        
        
    }
    @IBAction func loadMenu(_ sender:UIButton){
        self.view.addSubview(menuView)
    }
    
    @IBAction func recommededAction(_ sender:UIButton){
        let indexPath = IndexPath(item: 0, section: 0)
        delegate.collViewUpdateWithObject(index: indexPath, object: VMObject.recommendedItems, type: "Recom")
    }
    
    @IBAction func newAction(_ sender:UIButton){
        let indexPath = IndexPath(item: 0, section: 0)
        delegate.collViewUpdateWithObject(index: indexPath, object: VMObject.latestItems, type: "New")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((SharedUser.manager.auth.user?.listingId) == nil) || ((SharedUser.manager.auth.listing?.isPublished ?? "n").lowercased() == "n") {
            let stb = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "ProfileIncompleteVC") as! ProfileIncompleteVC
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    private func loadMap(){
        
        DispatchQueue.main.async {
            
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: (self.VMObject.location.coordinate.latitude), longitude: (self.VMObject.location.coordinate.longitude), zoom: 10.0)
            
            let marker = customMarker()
            marker.position = CLLocationCoordinate2D(latitude: (self.VMObject.location.coordinate.latitude), longitude: (self.VMObject.location.coordinate.longitude))
            
            var markerImage:UIImage!
            if SharedUser.manager.auth.user?.role?.lowercased() == "v"{
                markerImage = UIImage.init(named: "greenLocation")
            }else{
                markerImage = UIImage.init(named: "locationRed")
            }
            
            
            let markerView = UIImageView(image: markerImage)
            
            marker.iconView = markerView
            marker.map = self.mapView
            marker.isTappable = false
            
            var mapItems:[VolunteerItem]
            
            if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
                mapItems = self.VMObject.mapItems.hosts ?? []
            }else{
                mapItems = self.VMObject.mapItems.travellers ?? []
            }
            
            for i in 0 ..< mapItems.count{
                let lattitude = Double((mapItems[i].location?.latitude)!)!
                let longitude = Double((mapItems[i].location?.longitude)!)!
                
                let marker = customMarker()
                
                marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                marker.title = mapItems[i].member?.firstName
                marker.snippet = mapItems[i].currentLocation
                
                if let imageString = mapItems[i].member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") {
                    if let url = URL(string: imageString){
                    marker.applyImage(url: url)
                }
                }
            
                
                var markerImage:UIImage!
                if SharedUser.manager.auth.user?.role?.lowercased() == "v"{
                    markerImage = UIImage.init(named: "mappin")
                }else{
                    markerImage = UIImage.init(named: "mappin")
                }
                let markerView = UIImageView(image: markerImage)
                marker.index = i
                marker.iconView = markerView
                marker.info = mapItems[i]
                marker.map = self.mapView
            }
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVc.location = VMObject.location
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
               mapVc.mapItems = VMObject.mapItems.hosts
               }else{
               mapVc.mapItems = VMObject.mapItems.travellers
               }
        
        self.navigationController?.pushViewController(mapVc, animated: true)
        
        
    }
    
    @IBAction func openMap(_ sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVc.location = VMObject.location
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
        mapVc.mapItems = VMObject.mapItems.hosts
        }else{
        mapVc.mapItems = VMObject.mapItems.travellers
        }
        
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = CustomAnnotation.instanceFromNib() as! CustomAnnotation
        if let custom = marker as? customMarker{
            infoWindow.name.text = custom.info.member?.firstName ?? ""
            let lastSeen = "Last seen on \((custom.info.member?.lastOnline ?? "").getDate().getMonth()) \((custom.info.member?.lastOnline ?? "").getDate().getDay())"
            infoWindow.lstseen.text = lastSeen
            let jobs = custom.info.jobs?.values
            infoWindow.jobs.text = jobs?.joined(separator: " | ")
            infoWindow.img.image = custom.image
        }
       
        return infoWindow
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let cMarker = marker as? customMarker{
            delegate.collViewUpdateWithObject(index: IndexPath(row: cMarker.index, section: 0), object: VMObject.mapItems, type: "nearBy")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        mapView.animate(toLocation: marker.position)
        mapView.selectedMarker = marker

        var point = mapView.projection.point(for: marker.position)
        point.y = point.y - 120

        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)

        return true

    }

    
}
extension DashboardVC:Menudelegates{
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
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case .volunteers:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "VolunteerVC") as! VolunteerVC
            
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
        
    }
}

extension DashboardVC:ListViewDelegate{
    
    func collViewdidUpdate(index: IndexPath) {
        
    
    }
}
extension DashboardVC:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.location != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                   ViewHelper.shared().showLoader(self)
                self.VMObject.getLocation(location:locations[0] ,completion: self.updateUI(status:))
            }
            manager.stopUpdatingLocation()
        }
    }
}
