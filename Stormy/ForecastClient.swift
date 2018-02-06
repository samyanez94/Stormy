//
//  ForecastClient.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

// The endpoint describes the path to the resource we are trying to access
struct ForecastEndpoint: Endpoint {
    
    let key: String
    let base: String = "https://api.darksky.net"
    let path: String
    
    var request: URLRequest {
        return URLRequest(url: URL(string: path, relativeTo: URL(string: base))!)
    }
    
    init(key: String, location: CLLocation) {
        self.key = key
        self.path = "/forecast/\(key)/\(location.coordinate.latitude),\(location.coordinate.longitude)"
    }
}

class ForecastClient: APIClient {
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, NetworkError?) -> Void
    
    // Fetches the current weather data from a CLLocation
    func getCurrentWeather(at location: CLLocation, completion: @escaping CurrentWeatherCompletionHandler) {
        
        let endpoint = ForecastEndpoint(key: key, location: location)
        let request = endpoint.request
        
        // Fetch takes a request, a parse clousure to handle the json, and a completition clousure to handle the parsed data
        fetch(request, parse: parse, completion: completion)
    }
    
    // Parses the json data into CurrentWeather
    func parse(json: [String : AnyObject]) -> CurrentWeather? {
        if let currentWeatherDictionary = json["currently"] as? [String : AnyObject] {
            return CurrentWeather(json: currentWeatherDictionary)
        } else {
            return nil
            // TODO: Handle parsing error
        }
    }
}
