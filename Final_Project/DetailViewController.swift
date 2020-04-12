//
//  DetailViewController.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-11.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCity : City?
    private let weatherDataModel = WeatherDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        
        weatherDataModel.getWeatherData(searchCity: selectedCity?.city_name ?? "") { [unowned self] (humidityData, tempData, feelsLikeData, highTempData, lowTempData) in
            DispatchQueue.main.async { [weak self] in
                self!.temp.text = String(format: "%.0f", round(tempData ?? 0))
                self!.feelsLike.text = String(format: "%.0f", round(feelsLikeData ?? 0))
                self!.highTemp.text = String(format: "%.0f", round(highTempData ?? 0))
                self!.lowTemp.text = String(format: "%.0f", round(lowTempData ?? 0))
                self!.humidity.text = String(humidityData ?? 0)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
