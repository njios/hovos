//
//  MapViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var hostsNearBy:CustomButtons!
     @IBOutlet weak var loadingHieght:NSLayoutConstraint!
    private var infoWindow = CustomAnnotation()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var location: CLLocation!
    var mapItems:[VolunteerItem]!
    var totalmapItems = [VolunteerItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hostNearBuClicked(_ sender:UIButton){
        let hostVC = storyboard?.instantiateViewController(withIdentifier:  "HostsVC") as! HostsVC
        hostVC.object.hosts =  mapItems
        hostVC.location = location
        if let vc =  getNavigationController(){
            vc.pushViewController(hostVC, animated: false)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapItems.count > 0{
            loadMap()
        }else{
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "www.hovos.com"
            urlComponents.path = ApiEndPoints.hostByLocation.rawValue
            urlComponents.queryItems = [
                URLQueryItem(name: "latlng", value: "\(String(position.target.latitude))|\(String(position.target.longitude))"),
                URLQueryItem(name: "radius", value: String(500)),
                URLQueryItem(name: "min_offset", value: String(0)),
                URLQueryItem(name: "min_offset", value: String(0))
            ]
            let url =  URL(string: (urlComponents.url?.absoluteString)!)
            loadingHieght.constant = 20
            getApiCall(url: url! ) { (data, status, code) in
                if code == 200{
                    DispatchQueue.main.async {
                        self.loadingHieght.constant = 0
                        let decoder =  JSONDecoder()
                        if let Volunteer = try? decoder.decode(Volunteer.self, from: data!){
                         
                            if let mapItems = Volunteer.hosts{
                                  self.mapView.clear()
                                self.totalmapItems.append(contentsOf: mapItems)
                                self.totalmapItems = self.removeDuplicateElements(post: self.totalmapItems)
                                
                                let locationMarker = customMarker()
                                locationMarker.position = CLLocationCoordinate2D(latitude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude)
                                let markerImage = UIImage.init(named: "greenLocation")
                                let markerView = UIImageView(image: markerImage)
                                    locationMarker.iconView = markerView
                                    locationMarker.map = self.mapView
                                    locationMarker.isTappable = false
                                
                                for i in 0..<self.totalmapItems.count{
                                    let lattitude = Double((self.totalmapItems[i].location?.latitude)!)!
                                    let longitude = Double((self.totalmapItems[i].location?.longitude)!)!
                                    let marker = customMarker()
                                    marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                                    marker.title = self.totalmapItems[i].member?.firstName
                                    marker.snippet = self.totalmapItems[i].currentLocation
                                    let markerImage = UIImage.init(named: "mappin")
                                    let markerView = UIImageView(image: markerImage)
                                    marker.index = i
                                    marker.iconView = markerView
                                    marker.info = self.totalmapItems[i]
                                    marker.map = self.mapView
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadMap(){
        totalmapItems.append(contentsOf: mapItems)
        if let location = location{
            
            //self.mapView.isMyLocationEnabled = true
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
            
            let marker = customMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let markerImage = UIImage.init(named: "greenLocation")
            let markerView = UIImageView(image: markerImage)
            
            marker.iconView = markerView
            marker.map = self.mapView
            marker.isTappable = false
            
            for i in 0..<mapItems.count{
                let lattitude = Double((mapItems[i].location?.latitude)!)!
                let longitude = Double((mapItems[i].location?.longitude)!)!
                
                let marker = customMarker()
                marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                marker.title = mapItems[i].member?.firstName
                marker.snippet = mapItems[i].currentLocation
                
                let markerImage = UIImage.init(named: "mappin")
                let markerView = UIImageView(image: markerImage)
                marker.index = i
                marker.iconView = markerView
                marker.info = mapItems[i]
                marker.map = self.mapView
            }
            mapItems.removeAll()
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = CustomAnnotation.instanceFromNib() as! CustomAnnotation
        if let custom = marker as? customMarker{
            infoWindow.name.text = custom.info.member?.firstName ?? ""
            let lastSeen = "Last seen on \((custom.info.lastLogin ?? "").getDate().getMonth()) \((custom.info.lastLogin ?? "").getDate().getDay())"
            infoWindow.lstseen.text = lastSeen
            let jobs = custom.info.jobs?.values
            infoWindow.jobs.text = jobs?.joined(separator: " | ")
            infoWindow.img.kf.indicatorType = .activity
            infoWindow.img.kf.setImage(with: URL(string:custom.info.member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") ?? ""))
        }
        infoWindow.center = mapView.projection.point(for: marker.position)
        infoWindow.center.y =  infoWindow.center.y + 100
        return infoWindow
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let cMarker = marker as? customMarker{
            let hostVC = storyboard?.instantiateViewController(withIdentifier:  "HostsVC") as! HostsVC
            hostVC.indexpath =  IndexPath(row: cMarker.index, section: 0)
            hostVC.object.hosts =  totalmapItems
            hostVC.location = location
            if let vc =  getNavigationController(){
                vc.pushViewController(hostVC, animated: false)
            }
        }
    }
    func removeDuplicateElements(post: [VolunteerItem]) -> [VolunteerItem] {
        var uniquePosts = [VolunteerItem]()
        
        for item in post {
            if !uniquePosts.contains(where: {$0.id == item.id }) {
                uniquePosts.append(item)
            }
        }
        return uniquePosts
    }
}


