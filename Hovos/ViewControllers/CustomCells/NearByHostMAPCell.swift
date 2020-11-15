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
import GoogleMapsUtils
class NearByHostMAPCell: UITableViewCell,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView:GMSMapView!
    weak var VMObject:LandingVM!
    var locManager = CLLocationManager()
    private var infoWindow = CustomAnnotation()
    weak var vc :LandingVC!
         var mapResponsibleDelegate:MapViewResponsable!
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
                    
                    for i in 0..<Hosts!.count{
                        let lattitude = Double((Hosts![i].location?.latitude)!)!
                        let longitude = Double((Hosts![i].location?.longitude)!)!
                                           
                                           let marker = customMarker()
                                           marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                        marker.title = Hosts![i].member?.firstName
                        marker.snippet = Hosts![i].currentLocation
                        if let imageString = Hosts![i].member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") {
                            if let url = URL(string: imageString){
                            marker.applyImage(url: url)
                        }
                        }
                            let markerImage = UIImage.init(named: "mappin")
                                           let markerView = UIImageView(image: markerImage)
                                           marker.index = i
                                           marker.iconView = markerView
                                           marker.info = Hosts![i]
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
            mapResponsibleDelegate.mapViewClicked(loc: locManager.location!)
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
       
        let infoWindow = CustomAnnotation.instanceFromNib() as! CustomAnnotation
        if let custom = marker as? customMarker{
            infoWindow.name.text = custom.info.member?.firstName ?? ""
            let lastSeen = "Last seen on \((custom.info.member?.lastOnline  ?? "").getDate().getMonth()) \((custom.info.member?.lastOnline ?? "").getDate().getDay())"
            infoWindow.lstseen.text = lastSeen
            let jobs = custom.info.jobs?.values
            infoWindow.jobs.text = jobs?.joined(separator: " | ")
            infoWindow.img.image = custom.image
           
        }
        return infoWindow
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let cMarker = marker as? customMarker{
            let hostVC = vc.storyboard?.instantiateViewController(withIdentifier:  "HostsVC") as! HostsVC
            hostVC.indexpath =  IndexPath(row: cMarker.index, section: 0)
            hostVC.object.hosts = VMObject.Hosts
            hostVC.location = VMObject.location
            if let vc =  getNavigationController(){
                   vc.pushViewController(hostVC, animated: false)
            }
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
    var index = -1
    var image:UIImage!
 
    
    func applyImage(url: URL) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
                else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
