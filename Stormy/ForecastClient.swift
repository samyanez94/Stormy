//
//  ForecastClient.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

enum ForecastEndpoint: Endpoint {
    case current(key: String, location: CLLocation)
    
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    var path: String {
        switch self {
        case .current(let key, let location):
            return "/forecast/\(key)/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        print(url.absoluteString)
        return URLRequest(url: url)
    }
}

class ForecastClient: APIClient {
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, NetworkError?) -> Void
    
    func getCurrentWeather(at location: CLLocation, completion: @escaping CurrentWeatherCompletionHandler) {
        
        let request = ForecastEndpoint.current(key: self.key, location: location).request
        
        fetch(request, parse: { json -> CurrentWeather? in
            
            // Parse from JSON response to CurrentWeather
            if let currentWeatherDictionary = json["currently"] as? [String : AnyObject] {
                return CurrentWeather(json: currentWeatherDictionary)
            } else {
                return nil
            }
            
            }, completion: completion)
        }
    }
