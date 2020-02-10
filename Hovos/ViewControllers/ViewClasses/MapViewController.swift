//
//  MapViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/9/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
class MapViewController: UIViewController,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView:GMSMapView!
    var Hosts = [VolunteerItem]()
    var currentLocation = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.isMyLocationEnabled = true
              mapView.camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10.0)
              
              for item in Hosts{
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
