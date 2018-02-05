//
//  APIClient.swift
//  Stormy
//
//  Created by Samuel Yanez on 2/5/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

typealias JSON = [String : AnyObject]
typealias JSONTaskCompletion = (JSON?, NetworkError?) -> Void

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

class APIClient {
    
    let key: String
    let configuration: URLSessionConfiguration
    var session: URLSession
    
    init(configuration: URLSessionConfiguration, key: String) {
        self.configuration = configuration
        self.session = URLSession(configuration: self.configuration)
        self.key = key
    }
    
    convenience init(key: String) {
        self.init(configuration: URLSessionConfiguration.default, key: key)
    }
   
    func JSONTask(with request: URLRequest, completion: @escaping JSONTaskCompletion) -> URLSessionDataTask {
        
        let session = URLSession(configuration: self.configuration)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if HTTPResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConvertionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (T?, NetworkError?) -> Void) {
        
        let task = JSONTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                        return
                }
                if let value = parse(json) {
                    completion(value, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
