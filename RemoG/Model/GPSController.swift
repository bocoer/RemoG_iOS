//
//  GPSController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/26/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import CoreLocation

class GPSController: NSObject, CLLocationManagerDelegate {
    let rootController: RootController
    let locationManager: CLLocationManager
    
    init(rootController: RootController) {
        self.rootController = rootController
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        
        updateAuthorization(status: CLLocationManager.authorizationStatus())
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    private func updateAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            rootController.locationAvailability = .disabled
        case .authorizedWhenInUse, .authorizedAlways:
            rootController.locationAvailability = CLLocationManager.locationServicesEnabled() ? .available : .unavailable
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateAuthorization(status: status)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        rootController.locationAvailability = .unavailable
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        rootController.locationAvailability = .available
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if rootController.locationAvailability != .disabled {
            rootController.locationAvailability = .unavailable
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let curLocation = locations.last!
        let speed = Float(curLocation.speed)
        rootController.speed = rootController.speedUnit.convertFrom(mps: speed)
    }
}
