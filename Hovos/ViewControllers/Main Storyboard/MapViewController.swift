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
    private var infoWindow = CustomAnnotation()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var location: CLLocation!
    var mapItems:[VolunteerItem]!
    var isOrange = false
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        loadMap()
        if isOrange{
        
            headerView.backgroundColor = UIColor(named: "orangeColor")
        }else{
            headerView.backgroundColor = UIColor(named: "greenColor")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hostNearBuClicked(_ sender:UIButton){
        let hostVC = storyboard?.instantiateViewController(withIdentifier:  "HostsVC") as! HostsVC
        hostVC.object =  mapItems
        hostVC.location = location
        if let vc =  getNavigationController(){
               vc.pushViewController(hostVC, animated: false)
        }
    }
    
    func loadMap(){
      
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
            hostVC.object =  mapItems
            hostVC.location = location
            if let vc =  getNavigationController(){
                   vc.pushViewController(hostVC, animated: false)
            }
        }
    }
}
