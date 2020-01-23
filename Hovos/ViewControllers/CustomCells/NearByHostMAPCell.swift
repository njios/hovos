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

    @IBOutlet weak var mapView:MKMapView!
    weak var VMObject:LandingVM!
    var locManager = CLLocationManager()
    var Hosts:[VolunteerItem]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
        if let location = locManager.location{
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 50000)!, longitudinalMeters: CLLocationDistance(exactly: 50000)!)
               mapView.setRegion(mapView.regionThatFits(region), animated: true)
          loadMap()
        }else{
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    
     func loadMap(){
                if let location = locManager.location{
            VMObject.getNearByHosts(location: location, completion: { Hosts in
            var annotations = [MKAnnotation]()
                for item in Hosts!{
                let point =  MKPointAnnotation()
                                    
                let lattitude = Double((item.location?.latitude)!)!
                let longitude = Double((item.location?.longitude)!)!
                                                                   
                point.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                point.title = item.member?.firstName
                annotations.append(point)
                    }
                self.mapView.addAnnotations(annotations)
            
                 }
        )
        
        }
    }

}
extension NearByHostMAPCell:MKMapViewDelegate{
   
}


extension NearByHostMAPCell:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location = manager.location{
           let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 50000)!, longitudinalMeters: CLLocationDistance(exactly: 50000)!)
               mapView.setRegion(mapView.regionThatFits(region), animated: true)
            
        }
     
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
