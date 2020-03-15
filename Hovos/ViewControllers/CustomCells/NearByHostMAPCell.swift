//
//  NearByHostMAPCell.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/23/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
class NearByHostMAPCell: UITableViewCell,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView:GMSMapView!
    weak var VMObject:LandingVM!
    var locManager = CLLocationManager()
    private var infoWindow = CustomAnnotation()
    weak var vc :LandingVC!
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func loadMap(dependency:LandingVC){
        self.vc = dependency
        
        if let location = locManager.location{
            VMObject.location = location
            VMObject.getNearByHosts( completion: { Hosts in
                DispatchQueue.main.async {
                    //self.mapView.isMyLocationEnabled = true
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
                    
                    let marker = customMarker()
                    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let markerImage = UIImage.init(named: "greenLocation")
                    let markerView = UIImageView(image: markerImage)
                 
                    marker.iconView = markerView
                    marker.map = self.mapView
                    marker.isTappable = false
                    for item in Hosts!{
                        let lattitude = Double((item.location?.latitude)!)!
                        let longitude = Double((item.location?.longitude)!)!
                        
                        let marker = customMarker()
                        marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                        marker.title = item.member?.firstName
                        marker.snippet = item.currentLocation
                        
                        let markerImage = UIImage.init(named: "mappin")
                        let markerView = UIImageView(image: markerImage)
                        
                        marker.iconView = markerView
                        marker.info = item
                        marker.map = self.mapView
                        
                        
                    }
                    
                    
                }
                
                
            }
            )
        }else{
            locManager.delegate = self
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if VMObject.Hosts != nil{
            let mapvc = MapViewController(nibName: "MapViewController", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            mapvc.currentLocation = locManager.location!
            mapvc.Hosts = VMObject.Hosts
            vc.present(mapvc, animated: true, completion: nil)
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
    
}



extension NearByHostMAPCell:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        VMObject.location = manager.location
        loadMap(dependency: self.vc)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

class CustomAnnotation:UIView{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var lstseen:UILabel!
    @IBOutlet weak var jobs:UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomAnnotation", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}

class customMarker:GMSMarker{
    var info = VolunteerItem()
}
