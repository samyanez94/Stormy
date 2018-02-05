//
//  AppDelegate.swift
//  Stormy
//
//  Created by Samuel Yanez on 1/25/18.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentWeather = CurrentWeather(temperature: 85.0, humidity: 0.8, precipitationProbability: 0.1, summary: "Go to the pool!", icon: "clear-day")
        let currentWeatherViewModel = CurrentWeatherViewModel(model: currentWeather)
        
        displayWeather(using: currentWeatherViewModel)
        
        let base = URL(string: "https://api.darksky.net/forecast/\(key)/")
        guard let forecastURL = URL(string: "37.8267,-122.4233", relativeTo: base) else { return }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let request = URLRequest(url: forecastURL)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            print(data)
        }
        
        dataTask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentWeatherIcon.image = viewModel.icon
        currentSummaryLabel.text = viewModel.summary
    }
}
