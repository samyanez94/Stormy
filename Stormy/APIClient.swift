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
    
    /// Typealiases
    typealias JSON = [String : AnyObject]
    typealias JSONTaskCompletion = (JSON?, NetworkError?) -> Void
    
    /// Configuration for the requests
    let key: String
    let configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration, key: String) {
        self.configuration = configuration
        self.key = key
    }
    
    convenience init(key: String) {
        self.init(configuration: URLSessionConfiguration.default, key: key)
    }
   
    /// Creates a task that retrieves the contents of the URL and calls a handler upon completion
    func JSONTask(with request: URLRequest, completion: @escaping JSONTaskCompletion) -> URLSessionDataTask {
        let session = URLSession(configuration: self.configuration)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            guard HTTPResponse.statusCode == 200 else {
                completion(nil, .responseUnsuccessful)
                return
            }
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                completion(json, nil)
            } catch {
                completion(nil, .jsonConvertionFailure)
            }
        }
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (T?, NetworkError?) -> Void) {
        let task = JSONTask(with: request) { json, error in
            DispatchQueue.main.async {
                guard let json = json, let value = parse(json) else {
                    completion(nil, error)
                    return
                }
                completion(value, nil)
            }
        }
        task.resume()
    }
}
