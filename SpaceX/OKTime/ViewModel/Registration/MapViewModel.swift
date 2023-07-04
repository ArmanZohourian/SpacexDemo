//
//  MapViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/6/22.
//

import Foundation
import MapKit

final class MapViewModel: NSObject ,ObservableObject , CLLocationManagerDelegate {
    
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var locationManager : CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() async {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        } else {
            
            print("Show an alert")
            
        }
    }
    
    func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted")
        case .denied:
            print("You have denied this app location go to settings")

        case .authorizedWhenInUse , .authorizedAlways :
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
        @unknown default:
            break
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}
