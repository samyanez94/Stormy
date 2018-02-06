//
//  APIClient.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/5/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

protocol Endpoint {
    var key: String { get }
    var base: String { get }
    var path: String { get }
    var request: URLRequest { get }
}

// Simple helper class to handle HTTP requests
class APIClient {
    
    // Typealiases
    typealias JSON = [String : AnyObject]
    typealias JSONTaskCompletion = (JSON?, NetworkError?) -> Void
    
    // Configuration for the requests
    let key: String
    let configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration, key: String) {
        self.configuration = configuration
        self.key = key
    }
    
    convenience init(key: String) {
        self.init(configuration: URLSessionConfiguration.default, key: key)
    }
   
    // Creates a task that retrieves the contents of the URL and calls a handler upon completion
    func JSONTask(with request: URLRequest, completion: @escaping JSONTaskCompletion) -> URLSessionDataTask {
        
        // Starts the new session
        let session = URLSession(configuration: self.configuration)
        
        // Creates a task that retrieves the contents of the URL and calls a handler upon completion.
        let task = session.dataTask(with: request) { data, response, error in
            
            // Checks for potential errors in the request
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            // Checks for potential errors in the response
            guard HTTPResponse.statusCode == 200 else {
                completion(nil, .responseUnsuccessful)
                return
            }
            // Checks for potential errors in the data
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            do {
                // Converts from a Data object in a Foundation object
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                // Calls the completion method on the data as an array
                completion(json, nil)
            } catch {
                // Checks for errors in the convertion
                completion(nil, .jsonConvertionFailure)
            }
        }
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (T?, NetworkError?) -> Void) {
        
        // Creates the new JSON task
        let task = JSONTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                
                // Checks for data and parses it using the parser clousure
                guard let json = json, let value = parse(json) else {
                    // Otherwise calls the clousure handle on the error
                    completion(nil, error)
                    return
                }
                // If the requests success calls the clousure handle on the parsed data
                completion(value, nil)
            }
        }
        // Starts the task by calling its resume method
        task.resume()
    }
}
