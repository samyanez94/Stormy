//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let temperature: Double
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let icon: String
}

extension CurrentWeather {
    
    struct Key {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipitationProbability = "precipProbability"
        static let summary = "summary"
        static let icon = "icon"
    }
    
    init?(json: [String: AnyObject]) {
        guard let temperature = json[Key.temperature] as? Double,
        let humidity = json[Key.humidity] as? Double,
        let precipitationProbability = json[Key.precipitationProbability] as? Double,
        let summary = json[Key.summary] as? String,
        let icon = json[Key.icon] as? String else {
                return nil
        }
        self.temperature = temperature
        self.humidity = humidity
        self.precipitationProbability = precipitationProbability
        self.summary = summary
        self.icon = icon
    }
}
