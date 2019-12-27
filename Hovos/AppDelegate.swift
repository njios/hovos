//
//  AppDelegate.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/1/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
var locationManager: CLLocationManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "256440564385-h4159oo3clbprkg6t8f3btmdvi162l6p.apps.googleusercontent.com"
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
      
        
        if let _ = UserDefaults.standard.value(forKey: constants.accessToken.rawValue){
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "tabvc")
            window?.rootViewController = vc
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

}

extension AppDelegate:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

