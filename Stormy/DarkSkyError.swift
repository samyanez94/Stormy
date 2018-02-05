//
//  DarkSkyError.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConvertionFailure
    case invalidURL
    case jsonParsingFailure
}
