//
//  NetworkError.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/4/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConvertionFailure
    case invalidURL
    case jsonParsingFailure
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed:
            return NSLocalizedString("Request to the server has failed.", comment: "")
        case .responseUnsuccessful:
            return NSLocalizedString("Unable to get a response from the server.", comment: "")
        case .invalidData:
            return NSLocalizedString("The data received from the server was invalid.", comment: "")
        case .jsonConvertionFailure:
            return NSLocalizedString("Unable to convert JSON data.", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid API URL.", comment: "")
        case .jsonParsingFailure:
            return NSLocalizedString("Unable to parse JSON data.", comment: "")
        }
    }
}
