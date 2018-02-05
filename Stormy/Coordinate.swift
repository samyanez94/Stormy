//
//  Coordinate.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct Coordinate: CustomStringConvertible{
    let latitude: Double
    let longitude: Double
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
}
