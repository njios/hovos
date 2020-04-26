//
//  EditProfile_locationVVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
class EditProfile_locationVVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView:GMSMapView!
     @IBOutlet weak var searchView:UIView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       if locationManager.location != nil {
        updateMap()
        }else{
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
    }
    func updateMap(){
       
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 10.0)
           
           let marker = customMarker()
           marker.position = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
           let markerImage = UIImage.init(named: "locationRed")
           let markerView = UIImageView(image: markerImage)
        
           marker.iconView = markerView
           marker.map =  self.mapView
           
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        updateMap()
    }
    
}
