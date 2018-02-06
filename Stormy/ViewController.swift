//
//  AppDelegate.swift
//  Stormy
//
//  Created by Samuel Yanez on 1/25/18.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = LocationManager()
    
    let client = ForecastClient(key: "1c5b0f5f869f9b9dfe0a5e478a08ad5e")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        getCurrentWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCurrentWeather() {
        toggleRefreshAnimation(on: true)
        
        client.getCurrentWeather(at: locationManager.currentLocation) { [unowned self] currentWeather, error in
            if let currentWeather = currentWeather {
                self.displayWeather(using: currentWeather)
                self.toggleRefreshAnimation(on: false)
            } else if let error = error {
                self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
            }
        }
    }
    
    func getCurrentLocation() {
        locationManager.lookUpCurrentLocation() { placemark in
            if let placemark = placemark {
               self.currentLocationLabel.text = placemark.locality
            }
        }
    }
    
    func displayWeather(using model: CurrentWeather) {
        
        currentTemperatureLabel.text = model.temperatureString
        currentHumidityLabel.text = model.humidityString
        currentPrecipitationLabel.text = model.precipitationProbabilityString
        currentWeatherIcon.image = model.iconImage
        currentSummaryLabel.text = model.summary
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
