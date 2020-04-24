//
//  LocationManager.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/5/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation! {
        if (authorizationStatus) {
            return locationManager.location
        } else {
            return CLLocation(latitude: 37.8267, longitude: -122.423)
        }
    }
    
    var authorizationStatus: Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
             } else {
                // An error occurred during geocoding.
                completionHandler(nil)
                }
            })} else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
