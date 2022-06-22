//
//  LocationManager.swift
//  rain_finder
//
//  Created by Tomasz Zuczek on 22/06/2022.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            // manager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
        }
        
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func requestAuthorization(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status:      CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined         : print("notDetermined")          // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        default                     : print("unknown")              // TODO: handle
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.locationManager.startUpdatingLocation()
        DispatchQueue.main.async {
            self.location = location.coordinate
            print("\(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print (error)
    }
}
