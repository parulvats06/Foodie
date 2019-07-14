//
//  LocationManager.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate: class {
    func didUpdateLocation(location: CLLocation)
    func locationServicesStatusUpdate(status: CLAuthorizationStatus)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        
    }
    
    func startUpdatingLocation() {
        locationManager?.delegate = nil
        locationManager?.delegate = self
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        locationManager?.delegate = nil
        self.locationManager?.stopUpdatingLocation()
    }
    
    func hasLocationPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            //check if services disallowed for this app particularly
            case .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationServicesStatusUpdate(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // check for cached location
        let age = Date().timeIntervalSince(location.timestamp)
        guard age < 20 else {
            return
        }
         // check for accuracy of location
        guard location.horizontalAccuracy <= 100 else {
            return
        }

        updateLocation(currentLocation: location)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.didUpdateLocation(location: currentLocation)
    }
    
}
