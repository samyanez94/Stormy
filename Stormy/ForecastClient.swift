//
//  ForecastClient.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum ForecastEndpoint: Endpoint {
    case current(key: String, coordinate: Coordinate)
    
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    var path: String {
        switch self {
        case .current(let key, let coordinate):
            return "/forecast/\(key)/\(coordinate.latitude),\(coordinate.longitude)"
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
    
    func getCurrentWeather(at coordinate: Coordinate, completion: @escaping CurrentWeatherCompletionHandler) {
        
        let request = ForecastEndpoint.current(key: self.key, coordinate: coordinate).request
        
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
