//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let iconString: String
}

extension CurrentWeather {
    var temperatureString: String {
        return "\(Int(temperature))º"
    }
    
    var humidityString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    
    var precipitationProbabilityString: String {
        let percentageValue = Int(precipitationProbability * 100)
        return "\(percentageValue)%"
    }
    
    var iconImage: UIImage {
        let icon = WeatherIcon(iconString: iconString)
        return icon.image
    }
}

extension CurrentWeather {
    
    struct Key {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipitationProbability = "precipProbability"
        static let summary = "summary"
        static let iconString = "icon"
    }
    
    init?(json: [String: AnyObject]) {
        if let temperature = json[Key.temperature] as? Double,
            let humidity = json[Key.humidity] as? Double,
            let precipitationProbability = json[Key.precipitationProbability] as? Double,
            let summary = json[Key.summary] as? String,
            let iconString = json[Key.iconString] as? String {
            self.temperature = temperature
            self.humidity = humidity
            self.precipitationProbability = precipitationProbability
            self.summary = summary
            self.iconString = iconString
        } else {
            return nil
        }
    }
}
