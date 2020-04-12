//
//  WeatherDataModel.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-11.
//

import Foundation

class WeatherDataModel {

    func getWeatherData(searchCity : String, completion: @escaping (Int?, Double?, Double?, Double?, Double?) -> Void) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(searchCity)&units=metric&appid=12dfe5fa0028add5121eda09fbc0d49c") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!)
                
                if let details =  (json as AnyObject).value(forKeyPath: "main") {
                    let humidityData = (details as AnyObject).value(forKeyPath: "humidity") as? Int
                    let tempData = (details as AnyObject).value(forKeyPath: "temp") as? Double
                    let feelsLikeData = (details as AnyObject).value(forKeyPath: "feels_like") as? Double
                    let highTempData = (details as AnyObject).value(forKeyPath: "temp_max") as? Double
                    let lowTempData = (details as AnyObject).value(forKeyPath: "temp_min") as? Double
                    completion(humidityData, tempData, feelsLikeData, highTempData, lowTempData)
                }
            }
            catch {
                print("fetch weather data error")
            }
        }
        
        task.resume()
    }
}
