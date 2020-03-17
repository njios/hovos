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
import GoogleMapsUtils



class MapViewController: UIViewController,GMSMapViewDelegate, GMUClusterManagerDelegate  {
    
    private var  mapView:GMSMapView!
    private var clusterManager: GMUClusterManager!
    var Hosts = [VolunteerItem]()
    var currentLocation = CLLocation()
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        mapView.isMyLocationEnabled = true
        //              mapView.camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10.0)
        //
        //              for item in Hosts{
        //                  let lattitude = Double((item.location?.latitude)!)!
        //                  let longitude = Double((item.location?.longitude)!)!
        //
        //                  let marker = customMarker()
        //                  marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        //                  marker.title = item.member?.firstName
        //                  marker.snippet = item.currentLocation
        //
        //                  let markerImage = UIImage.init(named: "mappin")
        //                  let markerView = UIImageView(image: markerImage)
        //
        //                  marker.iconView = markerView
        //                  marker.info = item
        //                  marker.map = self.mapView
        //
        //
        //              }
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
        }else{
            return nil
        }
        infoWindow.center = mapView.projection.point(for: marker.position)
        infoWindow.center.y =  infoWindow.center.y + 100
        return infoWindow
        
    }
    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
    
    
    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    private func generateClusterItems() {
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
            
            clusterManager.add(marker)
        }
    }
    
}
