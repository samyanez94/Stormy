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
    
    // Alcatraz Island is set as current location in the case authorization is not given
    var currentLocation: CLLocation! {
        if (authorizationStatus) {
            return locationManager.location
        } else {
            return CLLocation(latitude: 37.8267, longitude: -122.423)
        }
    }
    
    // Checks if the user has enabled location services
    var authorizationStatus: Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
    }
    
    // Request authorization for location services from the user
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Looks up location data from the location coordinates
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
