//
//  NearByHostMAPCell.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/23/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import MapKit
class NearByHostMAPCell: UITableViewCell {
    
    @IBOutlet weak var mapView:UIView!
    weak var VMObject:LandingVM!
    var locManager = CLLocationManager()
    var Hosts:[VolunteerItem]!
    var map:MKMapView! = MKMapView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        map.frame = mapView.frame
        map.isScrollEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func loadMap(){
        
        map.delegate = self
        if let location = locManager.location{
            map.showsUserLocation = true
            VMObject.getNearByHosts(location: location, completion: { Hosts in
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 50000)!, longitudinalMeters: CLLocationDistance(exactly: 50000)!)
                self.map.setRegion(self.map.regionThatFits(region), animated: true)
                var annotations = [MKAnnotation]()
                for item in Hosts!{
                    let point =  MKPointAnnotation()
                    let lattitude = Double((item.location?.latitude)!)!
                    let longitude = Double((item.location?.longitude)!)!
                    point.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                    point.title = item.member?.firstName
                    annotations.append(point)
                }
                
                DispatchQueue.main.async {
                      self.mapView.addSubview(self.map)
                    self.map.addAnnotations(annotations)
                  
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
extension NearByHostMAPCell:MKMapViewDelegate{
    
}


extension NearByHostMAPCell:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        loadMap()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

class CustomAnnotation:MKAnnotationView{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var lstseen:UILabel!
    @IBOutlet weak var jobs:UILabel!
}
