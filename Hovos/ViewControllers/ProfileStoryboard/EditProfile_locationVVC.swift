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
import GooglePlaces
class EditProfile_locationVVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var placeText:UITextField!
    var locationManager = CLLocationManager()
    let geocoder = GMSGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeText.text = "Search"
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.clear()
        
        
        let marker = customMarker()
        marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        let markerImage = UIImage.init(named: "locationRed")
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map =  self.mapView
        
        
        
        geocoder.reverseGeocodeCoordinate(marker.position) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                self.placeText.text = lines.joined(separator: " ")
                
                
                
                var city = ""
                var countryCode = ""
                var country = ""
                
                
                
                country = (response?.firstResult()?.country) ?? ""
                countryCode = locale(for: (response?.firstResult()?.country) ?? "")
                if let throughFare = response?.firstResult()?.thoroughfare{
                    city = city + throughFare + " "
                }
                if let locality = response?.firstResult()?.locality{
                    city = city + locality + " "
                }
                if let city1 = response?.firstResult()?.administrativeArea{
                    city = city + city1
                }
                
            
                
                SharedUser.manager.auth.listing?.location = location(latitude: "\(marker.position.latitude)", city: city, country: country, countryCode: countryCode, countryId: "", location: lines.joined(separator: " "), longitude: "\(marker.position.longitude)")
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let loc = SharedUser.manager.auth.listing?.location,loc.longitude != ""{
            
            updateMap(lat:Double(loc.latitude! )! ,long:Double(loc.longitude!)!)
        }else{
            if locationManager.location != nil {
                updateMap(lat:locationManager.location!.coordinate.latitude,long:locationManager.location!.coordinate.longitude)
            }else{
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    @IBAction func removeText(_ sender:UIButton){
        placeText.text = ""
    }
    
    func updateMap(lat:CLLocationDegrees,long:CLLocationDegrees){
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 10.0)
        
        let marker = customMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let markerImage = UIImage.init(named: "locationRed")
        let markerView = UIImageView(image: markerImage)
        
        marker.iconView = markerView
        marker.map =  self.mapView
        
        geocoder.reverseGeocodeCoordinate(marker.position) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                self.placeText.text = lines.joined(separator: " ")
                
                
                
                var city = ""
                var countryCode = ""
                var country = ""
                
                
                
                country = (response?.firstResult()?.country) ?? ""
                countryCode = locale(for: (response?.firstResult()?.country) ?? "")
               countryCode = locale(for: (response?.firstResult()?.country) ?? "")
                if let throughFare = response?.firstResult()?.thoroughfare{
                    city = city + throughFare + " "
                }
                if let locality = response?.firstResult()?.locality{
                    city = city + locality + " "
                }
                if let city1 = response?.firstResult()?.administrativeArea{
                    city = city + city1
                }
                
                
                
                SharedUser.manager.auth.listing?.location = location(latitude: "\(marker.position.latitude)", city: city, country: country, countryCode: countryCode, countryId: "", location: lines.joined(separator: " "), longitude: "\(marker.position.longitude)")
            }
            
        }
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.mapView.delegate = self
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        if let loc = SharedUser.manager.auth.listing?.location{
            updateMap(lat: Double(loc.latitude!)!,long: Double(loc.longitude!)!)
        }else{
            updateMap(lat:locationManager.location!.coordinate.latitude,long:locationManager.location!.coordinate.longitude)
        }
    }
    
}
extension EditProfile_locationVVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.delegate = nil
        placeText.text = place.formattedAddress
        updateMap(lat: place.coordinate.latitude, long: place.coordinate.longitude)
        
        
        var city = ""
        var countryCode = ""
        var country = ""
        
        for item in place.addressComponents!{
            if item.types.first == "country"{
                country = item.name
                countryCode = item.shortName ?? ""
            }
            if item.types.first == "administrative_area_level_1"{
                city = item.shortName ?? ""
            }
        }
        
        SharedUser.manager.auth.listing?.location = location(latitude: "\(place.coordinate.latitude)", city: city, country: country, countryCode: countryCode, countryId: "", location: place.formattedAddress ?? "", longitude: "\(place.coordinate.longitude)")
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfile_locationVVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.view.backgroundColor = .clear
        present(acController, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.text = "Search.."
        }
    }
}
 func locale(for fullCountryName : String) -> String {
 
    for localeCode in NSLocale.isoCountryCodes {
        let identifier = NSLocale(localeIdentifier: localeCode)
        let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
        if fullCountryName.lowercased() == countryName?.lowercased() {
            return localeCode
        }
    }
    return ""
}
