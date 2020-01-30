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
class NearByHostMAPCell: UITableViewCell {
    
    @IBOutlet weak var mapView:GMSMapView!
    weak var VMObject:LandingVM!
    var locManager = CLLocationManager()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func loadMap(){
        
        
        if let location = locManager.location{
            
            VMObject.getNearByHosts(location: location, completion: { Hosts in
                DispatchQueue.main.async {
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
                                     
                                  for item in Hosts!{
                                      let lattitude = Double((item.location?.latitude)!)!
                                      let longitude = Double((item.location?.longitude)!)!
                                      let marker = CustomAnnotation()
                                      marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                                      marker.title = item.member?.firstName
                                      marker.snippet = item.currentLocation
                                      
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
    
}



extension NearByHostMAPCell:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        loadMap()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

class CustomAnnotation:GMSMarker{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var lstseen:UILabel!
    @IBOutlet weak var jobs:UILabel!
}
