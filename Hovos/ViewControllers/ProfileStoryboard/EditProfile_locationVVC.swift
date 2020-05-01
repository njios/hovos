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
class EditProfile_locationVVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView:GMSMapView!
     @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var placeText:UITextField!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        placeText.text = SharedUser.manager.auth.listing?.location?.location ?? ""
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       if locationManager.location != nil {
        updateMap(lat:locationManager.location!.coordinate.latitude,long:locationManager.location!.coordinate.longitude)
        }else{
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
           
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        updateMap(lat:locationManager.location!.coordinate.latitude,long:locationManager.location!.coordinate.longitude)
    }
    
}
extension EditProfile_locationVVC: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    placeText.text = place.formattedAddress
    updateMap(lat: place.coordinate.latitude, long: place.coordinate.longitude)
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
